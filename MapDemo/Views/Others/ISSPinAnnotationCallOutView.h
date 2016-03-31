//
//  ISSPinAnnotationCallOutView.h
//  MapDemo
//
//  Created by xdzhangm on 16/3/30.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

#import "NAPinAnnotation.h"
#import "NAMapView.h"

@protocol ISSPinAnnotationCallOutViewDelegate <NSObject>
@optional
- (void)playerButtonTapped:(NAPinAnnotation *)annotation;
@end

@interface ISSPinAnnotationCallOutView : UIView
/// Create a new callout view on a map.
- (id)initOnMapView:(NAMapView *)mapView;

/// Recalculate position on map according to zoom level.
- (void)updatePosition;
- (void)updatePlayButtonText;

/// Pin annotation.
@property(readwrite, nonatomic, strong) NAPinAnnotation *annotation;
@property (nonatomic, weak) id<ISSPinAnnotationCallOutViewDelegate> delegate;
@end
