//
//  HttpAccess.h
//  MemorialServicePremium
//
//  Created by pc131101 on 2015/11/05.
//  Copyright © 2015年 DIGITALSPACE WOW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpAccess : NSObject

- (NSData *)POST:(NSString *)requestURL param:(NSMutableDictionary *)parameter;

@end