//
//  ISSPinAnnotationCallOutViewDelegate.h
//  MapDemo
//
//  Created by xdzhangm on 16/4/15.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ISSPinAnnotationCallOutViewDelegate <NSObject>
@optional
- (void)playerButtonTapped:(NAPinAnnotation *)annotation;
@end