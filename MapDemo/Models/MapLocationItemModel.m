//
//  MapLocationItemModel.m
//  MapDemo
//
//  Created by iss110302000283 on 16/3/29.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

#import "MapLocationItemModel.h"
#import "NSString+Addtions.h"

@implementation MapLocationItemModel

@end

@implementation MapItemModel
- (void)setImgName:(NSString *)imgName
{
    _imgName = imgName;
    if(_imgName && ![_imgName isUrl] && !_originalImageHeight && !_originalImageWidth)
    {
        UIImage *image = [UIImage imageWithContentsOfFile:[self localImageFullPath]];
        if(image)
        {
            _originalImageWidth = image.size.width;
            _originalImageHeight = image.size.height;
        }
    }
}

- (NSString *)localImageFullPath
{
    if(_imgName && ![_imgName isUrl])
    {
        return [[[NSBundle mainBundle] bundlePath] stringByAppendingString:[NSString stringWithFormat:@"/%@", _imgName]];
    }
    return @"";
}
@end