//
//  ISSCirclePinAnnotationCallOutView.h
//  MapDemo
//
//  Created by xdzhangm on 16/4/11.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NAMapView.h"

@protocol ISSCirclePinAnnotationCallOutViewDelegate <NSObject>
@required
- (NSInteger)numbersOfCircleForCallOutView;
@optional
- (CGPoint)screenCenterPointForCallOutView;
- (void)circleButton:(UIButton *)btnView atIndex:(NSInteger)i;
@end

@interface ISSCirclePinAnnotationCallOutView : UIView
- (id)initOnMapView:(NAMapView *)mapView;
- (void)showMenuAtPoint:(CGPoint)point;
- (void)hideMenu:(BOOL)animated;
- (void)updatePosition;
@property (nonatomic, weak)   NAMapView *mapView;
@property (nonatomic, weak) id<ISSCirclePinAnnotationCallOutViewDelegate> delegate;
@end
