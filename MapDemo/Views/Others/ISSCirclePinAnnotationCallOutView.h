//
//  ISSCirclePinAnnotationCallOutView.h
//  MapDemo
//
//  Created by xdzhangm on 16/4/11.
//  Copyright © 2016年 isoftstone. All rights reserved.
//
/*
                |
                |
                |
             topLine
                |
                |
                |
    b1                      b0
 
 
 b3      |  CenterView   |        b2
 
 
 b5                               b4
                |
 
                b6
 */
#import <UIKit/UIKit.h>
#import "NAMapView.h"

@protocol ISSCirclePinAnnotationCallOutViewDelegate <NSObject>
@required
- (NSInteger)numbersOfCircleForCallOutView;
@optional
- (CGPoint)screenCenterPointForCallOutView;
@end

@interface ISSCirclePinAnnotationCallOutView : UIView
- (id)initOnMapView:(NAMapView *)mapView;
- (void)showMenuAtPoint:(CGPoint)point;
- (void)hideMenu:(BOOL)animated;
- (void)updatePosition;

// 右0，左1，右2，左3，右4，左5，下6
- (UIButton *)menuAtIndex:(NSInteger)index;
@property (nonatomic, weak)   NAMapView *mapView;
@property (nonatomic, weak) id<ISSCirclePinAnnotationCallOutViewDelegate> delegate;
@end
