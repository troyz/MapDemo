//
//  SysUtil.h
//  Travel
//
//  Created by ISS110302000166 on 15-4-2.
//  Copyright (c) 2015年 isoftstone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SysUtil : NSObject
+ (BOOL) emptyString: (NSString *) aString;
/**
 *  获取随机数
 *
 *  @param from 最小值，包含
 *  @param to   最大值，包含
 *
 *  @return 随机数
 */
+(int)getRandomNumber:(int)from to:(int)to;
@end
