//
//  ISSPinAnnotationMapView.h
//  MapDemo
//
//  Created by xdzhangm on 16/3/30.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

#import "NAPinAnnotationMapView.h"
#import "ISSPinAnnotationCallOutView.h"

@protocol ISSPinAnnotationMapViewDelegate <NSObject>
@optional
- (void)playerButtonTapped:(NAPinAnnotation *)annotation;
@end

@interface ISSPinAnnotationMapView : NAPinAnnotationMapView
@property (nonatomic, strong) ISSPinAnnotationCallOutView *calloutView;
@property (nonatomic, weak) id<ISSPinAnnotationMapViewDelegate> mapDelegate;
@end
