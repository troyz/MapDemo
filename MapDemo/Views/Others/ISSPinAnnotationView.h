//
//  ISSPinAnnotationView.h
//  MapDemo
//
//  Created by xdzhangm on 16/3/30.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

#import "ISSPinAnnotation.h"
#import "NAMapView.h"
#import "NAPinAnnotationView.h"

/**
 *  A pin annotation view the behaves like a button.
 */
@interface ISSPinAnnotationView : NAPinAnnotationView

/// Associated NAPinAnnotation.
@property (readwrite, nonatomic, weak) ISSPinAnnotation *annotation;
/// Animate the pin.
//@property (readwrite, nonatomic, assign) BOOL animating;

/// Create a view for a pin annotation on a map.
- (id)initWithAnnotation:(ISSPinAnnotation *)annotation onMapView:(NAMapView *)mapView;
/// Update the pin position when the map is zoomed in or zoomed out.
- (void)updatePosition;

@end
