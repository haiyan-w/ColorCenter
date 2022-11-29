//
//  DataBase.m
//  EnochCar
//
//  Created by 王海燕 on 2021/6/11.
//

#import "DataBase.h"
#import "FMDB.h"

@interface DataBase()
@property(nonatomic,readwrite,strong)FMDatabase * db;
@property(nonatomic,readwrite,weak) DataBase * weakself;
@end

static DataBase * database;

@implementation DataBase

+(instancetype)defaultDataBase
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        database =  [[DataBase alloc] init];
    });
    
    return database;
}

-(instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

-(void)openSearchHistoryList
{
    [self.db close];
    // 0.拼接数据库存放的沙盒路径
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *sqlFilePath = [path stringByAppendingPathComponent:@"searchhisroty.sqlite"];
        
    // 1.通过路径创建数据库
    self.db = [FMDatabase databaseWithPath:sqlFilePath];
        
    // 2.打开数据库
    if ([self.db open]) {
        NSLog(@"打开搜索历史成功");
            
        BOOL success = [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_searchhisroty (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, text TEXT)"];
            
        if (success) {
            NSLog(@"创建searchhisroty表成功");
        } else {
            NSLog(@"创建searchhisroty表失败");
        }
            
    } else {
            NSLog(@"打开searchhisroty失败");
    }
    
}


-(BOOL)insertASearchText:(NSString *)text
{
    BOOL result = NO;
    
    if ([self getCount] >= 10) {
        NSInteger rowID = [self getFirstRowID];
        result = [self.db executeUpdate:@"delete from t_searchhisroty where id = ?",[NSNumber numberWithInteger:rowID]];
        if (!result) {
            return NO;
        }else {
            NSLog(@"删除一条多余数据");
        }
    }
    
    result = [self.db executeUpdate:@"INSERT INTO t_searchhisroty (text) VALUES (?)",text];

    if (result) {
        NSLog(@"插入t_searchhisroty成功");
    } else {
        NSLog(@"插入t_searchhisroty失败");
    }
    return result;
}


-(NSInteger)getCount
{
    NSInteger count = 0;
    FMResultSet *resultSet = [self.db executeQuery:@"SELECT * FROM t_searchhisroty;"];
    // 2.遍历结果
        while ([resultSet next]) {
            count = count +1;
        }
    return count;
}

-(NSInteger)getFirstRowID
{
    NSInteger rowID = 0;
    FMResultSet *resultSet = [self.db executeQuery:@"SELECT * FROM t_searchhisroty ORDER BY id DESC;"];
    // 2.遍历结果
        while ([resultSet next]) {
            rowID = [resultSet intForColumn:@"id"];
        }
    return rowID;
}

-(NSArray*)getAllSearchHistory
{
    NSMutableArray * array = [NSMutableArray array];
    FMResultSet *resultSet = [self.db executeQuery:@"SELECT * FROM t_searchhisroty ORDER BY id DESC limit 10;"];
    // 2.遍历结果
        while ([resultSet next]) {
            NSString *text = [resultSet stringForColumn:@"text"];
            [array addObject:text];
        }
    return array;
}

-(void)clearSearchHistory
{
    BOOL result = [self.db executeUpdate:@"DROP TABLE t_searchhisroty"];
    if (result) {
        
    }
}


-(void)openSpectroList
{
    [self.db close];
    // 0.拼接数据库存放的沙盒路径
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *sqlFilePath = [path stringByAppendingPathComponent:@"spectro.sqlite"];
        
    // 1.通过路径创建数据库
    self.db = [FMDatabase databaseWithPath:sqlFilePath];
        
    // 2.打开数据库
    if ([self.db open]) {
        NSLog(@"打开spectro成功");
            
//        BOOL success = [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_sevice (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, currentMileage INTEGER DEFAULT 0,solution TEXT, descriptions BLOB ,serviceVehicleImgUrls BLOB,comment TEXT, chargingMethod TEXT)"];
        BOOL success = [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_spectro (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,spectroId  INTEGER DEFAULT 0,serialNo TEXT, name TEXT, brand TEXT, manufacturerDate TEXT)"];
            
        if (success) {
            NSLog(@"创建t_spectro表成功");
        } else {
            NSLog(@"创建t_spectro表失败");
        }
            
    } else {
            NSLog(@"打开t_spectro失败");
    }
    
}

-(BOOL)insertASpectro:(Spectro *)spectro
{
    BOOL result = [self.db executeUpdate:@"INSERT INTO t_spectro (spectroId, serialNo, name, brand, manufacturerDate) VALUES (?, ?, ?, ?, ?)",spectro.id, spectro.serialNo, spectro.name, spectro.brand, spectro.manufacturerDate];

    if (result) {
        NSLog(@"插入t_spectro成功");
    } else {
        NSLog(@"插入t_spectro失败");
    }
    return result;
    
}

-(BOOL)updateASpectro:(Spectro *)spectro
{
//    NSData * data = [NSKeyedArchiver  archivedDataWithRootObject:info];
    BOOL result = [self.db executeUpdate:@"UPDATE t_spectro SET serialNo = ? WHERE spectroId = ?",spectro.serialNo,spectro.id];

    if (result) {
        NSLog(@"更新t_spectro成功");
    } else {
        NSLog(@"更新t_spectro失败");
    }
    return result;
}

-(BOOL)deleteASpectro:(Spectro *)spectro
{
    BOOL result = [self.db executeUpdate:@"DELETE FROM t_spectro WHERE spectroId = ?",spectro.id];

    if (result) {
        NSLog(@"t_spectro数据删除成功");
    } else {
        NSLog(@"t_spectro数据删除失败");
    }
    return result;
}

-(NSArray <Spectro *>*)getAllSpectro
{
    NSMutableArray * array = [NSMutableArray array];
    FMResultSet *resultSet = [self.db executeQuery:@"SELECT * FROM t_spectro ORDER BY id DESC;"];
    // 2.遍历结果
        while ([resultSet next]) {
//            NSMutableDictionary * data = [NSMutableDictionary dictionary];
            Spectro * spectro = [[Spectro alloc] init];
            int  spectroId = [resultSet intForColumn:@"spectroId"];
            NSString * serialNo = [resultSet stringForColumn:@"serialNo"];
            NSString * name = [resultSet stringForColumn:@"name"];
            NSString * brand = [resultSet stringForColumn:@"brand"];
            NSString * manufacturerDate = [resultSet stringForColumn:@"manufacturerDate"];
            spectro.id = [NSNumber numberWithInt:spectroId];
            spectro.serialNo = serialNo;
            spectro.name = name;
            spectro.brand = brand;
            spectro.manufacturerDate = manufacturerDate;
            [array addObject:spectro];
        }
    return array;
}


-(void)close
{
    [self.db close];
}

@end
