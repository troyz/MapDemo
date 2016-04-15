//
//  ISSPinAnnotationMapView.m
//  MapDemo
//
//  Created by xdzhangm on 16/3/30.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

#import "ISSPinAnnotationMapView.h"
#import "NAPinAnnotation.h"
#import "NAPinAnnotationView.h"
#import "ISSPinAnnotationView.h"
#import <pop/POP.h>

const CGFloat ISSMapViewAnnotationCalloutAnimationDuration = 0.1f;

@interface ISSPinAnnotationMapView()<ISSPinAnnotationCallOutViewDelegate>
- (IBAction)showCallOut:(id)sender;
- (void)hideCallOut;
@end

@implementation ISSPinAnnotationMapView

- (void)setupMap
{
    [super setupMap];
    
    _calloutView = [[ISSPinAnnotationCallOutView alloc] initOnMapView:self];
    _circleCalloutView = [[ISSSubCirclePinAnnotationCallOutView alloc] initOnMapView:self];
    _calloutView.delegate = self;
    _circleCalloutView.callOutDelegate = self;
    [self addSubview:self.calloutView];
    [self addSubview:_circleCalloutView];
}

- (void)addAnnotation:(NAAnnotation *)annotation animated:(BOOL)animate
{
    [super addAnnotation:annotation animated:animate];
    if ([annotation.view isKindOfClass:NAPinAnnotationView.class]) {
        NAPinAnnotationView *annotationView = (NAPinAnnotationView *) annotation.view;
        [annotationView addTarget:self action:@selector(showCallOut:) forControlEvents:UIControlEventTouchDown];
    }
    [self bringSubviewToFront:self.calloutView];
    [self bringSubviewToFront:self.circleCalloutView];
}

- (void)selectAnnotation:(NAAnnotation *)annotation animated:(BOOL)animate
{
//    [self hideCallOut];
    if([annotation isKindOfClass:NAPinAnnotation.class]) {
        [self showCalloutForAnnotation:(NAPinAnnotation *)annotation animated:animate];
    }
}

- (void)removeAnnotation:(NAAnnotation *)annotation
{
    [self hideCallOut];
    [super removeAnnotation:annotation];
}

- (IBAction)showCallOut:(id)sender
{
    if([sender isKindOfClass:[NAPinAnnotationView class]])
    {
        NAPinAnnotationView *annontationView = (NAPinAnnotationView *)sender;
        
        [self bringSubviewToFront:annontationView];
        
        if ([self.mapViewDelegate respondsToSelector:@selector(mapView:tappedOnAnnotation:)]) {
            [self.mapViewDelegate mapView:self tappedOnAnnotation:annontationView.annotation];
        }
        
        if([annontationView isKindOfClass:[ISSPinAnnotationView class]] && ((ISSPinAnnotationView *)annontationView).annotation.locType == LOC_TYPE_CURRENT)
        {
            NSLog(@"当前位置标记不需要触发点击事件");
        }
        else
        {
            [self showCalloutForAnnotation:annontationView.annotation animated:YES];
        }
    }
}

- (void)showCalloutForAnnotation:(NAPinAnnotation *)annotation animated:(BOOL)animated
{
    NSLog(@"%f, %f", annotation.point.x, annotation.point.y);
    
    if(!self.circleCalloutView.hidden)
    {
        [self.circleCalloutView hideMenu:NO];
    }
    else
    {
        [self hideCallOut];
    }
    
    if([annotation isKindOfClass:[ISSPinAnnotation class]] && ((ISSPinAnnotation *)annotation).menuStyle == POP_UP_MENU_STYLE_CIRCLE)
    {
        [self bringSubviewToFront:self.circleCalloutView];
//        [self.circleCalloutView showMenuAtPoint:annotation.point];
        self.circleCalloutView.annotation = annotation;
    }
    else
    {
        [self bringSubviewToFront:self.calloutView];
        self.calloutView.annotation = annotation;
        
        self.calloutView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1f, 0.1f);
        self.calloutView.hidden = NO;
        
        POPSpringAnimation *scaleAnimatin = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
        scaleAnimatin.toValue = [NSValue valueWithCGSize:CGSizeMake(1, 1)];
        scaleAnimatin.springBounciness = 16;
        [self.calloutView.layer pop_addAnimation:scaleAnimatin forKey:@"scaleAnimatin"];
    }
}

- (void)hideCallOut
{
    self.calloutView.hidden = YES;
    if(!self.circleCalloutView.hidden)
    {
        [self.circleCalloutView hideMenu:YES];
    }
}

- (void)updatePlayButtonText
{
    [self.calloutView updatePlayButtonText];
    [self.circleCalloutView updatePlayButtonText];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.dragging) {
        [self hideCallOut];
    }
    
    [super touchesEnded:touches withEvent:event];
}

- (void)updatePositions
{
    [self.calloutView updatePosition];
    [self.circleCalloutView updatePosition];
    [super updatePositions];
}

- (void)playerButtonTapped:(NAPinAnnotation *)annotation
{
    if(_mapDelegate && [_mapDelegate respondsToSelector:@selector(playerButtonTapped:)])
    {
        [_mapDelegate playerButtonTapped:annotation];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(!self.circleCalloutView.hidden)
    {
        [self.circleCalloutView updatePosition];
    }
    [self checkAnnotationViewVisible];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(!self.circleCalloutView.hidden)
    {
        [self.circleCalloutView updatePosition];
    }
    [self checkAnnotationViewVisible];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(!self.circleCalloutView.hidden)
    {
        [self.circleCalloutView updatePosition];
    }
    [self checkAnnotationViewVisible];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [super scrollViewDidZoom:scrollView];
    if(!self.circleCalloutView.hidden)
    {
        [self.circleCalloutView updatePosition];
    }
    [self checkAnnotationViewVisible];
}

- (void)checkAnnotationViewVisible
{
    if(_circleCalloutView.hidden && _calloutView.hidden)
    {
        return;
    }
    UIView *view = _circleCalloutView.hidden ? _calloutView.annotation.view : _circleCalloutView.annotation.view;
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    CGRect viewBounds = [view convertRect:view.bounds toView:nil];
    if(!CGRectIntersectsRect(viewBounds, screenBounds))
    {
        [self hideCallOut];
    }
}
@end
