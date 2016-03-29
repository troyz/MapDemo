//
//  FileUtil.m
//  Travel
//
//  Created by ISS110302000166 on 15-4-3.
//  Copyright (c) 2015年 isoftstone. All rights reserved.
//

#import "FileUtil.h"
#import "SysUtil.h"

@implementation FileUtil

+ (NSData *) readFileFromPath:(NSString *)path
{
    path = [[NSBundle mainBundle] pathForResource:path ofType:nil];
    return [NSData dataWithContentsOfFile:path];
}

+ (NSString *) readFileTextFromPath:(NSString *)path
{
    path = [[NSBundle mainBundle] pathForResource:path ofType:nil];
    NSError *error;
    NSString *textFileContents = [NSString
                                  stringWithContentsOfFile:path
                                  encoding:NSUTF8StringEncoding
                                  error:&error];
    if(error)
    {
        NSLog(@"read file %@ failed, %@", path, error);
    }
    return textFileContents;
}

+ (void)deleteFileAtPath:(NSString *)filePath
{
    if([SysUtil emptyString:filePath])
    {
        return;
    }
    NSLog(@"file path 1: %@", filePath);
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    BOOL bRet = [fileMgr fileExistsAtPath:filePath];
    if (bRet)
    {
        //
        NSError *err;
        [fileMgr removeItemAtPath:filePath error:&err];
        NSLog(@"%@ delete file %@", err ? @"Fail" : @"Success", filePath);
    }
}
@end
