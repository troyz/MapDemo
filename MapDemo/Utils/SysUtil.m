//
//  SysUtil.m
//  Travel
//
//  Created by ISS110302000166 on 15-4-2.
//  Copyright (c) 2015年 isoftstone. All rights reserved.
//

#import "SysUtil.h"

@implementation SysUtil
+ (BOOL) emptyString: (NSString *) aString
{
    return (aString == nil || aString.length == 0 || [aString isEqualToString:@"null"]);
}

+(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1))); //+1,result is [from to]; else is [from, to)!!!!!!!
}
@end
