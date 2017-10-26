//
//  HttpAccess.m
//  MemorialServicePremium
//
//  Created by pc131101 on 2015/11/05.
//  Copyright © 2015年 DIGITALSPACE WOW. All rights reserved.
//

#import "HttpAccess.h"

@interface HttpAccess()
@end

@implementation HttpAccess

- (NSData *)POST:(NSString *)requestURL param:(NSMutableDictionary *)parameter
{
    NSURL *url = [NSURL URLWithString:requestURL];
    
    //POSTオブジェクト作成
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    //パラメータを生成
    if (0 < [parameter count]) {
        NSArray *keys = [parameter allKeys];
        NSString *strParam = [NSString string];
        
        for (int count = 0; count < [keys count]; count++) {
            NSString *key   = [keys objectAtIndex:count];
            NSString *value = [parameter objectForKey:key];
            
            strParam = [strParam stringByAppendingString:key];
            strParam = [strParam stringByAppendingString:@"="];
            strParam = [strParam stringByAppendingString:value];
            
            if (count < [keys count] - 1) {
                strParam = [strParam stringByAppendingString:@"&"];
            }
        }
        
        //パラメータを設定
        [request setHTTPBody:[strParam dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    //HTTP通信を実行
    NSHTTPURLResponse *response;
    NSError *response_error = nil;
    NSData *requestResult = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&response_error];
    
    //レスポンスから結果を取得
    if (!requestResult || response.statusCode != 200) {
        return nil;
    }
    
    return requestResult;
}

@end