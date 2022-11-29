//
//  DataBase.h
//  EnochCar
//
//  Created by 王海燕 on 2021/6/11.
//

#import <Foundation/Foundation.h>
#import "Spectro.h"

NS_ASSUME_NONNULL_BEGIN

@interface DataBase : NSObject

+(instancetype)defaultDataBase;

-(void)openSearchHistoryList;
-(BOOL)insertASearchText:(NSString *)plateNo;
-(NSArray*)getAllSearchHistory;
-(void)clearSearchHistory;

-(void)openSpectroList;
-(BOOL)insertASpectro:(Spectro *)spectro;
-(BOOL)updateASpectro:(Spectro *)spectro;
-(BOOL)deleteASpectro:(Spectro *)spectro;
-(NSArray <Spectro *>*)getAllSpectro;
-(void)close;

@end

NS_ASSUME_NONNULL_END
