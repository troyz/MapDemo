//
//  ISSSubCirclePinAnnotationCallOutView.m
//  MapDemo
//
//  Created by xdzhangm on 16/4/15.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

#import "ISSSubCirclePinAnnotationCallOutView.h"
#import "ISSPinAnnotation.h"

@interface ISSSubCirclePinAnnotationCallOutView()<ISSCirclePinAnnotationCallOutViewDelegate>

@end

@implementation ISSSubCirclePinAnnotationCallOutView

- (id)initOnMapView:(NAMapView *)mapView
{
    self = [super initOnMapView:mapView];
    if(self)
    {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.delegate = self;
    
    [[self playBtnView] addTarget:self action:@selector(playButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [[self playBtnView] setTitle:@"播放" forState:UIControlStateNormal];
    [[self menuAtIndex:1] setTitle:@"详情" forState:UIControlStateNormal];
}

- (void)playButtonTapped
{
    if(_callOutDelegate && [_callOutDelegate respondsToSelector:@selector(playerButtonTapped:)])
    {
        [_callOutDelegate playerButtonTapped:_annotation];
    }
    [self updatePlayButtonText];
}

- (UIButton *)playBtnView
{
    return [self menuAtIndex:0];
}

- (void)setAnnotation:(NAPinAnnotation *)annotation
{
    _annotation = annotation;
    [self showMenuAtPoint:annotation.point];
    [self updatePosition];
    [self updatePlayButtonText];
}

- (void)updatePlayButtonText
{
    if([_annotation isKindOfClass:[ISSPinAnnotation class]])
    {
        ISSPinAnnotation *annotation = (ISSPinAnnotation *)_annotation;
        if([annotation isPlaying])
        {
            [[self playBtnView] setTitle:@"暂停" forState:UIControlStateNormal];
        }
        else if([annotation isPaused])
        {
            [[self playBtnView] setTitle:@"继续" forState:UIControlStateNormal];
        }
        else
        {
            [[self playBtnView] setTitle:@"播放" forState:UIControlStateNormal];
        }
    }
}

- (NSInteger)numbersOfCircleForCallOutView
{
    return 2;
}

- (CGPoint)screenCenterPointForCallOutView
{
    CGPoint point = self.mapView.contentOffset;
    point.x += self.mapView.bounds.size.width  / 2.0;
    point.y += self.mapView.bounds.size.height / 2.0;
    return point;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
