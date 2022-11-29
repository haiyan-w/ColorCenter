//
//  BleManager.m
//  ColorCenter
//
//  Created by 王海燕 on 2022/10/19.
//

#import "BlueToothManager.h"
#import "CommonDefine.h"
#import "CommonTool.h"


@interface BlueToothManager() <CBCentralManagerDelegate, CBPeripheralDelegate, CBPeripheralManagerDelegate>

@end

@implementation BlueToothManager

static BlueToothManager * bleManager;


+(instancetype)defaultManager
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        bleManager = [[BlueToothManager alloc] init];
    });
    
    return bleManager;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.centerManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        
        self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
    }
    return self;
}

- (void)setStatus:(BLEStatus)status
{
    _status = status;
    
    if (self.delegate ) {
        [self.delegate BLEManagerDidUpdateState:status];
    }
}

- (NSMutableArray<CBPeripheral *> *)scanedPeripherals
{
    if (!_scanedPeripherals) {
        _scanedPeripherals = [NSMutableArray array];
    }
    return _scanedPeripherals;
}


- (void)startScan
{
    //扫描周边设备
    self.status = BLE_Scanning;
    
    //扫描特定测色仪
    CBUUID *uuid = [CBUUID UUIDWithString:@"0000E0FF-3C17-D293-8E48-14FE2E4DA212"];
    [self.centerManager scanForPeripheralsWithServices:@[uuid] options:nil];
    
    __weak typeof(self) weakSelf = self;
    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:20.0 repeats:NO block:^(NSTimer * _Nonnull timer) {
        __strong typeof(self) strongSelf = weakSelf;
        
        if ([strongSelf.centerManager isScanning]) {
            [strongSelf.centerManager stopScan];
        }
        
        if (strongSelf.status == BLE_Scanning) {
            strongSelf.status = BLE_ScanFinished;
        }
        
    }];
}

- (void)stopScan
{
    if ([self.centerManager isScanning]) {
        [self.centerManager stopScan];
    }
}


- (void)connect:(CBPeripheral *)peripheral
{
    self.status = BLE_Connecting;
    [self.centerManager connectPeripheral:peripheral
                        options:@{CBConnectPeripheralOptionNotifyOnConnectionKey:@YES}];
}


- (void)disConnect
{
    [self.centerManager cancelPeripheralConnection:self.peripheral];
}

#pragma mark delegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case CBManagerStatePoweredOn:
        {
            self.isPowerOn = YES;
            if (self.status == BLE_Default) {
                [self startScan];
            }
        }
            break;
            
        default:
        {
            self.isPowerOn = NO;
            [CommonTool showHint:@"蓝牙未开启"];
        }
            break;
    }

}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    if ((nil == peripheral) || (nil == peripheral.identifier)) {
        return;
    }
    
    if (![self isPeripheralExist:peripheral] && peripheral.name.length > 0) {
        [self.scanedPeripherals addObject:peripheral];
        if (self.delegate ) {
            [self.delegate BLEManagerDidUpdatePeripheral:self.scanedPeripherals];
        }
    }
}


- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    [self.centerManager stopScan];
    self.peripheral = peripheral;
    [peripheral setDelegate:self];
    [peripheral discoverServices:nil];
    NSLog(@"%@连接成功", peripheral.name);
    self.status = BLE_ConnectSuccess;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(BLEManagerDidConnectPeripheral:)]) {
        [self.delegate BLEManagerDidConnectPeripheral:peripheral];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_BLE_CONNECT object:nil];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error
{
    self.status = BLE_ConnectFail;
    NSLog(@"蓝牙连接失败");
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error
{
    NSLog(@"%@断开链接", peripheral.name);
    self.peripheral = nil;
    self.status = BLE_disConnect;
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_BLE_DISCONNECT object:nil];
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    switch (peripheral.state) {
        case CBManagerStatePoweredOn:
        {
            
        }
            break;
            
        default:
            break;
    }
    
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(nullable NSError *)error
{
    if (error) {
        return;
    }
    self.peripheral = peripheral;
    
    for (CBService * service in peripheral.services) {
        if ([service.UUID.UUIDString isEqualToString:@"0000E0FF-3C17-D293-8E48-14FE2E4DA212"]) {
            [self.peripheral discoverCharacteristics:nil forService:service];
        }
        
    }

}


- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(nullable NSError *)error
{
    if (error) {
        return;
    }
    
    for (CBCharacteristic * characteristic in service.characteristics) {
        NSLog(@"service UUID:%@ characteristic:%@",service.UUID.UUIDString, characteristic.UUID.UUIDString);
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFE1"]]) {
            self.writeCharacteristic = characteristic;
        }

        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFE2"]]) {
            self.notifyCharacteristic = characteristic;
            [self.peripheral setNotifyValue:YES forCharacteristic:self.notifyCharacteristic];
        }
        
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFE3"]]) {
            // read write notify

        }
        
    }
    
}


- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error
{
    //读取外设发来的数据
    //数据转换
    NSData * data = characteristic.value;
    NSUInteger dataLen = data.length;

    if (!self.needUnion) {
        BleCommand * cmd = [[BleCommand alloc] initWithData:data];
        self.curData = [NSMutableData dataWithData:[characteristic.value subdataWithRange:NSMakeRange(0, dataLen)]];
        self.totalLen = cmd.len;

    }else {
        //拼包
        [self.curData appendData:data];
    }
    
    if ((self.curData.length-4) >= self.totalLen) {
        //拼包完成
        self.needUnion = NO;
    }else {
        self.needUnion = YES;
    }
    
    if (!self.needUnion) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(BLEManagerDidRecieveData:)]) {
            [self.delegate BLEManagerDidRecieveData:self.curData];
        }
    }
}

//- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error
//{
//    //读取外设发来的数据
//
//    //数据转换
//    NSString * uuid = characteristic.UUID.UUIDString;
//    NSData * data = characteristic.value;
//    NSUInteger dataLen = data.length;
//    NSString * dataStr = @"";
//
//    BOOL receiveFinished  = NO;
//
//    struct BleCommond cmd;
//
//    if (!self.needUnion) {
//
//
//        Byte type = [self unsignedDataTointWithData:data Location:0 Offset:1];
//        Byte cmdcode = [self unsignedDataTointWithData:data Location:1 Offset:1];
//        uint16_t len = [self unsignedDataTointWithData:data Location:2 Offset:2];
//
//        if ((dataLen - 4) < len) {
//            self.needUnion = YES;
//            self.totalLen = len;
////            self.cmd_Type = type;
////            self.cmd = cmdcode;
//            self.curData = [NSMutableData dataWithData:[characteristic.value subdataWithRange:NSMakeRange(4, data.length - 4)]];
//        }else {
//            void * result = malloc((size_t)(dataLen-4));
//            [data getBytes:result range:NSMakeRange(4, (dataLen-4))];
//            cmd.cmd_type = type;
//            cmd.cmd = cmdcode;
//            cmd.len = len;
//            cmd.data = result;
//            if ((0x01 == cmd.cmd) ||(0x02 == cmd.cmd)){
//                uint32_t count = [self unsignedDataTointWithData:self.curData Location:4 Offset:cmd.len];
//                dataStr = [NSString stringWithFormat:@"%d",count];
//            }else if ((0x03 == cmd.cmd) ||(0x04 == cmd.cmd)){
//                NSData * parmData = [data subdataWithRange:NSMakeRange(4, data.length - 4)];
//                dataStr = [[NSString alloc] initWithData:parmData encoding:kCFStringEncodingUTF8];
//            }else {
//                NSData * parmData = [data subdataWithRange:NSMakeRange(4, data.length - 4)];
//                dataStr = [[NSString alloc] initWithData:parmData encoding:kCFStringEncodingUTF8];
//            }
//
//            receiveFinished  = YES;
//
//        }
//    }else {
//        //拼包
//        [self.curData appendData:data];
//
//        if ((self.curData.length-4) >= self.totalLen) {
//            //拼包完成
//            self.needUnion = NO;
//
////            struct BleCommond cmd;
//            Byte type = [self unsignedDataTointWithData:self.curData Location:0 Offset:1];
//            Byte cmdcode = [self unsignedDataTointWithData:self.curData Location:1 Offset:1];
//            uint16_t len = [self unsignedDataTointWithData:self.curData Location:2 Offset:2];
//            NSData * totalData = [self.curData subdataWithRange:NSMakeRange(4, self.curData.length - 4)];
//            cmd.cmd_type = type;
//            cmd.cmd = cmdcode;
//            cmd.len = len;
////            cmd.data = result;
//            if ((0x01 == cmd.cmd) ||(0x02 == cmd.cmd)){
//                uint32_t count = [self unsignedDataTointWithData:self.curData Location:4 Offset:cmd.len];
//                dataStr = [NSString stringWithFormat:@"%d",count];
//            }else if ((0x03 == cmd.cmd) ||(0x04 == cmd.cmd)){
//                dataStr = [[NSString alloc] initWithData:totalData encoding:kCFStringEncodingUTF8];
//            }else {
//                dataStr = [[NSString alloc] initWithData:totalData encoding:kCFStringEncodingUTF8];
//            }
//
//            receiveFinished  = YES;
//        }
//
//    }
//
//    if (receiveFinished) {
//        if (self.delegate && [self.delegate respondsToSelector:@selector(BLEManagerDidRecieveData:)]) {
//            [self.delegate BLEManagerDidRecieveData:cmd];
//        }
//    }
//
//}
    
    
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error
{
    if (error) {
        //写入数据失败
        NSLog(@"蓝牙写入数据失败");
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error
{
    if (characteristic.isNotifying) {
        
    }
    
}

- (BOOL)isPeripheralExist:(CBPeripheral *)peripheral
{
    for (CBPeripheral * peripheral2 in self.scanedPeripherals) {
        if ([peripheral.identifier.UUIDString isEqualToString:peripheral2.identifier.UUIDString]) {
            return YES;
        }
    }
    return NO;
}

//分包发送蓝牙数据
-(void)sendMsgWithSubPackage:(NSData*)msgData
                  Peripheral:(CBPeripheral*)peripheral
              Characteristic:(CBCharacteristic*)character
{
    for (int i = 0; i < [msgData length]; i += BLE_SEND_MAX_LEN) {
        // 预加 最大包长度，如果依然小于总数据长度，可以取最大包数据大小
        if ((i + BLE_SEND_MAX_LEN) < [msgData length]) {
            NSString *rangeStr = [NSString stringWithFormat:@"%i,%i", i, BLE_SEND_MAX_LEN];
            NSData *subData = [msgData subdataWithRange:NSRangeFromString(rangeStr)];
            NSLog(@"%@",subData);
            [self writeCharacteristic:peripheral
                       characteristic:character
                                value:subData];
            //根据接收模块的处理能力做相应延时
            usleep(20 * 1000);
        }
        else {
            NSString *rangeStr = [NSString stringWithFormat:@"%i,%i", i, (int)([msgData length] - i)];
            NSData *subData = [msgData subdataWithRange:NSRangeFromString(rangeStr)];
            [self writeCharacteristic:peripheral
                       characteristic:character
                                value:subData];
            usleep(20 * 1000);
        }
    }
}


- (void)writeCharacteristic:(CBPeripheral*)peripheral characteristic:(CBCharacteristic*)character value:(NSData*)msgData
{
    [peripheral writeValue:msgData forCharacteristic:character type:CBCharacteristicWriteWithResponse];
}

//-(void)data:(nonnull NSData *)data toCmd:(void *)cmdPtr
//{
//    struct BleCommond cmd;
//    NSUInteger dataLen = data.length;
//    Byte type = [self unsignedDataTointWithData:data Location:0 Offset:1];
//    Byte cmdcode = [self unsignedDataTointWithData:data Location:1 Offset:1];
//    uint16_t len = [self unsignedDataTointWithData:data Location:2 Offset:2];
//    void * result = malloc((size_t)(dataLen-4));
//    [data getBytes:result range:NSMakeRange(4, (dataLen-4))];
//
//    cmd.cmd_type = type;
//    cmd.cmd = cmdcode;
//    cmd.len = len;
//    cmd.data = result;
//    cmdPtr = &cmd;
//}

//
//- (NSData *)cmdToData:(struct BleCommond)bleCommond
//{
//    NSMutableData * data = [NSMutableData data];
//    [data appendBytes:&bleCommond.cmd_type length:1];
//    [data appendBytes:&bleCommond.cmd length:1];
//    [data appendBytes:&bleCommond.len length:2];
//    [data appendBytes:&bleCommond.data length:bleCommond.len];
//
//    return data;
//}
//
//- (NSData *)bleCommandToData:(struct BleCommond)bleCommond
//{
//    NSMutableData * data = [NSMutableData data];
//    [data appendBytes:&bleCommond.cmd_type length:1];
//    [data appendBytes:&bleCommond.cmd length:1];
//    [data appendBytes:&bleCommond.len length:2];
//    [data appendBytes:&bleCommond.data length:bleCommond.len];
//
//    return data;
//}
//

//// 转为本地大小端模式 返回Signed类型的数据
//-(signed int)signedDataTointWithData:(NSData *)data Location:(NSInteger)location Offset:(NSInteger)offset {
//    signed int value=0;
//    NSData *intdata= [data subdataWithRange:NSMakeRange(location, offset)];
//    if (offset==2) {
//        value=CFSwapInt16BigToHost(*(int*)([intdata bytes]));
//    }
//    else if (offset==4) {
//        value = CFSwapInt32BigToHost(*(int*)([intdata bytes]));
//    }
//    else if (offset==1) {
//        signed char *bs = (signed char *)[[data subdataWithRange:NSMakeRange(location, 1) ] bytes];
//        value = *bs;
//    }
//    return value;
//}
//
//// 转为本地大小端模式 返回Unsigned类型的数据
//-(unsigned int)unsignedDataTointWithData:(NSData *)data Location:(NSInteger)location Offset:(NSInteger)offset {
//    unsigned int value=0;
//    NSData *intdata= [data subdataWithRange:NSMakeRange(location, offset)];
//
//    if (offset==2) {
//        value=CFSwapInt16LittleToHost(*(int*)([intdata bytes]));
//    }
//    else if (offset==4) {
//        value = CFSwapInt16LittleToHost(*(int*)([intdata bytes]));
//    }
//    else if (offset==1) {
//        unsigned char *bs = (unsigned char *)[[data subdataWithRange:NSMakeRange(location, 1) ] bytes];
//        value = *bs;
//    }
//    return value;
//}
//

#pragma mark 3nh cmd

- (void)sendCommend:(NSData *)cmdData
{
    [self.peripheral writeValue:cmdData forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithResponse];
}



//- (void)createSession
//{
//    Byte byte[] = {0x06, 0xde,0xa1, 0x01, 0x02, 0x77, 0x34, 0x0a};
//    [self.peripheral writeValue:[NSData dataWithBytes:byte length:8] forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithResponse];
//}
//
//- (void)closeSession
//{
//    Byte byte[] = {0x06, 0xde,0xa1, 0x03, 0x04, 0x77, 0x34, 0x0a};
//    [self.peripheral writeValue:[NSData dataWithBytes:byte length:8] forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithResponse];
//}
//
//- (void)check
//{
//    struct BleCommond cmd;
//    cmd.cmd_type = 0x02;
//    cmd.cmd = 0x00;
//    cmd.len = 0;
//    NSData * data = [self cmdToData:cmd];
//    [self.peripheral writeValue:data forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithResponse];
//}
//
//
//- (void)standardAmount
//{
//    struct BleCommond cmd;
//    cmd.cmd_type = 0x02;
//    cmd.cmd = 0x01;
//    cmd.len = 0;
//    NSData * data = [self cmdToData:cmd];
//    [self.peripheral writeValue:data forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithResponse];
//}
//
//- (void)model
//{
//    struct BleCommond cmd;
//    cmd.cmd_type = 0x02;
//    cmd.cmd = 0x03;
//    cmd.len = 0;
//    NSData * data = [self cmdToData:cmd];
//    [self.peripheral writeValue:data forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithResponse];
//}
//
//- (void)measure
//{
//    struct BleCommond cmd;
//    cmd.cmd_type = 0x01;
//    cmd.cmd = 0x04;
//    cmd.len = 1;
//    Byte appenddata[1] = {0x00};
//    cmd.data = appenddata;
//    NSData * data = [self cmdToData:cmd];
//    [self.peripheral writeValue:data forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithResponse];
//}



@end
