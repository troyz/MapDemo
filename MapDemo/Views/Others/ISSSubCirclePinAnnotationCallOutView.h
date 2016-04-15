//
//  ISSSubCirclePinAnnotationCallOutView.h
//  MapDemo
//
//  Created by xdzhangm on 16/4/15.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

#import "ISSCirclePinAnnotationCallOutView.h"
#import "NAPinAnnotation.h"
#import "ISSPinAnnotationCallOutViewDelegate.h"

@interface ISSSubCirclePinAnnotationCallOutView : ISSCirclePinAnnotationCallOutView
- (void)updatePlayButtonText;
@property (readwrite, nonatomic, strong) NAPinAnnotation *annotation;
@property (nonatomic, weak) id<ISSPinAnnotationCallOutViewDelegate> callOutDelegate;
@end
