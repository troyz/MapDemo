//
//  ISSPinAnnotation.m
//  MapDemo
//
//  Created by xdzhangm on 16/3/30.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

#import "ISSPinAnnotation.h"
#import "ISSPinAnnotationView.h"

const CGFloat ISSMapViewPinAnimationDuration = 0.5f;

@interface ISSPinAnnotation ()
@property (nonatomic, readonly, weak) ISSPinAnnotationView *view;
@end

@implementation ISSPinAnnotation

- (id)initWithPoint:(CGPoint)point
{
    self = [super initWithPoint:point];
    if (self)
    {
        self.locType = LOC_TYPE_SCENIC;
        self.title = nil;
    }
    return self;
}

- (UIView *)createViewOnMapView:(NAMapView *)mapView
{
    return [[ISSPinAnnotationView alloc] initWithAnnotation:self onMapView:mapView];
}

- (void)addToMapView:(NAMapView *)mapView animated:(BOOL)animate
{
    [super addToMapView:mapView animated:animate];
    
    if (animate) {
        self.view.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0.0f, -self.view.center.y);
    }
    
    [mapView addSubview:self.view];
    
    if (animate) {
        self.view.animating = YES;
        [UIView animateWithDuration:ISSMapViewPinAnimationDuration animations:^{
            self.view.transform = CGAffineTransformIdentity;
        } completion:^ (BOOL finished) {
            self.view.animating = NO;
        }];
    }
}

- (void)updatePosition
{
    [self.view updatePosition];
}

- (BOOL)isPlaying
{
    return _playerStatus == TTS_PLAYER_STATUS_PLAYING;
}

- (BOOL)isPaused
{
    return _playerStatus == TTS_PLAYER_STATUS_PAUSE;
}

- (void)play
{
    _playerStatus = TTS_PLAYER_STATUS_PLAYING;
}

- (void)pause
{
    _playerStatus = TTS_PLAYER_STATUS_PAUSE;
}

- (void)stop
{
    _playerStatus = TTS_PLAYER_STATUS_NONE;
}
@end