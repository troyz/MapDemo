//
//  ISSPinAnnotationView.m
//  MapDemo
//
//  Created by xdzhangm on 16/3/30.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

#import "ISSPinAnnotationView.h"

const CGFloat ISSMapViewAnnotationPinWidth = 36.0f;
const CGFloat ISSMapViewAnnotationPinHeight = 38.0f;
const CGFloat ISSMapViewAnnotationPinPointX = 14.0f;
const CGFloat ISSMapViewAnnotationPinPointY = 36.0f;

@interface ISSPinAnnotationView()
@property (nonatomic, weak) NAMapView *mapView;
@end

@implementation ISSPinAnnotationView

- (id)initWithAnnotation:(ISSPinAnnotation *)annotation onMapView:(NAMapView *)mapView
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.mapView = mapView;
        self.annotation = annotation;
        self.animating = NO;
    }
    return self;
}

- (void)setAnimating:(BOOL)animating
{
//    self.animating = animating;
    
    NSString *pinImageName = @"db_poi_ticket";
    switch (self.annotation.locType) {
        case LOC_TYPE_TICKET:
            pinImageName = @"db_poi_ticket";
            break;
        case LOC_TYPE_BAR:
            pinImageName = @"db_poi_bar";
            break;
        case LOC_TYPE_DEPOT:
            pinImageName = @"db_poi_depot";
            break;
        case LOC_TYPE_SCENIC:
            pinImageName = @"db_poi_museum";
            break;
        case LOC_TYPE_TOILET:
            pinImageName = @"db_poi_toilet";
            break;
        case LOC_TYPE_CURRENT:
            pinImageName = @"icon_center_point";
            break;
    }
    
    UIImage *pinImage = [UIImage imageNamed:pinImageName];
    [self setImage:pinImage forState:UIControlStateNormal];
}

- (void)updatePosition
{
    CGPoint point = [self.mapView zoomRelativePoint:self.annotation.point];
    if(self.annotation.locType == LOC_TYPE_CURRENT)
    {
        UIImage *image = [self imageForState:UIControlStateNormal];
        point.x = point.x - image.size.width / 2.0;
        point.y = point.y - image.size.height / 2.0;
        self.frame = CGRectMake(point.x, point.y, image.size.width, image.size.height);
    }
    else
    {
        point.x = point.x - ISSMapViewAnnotationPinPointX;
        point.y = point.y - ISSMapViewAnnotationPinPointY;
        self.frame = CGRectMake(point.x, point.y, ISSMapViewAnnotationPinWidth, ISSMapViewAnnotationPinHeight);
    }
}

@end