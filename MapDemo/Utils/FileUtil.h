//
//  FileUtil.h
//  Travel
//
//  Created by ISS110302000166 on 15-4-3.
//  Copyright (c) 2015年 isoftstone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileUtil : NSObject

+ (NSData *) readFileFromPath:(NSString *)path;

+ (NSString *) readFileTextFromPath:(NSString *)path;

+ (void)deleteFileAtPath:(NSString *)filePath;
@end
