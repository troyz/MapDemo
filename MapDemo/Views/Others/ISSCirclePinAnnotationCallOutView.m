//
//  ISSCirclePinAnnotationCallOutView.m
//  MapDemo
//
//  Created by xdzhangm on 16/4/11.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

#import "ISSCirclePinAnnotationCallOutView.h"
#import <pop/POP.h>

#define VIEW_W_H                260
#define CENTER_W_H              110
#define BUTTON_W_H              44
// 大、小圆心之间距离
#define C_C_LENGTH              (VIEW_W_H / 2.0 - BUTTON_W_H / 2.0)
#define C_C_LENGTH_SIN          (sin(M_PI / 4.0) * C_C_LENGTH)
#define MAX_SMALL_CIRCLE        7

@interface ISSCirclePinAnnotationCallOutView()
{
    UIView *centerView;
    NSMutableDictionary *frameDict;
    CGPoint mapAtPoint;
    CGPoint atPoint;
    BOOL isHiddening;
}
@end

@implementation ISSCirclePinAnnotationCallOutView
- (instancetype)init
{
    return [self initOnMapView:nil];
}
- (id)initOnMapView:(NAMapView *)mapView
{
    self = [super init];
    if(self)
    {
        self.mapView = mapView;
        [self initVariables];
        [self initViews];
        
        self.hidden = YES;
        [self hideMenu];
    }
    return self;
}

- (void)initVariables
{
    frameDict = [[NSMutableDictionary alloc] init];
}

- (CGFloat)getMenuAngle:(NSInteger)i
{
    return M_PI * 0.25 * (i - 1);
}

- (void)initViews
{
    self.frame = CGRectMake(0, 0, VIEW_W_H, VIEW_W_H);
    
    centerView = [[UIView alloc] init];
    centerView.backgroundColor = [UIColor orangeColor];
    centerView.frame = CGRectMake((VIEW_W_H - CENTER_W_H) / 2.0, (VIEW_W_H - CENTER_W_H) / 2.0, CENTER_W_H, CENTER_W_H);
    centerView.clipsToBounds = YES;
    centerView.layer.cornerRadius = CENTER_W_H / 2.0;
    [self addSubview:centerView];
    
    UIImage *lineImage = [UITool createImageWithColor:[UIColor blackColor] withFrame:CGRectMake(0, 0, VIEW_W_H / 2.0 - BUTTON_W_H, 1)];
    
    UIImageView *lineView = [[UIImageView alloc] initWithImage:lineImage];
    lineView.frame = CGRectMake(VIEW_W_H / 2.0, 0, lineImage.size.height, VIEW_W_H / 2.0);
    lineView.tag = 10;
    [self addSubview:lineView];
    [self sendSubviewToBack:lineView];
    
    for(NSInteger i = 0; i < MAX_SMALL_CIRCLE; i++)
    {
        CGFloat angle = [self getMenuAngle:i];
        
        UIButton *btnView = [UIButton buttonWithType:UIButtonTypeCustom];
        btnView.tag = (i + 1);
        [btnView setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        btnView.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [btnView setTitle:[NSString stringWithFormat:@"b%zd", (i + 1)] forState:UIControlStateNormal];
        btnView.clipsToBounds = YES;
        btnView.layer.cornerRadius = BUTTON_W_H / 2.0;
        btnView.layer.borderColor = RGBColor(0, 0, 0).CGColor;
        btnView.layer.borderWidth = 1.0;
        btnView.frame = CGRectMake(VIEW_W_H / 2.0 + cos(angle) * C_C_LENGTH - BUTTON_W_H / 2.0, VIEW_W_H / 2.0 + sin(angle) * C_C_LENGTH - BUTTON_W_H / 2.0, BUTTON_W_H, BUTTON_W_H);
        
        [btnView setBackgroundImage:[UITool createImageWithColor:RGBColor(0, 0, 0)] forState:UIControlStateHighlighted];
        [btnView setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self addSubview:btnView];
        
        UIImageView *lineView = [[UIImageView alloc] initWithImage:lineImage];
        lineView.frame = CGRectMake(VIEW_W_H / 2.0, VIEW_W_H / 2.0, lineImage.size.width, lineImage.size.height);
        lineView.tag = (10 + btnView.tag);
        lineView.transform = [self getTransformWithCenter:lineView.center withPoint:centerView.center withAngle:angle];
        [self addSubview:lineView];
        [self sendSubviewToBack:lineView];
        
        [frameDict setObject:[NSValue valueWithCGPoint:btnView.center] forKey:@(btnView.tag)];
    }
    
    [self bringSubviewToFront:centerView];
}

- (CGAffineTransform) getTransformWithCenter:(CGPoint)center
                                   withPoint:(CGPoint)point
                                   withAngle:(CGFloat)angle
{
    CGFloat x = point.x - center.x; //计算(x,y)从(0,0)为原点的坐标系变换到(CenterX ，CenterY)为原点的坐标系下的坐标
    CGFloat y = point.y - center.y; //(0，0)坐标系的右横轴、下竖轴是正轴,(CenterX,CenterY)坐标系的正轴也一样
    
    CGAffineTransform  trans = CGAffineTransformMakeTranslation(x, y);
    trans = CGAffineTransformRotate(trans,angle);
    trans = CGAffineTransformTranslate(trans,-x, -y);
    return trans;
}

- (void)updatePosition
{
    if(self.mapView)
    {
        atPoint = [self.mapView zoomRelativePoint:mapAtPoint];
    }
    CGFloat angle = [self getAngleByPoint:atPoint center:[self screenCenterPoint]];
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = [self getTransformWithCenter:self.center withPoint:atPoint withAngle:angle];
        for(NSInteger i = 0; i < MAX_SMALL_CIRCLE; i++)
        {
            UIButton *btnView = [self viewWithTag:i + 1];
            btnView.transform = CGAffineTransformMakeRotation(-angle);
        }
    }];
}

- (void)showMenuAtPoint:(CGPoint)point
{
    mapAtPoint = point;
    if(self.mapView)
    {
        atPoint = [self.mapView zoomRelativePoint:mapAtPoint];
    }
    else
    {
        atPoint = point;
    }
    self.transform = CGAffineTransformIdentity;
    CGRect frame = self.frame;
    self.frame = CGRectMake(atPoint.x - VIEW_W_H / 2.0, atPoint.y, frame.size.width, frame.size.height);
    
    CGFloat angle = [self getAngleByPoint:atPoint center:[self screenCenterPoint]];
    for(NSInteger i = 0; i < MAX_SMALL_CIRCLE; i++)
    {
        UIButton *btnView = [self viewWithTag:i + 1];
        btnView.transform = CGAffineTransformIdentity;
        btnView.transform = CGAffineTransformMakeRotation(-angle);
    }
    self.transform = [self getTransformWithCenter:self.center withPoint:atPoint withAngle:angle];
    self.hidden = NO;
    [self showCenterView];
}

- (CGPoint)screenCenterPoint
{
    if(_delegate && [_delegate respondsToSelector:@selector(screenCenterPointForCallOutView)])
    {
        return [_delegate screenCenterPointForCallOutView];
    }
    return self.superview.center;
}

-(CGFloat)getAngleByPoint:(CGPoint)nowPoint center:(CGPoint)center
{
    if(nowPoint.y == center.y)
    {
        if(nowPoint.x >= center.x)
        {
            return M_PI;
        }
        else
        {
            return -M_PI;
        }
    }
    if(nowPoint.x >= center.x && nowPoint.y >= center.y)
    {
        return M_PI - atan((nowPoint.x - center.x) / (nowPoint.y - center.y));
    }
    else if(nowPoint.x >= center.x && nowPoint.y <= center.y)
    {
        return atan((nowPoint.x - center.x) / (center.y - nowPoint.y));
    }
    else if(nowPoint.x <= center.x && nowPoint.y >= center.y)
    {
        return - (M_PI - atan((center.x - nowPoint.x) / (nowPoint.y - center.y)));
    }
    else
    {
        return - atan((center.x - nowPoint.x) / (center.y - nowPoint.y));
    }
}

- (void)showMenu:(NSNumber *)num
{
    NSInteger i = [num integerValue];
    if(((i + 1) > (MAX_SMALL_CIRCLE + 1) / 2) || ((i + 1) > (([self menuCount] / 2) + ([self menuCount] % 2 == 0 ? 0 : 1))))
    {
        return;
    }
    for(NSInteger _i = 0; _i < MAX_SMALL_CIRCLE; _i++)
    {
        if(_i == i || _i + i == MAX_SMALL_CIRCLE - 1)
        {
            if([self menuCount] % 2 != 0 && (i + 1) * 2 > [self menuCount] && _i != i)
            {
                continue;
            }
            POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerSize];
            animation.springSpeed = 16;
            
            UIView *view = [self viewWithTag:_i + 11];
            animation.toValue = [NSValue valueWithCGSize:CGSizeMake(VIEW_W_H / 2.0 - BUTTON_W_H, 1.0)] ;
            if(_i == i)
            {
                [self performSelector:@selector(showMenu:) withObject:@(i + 1) afterDelay:0.15];
            }
            [view.layer pop_addAnimation:animation forKey:@"animation"];
            
            [UIView animateWithDuration:0.2 animations:^{
                UIView *view = [self viewWithTag:_i + 1];
                view.center = [((NSValue *)[frameDict objectForKey:@(view.tag)]) CGPointValue];
            }];
        }
    }
}

- (void)hideMenu
{
    if(isHiddening)
    {
        return;
    }
    isHiddening = YES;
    for(NSInteger i = 0; i < MAX_SMALL_CIRCLE; i++)
    {
        POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerSize];
        animation.springSpeed = 3;
        UIView *view = [self viewWithTag:i + 11];
        animation.toValue = [NSValue valueWithCGSize:CGSizeMake(CENTER_W_H / 2.0 - BUTTON_W_H, 1.0)];
        [view.layer pop_addAnimation:animation forKey:@"animation"];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        for(NSInteger i = 0; i < MAX_SMALL_CIRCLE; i++)
        {
            UIView *view = [self viewWithTag:i + 1];
            view.transform = CGAffineTransformIdentity;
            view.center = CGPointMake(VIEW_W_H / 2.0 + (CENTER_W_H / 2.0 - BUTTON_W_H / 2.0) * cos([self getMenuAngle:i]), VIEW_W_H / 2.0 + (CENTER_W_H / 2.0 - BUTTON_W_H / 2.0) * sin([self getMenuAngle:i]));
        }
    } completion:^(BOOL finished) {
        [self hideCenterView];
    }];
}

- (void)hideCenterView
{
    [self toggleShowSmallCircle:NO];
    
    UIView *topLineView = [self viewWithTag:10];
    
    POPSpringAnimation *sizeAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerSize];
    sizeAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(topLineView.frame.size.width, 0)];
    
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
    positionAnimation.toValue = [NSValue valueWithCGPoint:topLineView.frame.origin];
    
    [topLineView.layer pop_addAnimation:sizeAnimation forKey:@"sizeAnimation"];
    [topLineView.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
    
    
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeZero];
    
    positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
    positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(VIEW_W_H / 2.0, 0)];
    
    [centerView.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    [centerView.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.hidden = YES;
        isHiddening = NO;
    });
}

- (void)showCenterView
{
    UIView *topLineView = [self viewWithTag:10];
    
    POPSpringAnimation *sizeAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerSize];
    sizeAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(topLineView.frame.size.width, VIEW_W_H / 2.0)];
    
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
    positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(VIEW_W_H / 2.0, VIEW_W_H / 4.0)];
    
    [topLineView.layer pop_addAnimation:sizeAnimation forKey:@"sizeAnimation"];
    [topLineView.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
    
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0, 1.0)];
    
    positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
    positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(VIEW_W_H / 2.0, VIEW_W_H / 2.0)];
    
    [centerView.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    [centerView.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self toggleShowSmallCircle:YES];
        [self showMenu:@(0)];
    });
}

- (void)toggleShowSmallCircle:(BOOL)isShow
{
    for(NSInteger i = 0; i < MAX_SMALL_CIRCLE; i++)
    {
        [self viewWithTag:(i + 1)].hidden = !isShow;
        [self viewWithTag:(i + 11)].hidden = !isShow;
    }
}

- (NSInteger)menuCount
{
    if(_delegate && [_delegate respondsToSelector:@selector(numbersOfCircleForCallOutView)])
    {
        return [_delegate numbersOfCircleForCallOutView];
    }
    return 0;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
