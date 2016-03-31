//
//  NSString+Addtions.h
//  Travel
//
//  Created by ISS110302000166 on 15-4-30.
//  Copyright (c) 2015年 isoftstone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Addtions)
- (NSString *) base64String;
- (NSString *) utf8String;
+ (NSString *) base64StringFromData:(NSData *)data length:(int)length;
- (NSString *) urlEncode;
+(NSString*)urlEncode:(NSString *)value;
- (NSString *) urlDecode;
+(NSString*)urlDecode:(NSString *)value;
- (BOOL) isUrl;
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
- (NSString *)trim;
@end
