//
//  BleManager.h
//  ColorCenter
//
//  Created by 王海燕 on 2022/10/19.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BleCmdDefine.h"
#import "BleCommand.h"

NS_ASSUME_NONNULL_BEGIN




typedef enum
{
    BLE_Default,
    BLE_Scanning,
    BLE_ScanFinished,
    BLE_Connecting,
    BLE_ConnectSuccess,
    BLE_ConnectFail,
    BLE_disConnect,
    BLE_ReceivingData
    
}BLEStatus;

@protocol BLEManagerDelegate <NSObject>

- (void)BLEManagerDidUpdateState:(BLEStatus)status;
- (void)BLEManagerDidUpdatePeripheral:(NSArray *)scanedPeripherals;
- (void)BLEManagerDidConnectPeripheral:(CBPeripheral *)peripheral;
- (void)BLEManagerDidRecieveData:(NSData *)recievedData;
@end


@interface BlueToothManager : NSObject
@property (nonatomic, strong) CBPeripheralManager * peripheralManager;
@property (nonatomic, strong) CBCentralManager * centerManager;
@property (nonatomic, strong) NSMutableArray <CBPeripheral *> * scanedPeripherals;//蓝牙扫描结果
@property (nonatomic, strong) NSMutableArray <CBPeripheral *> * connectedPeripherals;//蓝牙扫描结果
@property (nonatomic, strong) CBPeripheral * peripheral;
@property (nonatomic, strong) CBService * service;
@property (nonatomic, strong) CBCharacteristic * writeCharacteristic;
@property (nonatomic, strong) CBCharacteristic * notifyCharacteristic;

@property (nonatomic, assign) BOOL isPowerOn; //蓝牙是否开启

@property (nonatomic, strong) NSMutableData * curData;//拼包数据
@property (nonatomic, assign) uint16_t totalLen;//拼包数据总长度
@property (nonatomic, assign) BOOL needUnion;

@property (nonatomic, weak) id delegate;
@property (nonatomic, assign) BLEStatus status;

+(instancetype)defaultManager;

- (void)startScan;
- (void)stopScan;
- (void)connect:(CBPeripheral *)peripheral;
- (void)disConnect;

- (void)sendCommend:(NSData *)cmdData;
@end

NS_ASSUME_NONNULL_END
