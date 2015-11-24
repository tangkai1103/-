//
//  WebService.h
//  CCalDemo
//
//  Created by lanou3g on 15/11/23.
//  Copyright © 2015年 Mr Tang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebService : NSObject<NSXMLParserDelegate, NSURLConnectionDelegate>
@property (nonatomic,strong) NSMutableData *webData;
@property (nonatomic,strong) NSMutableString *soapResults;
@property (nonatomic,strong) NSXMLParser *xmlParser;
@property (nonatomic,assign) BOOL elementFound;
@property (nonatomic,copy) NSString* matchingElement;
@property (nonatomic,strong) NSURLConnection *conn;

/**
 @brief   查询方法
 */
- (void)query:(NSString *)phoneNumber;
@end
