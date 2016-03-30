/*
 *  UIUtil.h
 *  NC
 *
 *  Created by synnex on 10-12-1.
 *  Copyright 2010 synnex. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface UITool : NSObject
{
}
+ (CGSize)      sizeWithText:(NSString *)txt
                 withMaxSize:(CGSize)maxSize
                withFontSize:(CGFloat)fontSize
               lineBreakMode:(NSLineBreakMode)lineBreakMode;

+ (CGSize)      sizeWithText:(NSString *)txt
                 withMaxSize:(CGSize)maxSize
                    withFont:(UIFont*)font
               lineBreakMode:(NSLineBreakMode)lineBreakMode;

+ (CGSize)      sizeWithAttributedText:(NSAttributedString *)txt
                           withMaxSize:(CGSize)maxSize
                         lineBreakMode:(NSLineBreakMode)lineBreakMode;
/**
 * 将UIColor变换为UIImage
 *
 **/
+ (UIImage *)createImageWithColor:(UIColor *)color;
+ (UIImage *)createImageWithColor:(UIColor *)color withFrame:(CGRect)frame;

+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;
@end


