/*
 *  UIUtil.m
 *  NC
 *
 *  Created by synnex on 10-12-1.
 *  Copyright 2010 synnex. All rights reserved.
 *
 */

#import "UITool.h"

@implementation UITool
+ (CGSize) sizeWithText:(NSString *)txt withMaxSize:(CGSize)maxSize withFontSize:(CGFloat)fontSize lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    return [self sizeWithText:txt withMaxSize:maxSize withFont:[UIFont systemFontOfSize:fontSize] lineBreakMode:lineBreakMode];
}

+ (CGSize)      sizeWithText:(NSString *)txt
                 withMaxSize:(CGSize)maxSize
                    withFont:(UIFont*)font
               lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    CGSize size = CGSizeMake(0, 0);
    if(![txt isKindOfClass:[NSString class]])
    {
        return size;
    }
#ifdef __IPHONE_7_0
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    size = [txt boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dict context:nil].size;
#else
    size = [txt sizeWithFont:font constrainedToSize:maxSize lineBreakMode:lineBreakMode];
#endif
    size.width = ceil(size.width);
    size.height = ceil(size.height);
    return size;
}

+ (CGSize)      sizeWithAttributedText:(NSAttributedString *)txt
                 withMaxSize:(CGSize)maxSize
               lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    CGSize size;
    NSStringDrawingContext *context = [NSStringDrawingContext new];
    context.minimumTrackingAdjustment = 7;

    
    size = [txt boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:context].size;

    size.width = ceil(size.width);
    size.height = ceil(size.height);
    return size;
}


/**
 * 将UIColor变换为UIImage
 *
 **/
+ (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    return [self createImageWithColor:color withFrame:rect];
}

+ (UIImage *)createImageWithColor:(UIColor *)color withFrame:(CGRect)frame
{
    UIGraphicsBeginImageContext(frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, frame);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize

{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
@end
