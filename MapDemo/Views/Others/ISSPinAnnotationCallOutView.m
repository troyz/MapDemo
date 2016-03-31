//
//  ISSPinAnnotationCallOutView.m
//  MapDemo
//
//  Created by xdzhangm on 16/3/30.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

#import "ISSPinAnnotationCallOutView.h"
#import "ISSPinAnnotation.h"

const CGFloat ISSMapViewAnnotationCalloutAnchorYOffset = 30.0f;

@interface ISSPinAnnotationCallOutView()
@property (nonatomic, weak)   NAMapView *mapView;
@property (nonatomic, assign) CGPoint position;
@property (nonatomic, strong) UIButton *leftBtnView;
@property (nonatomic, strong) UIButton *rightBtnView;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleView;
@property (nonatomic, strong) UIButton *playBtnView;
@end

@implementation ISSPinAnnotationCallOutView
- (id)initOnMapView:(NAMapView *)mapView
{
    self = [super init];
    if (self)
    {
        [self createViews];
        
        self.mapView                       = mapView;
        self.hidden                        = YES;
    }
    return self;
}

- (void)createViews
{
    // create left/right views
    _leftBtnView = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtnView = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftBtnView.enabled = NO;
    _rightBtnView.enabled = NO;
    [_leftBtnView setBackgroundImage:[[UIImage imageNamed:@"icon_paopao_middle_left_highlighted.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 10, 40, 10) resizingMode:UIImageResizingModeTile] forState:UIControlStateDisabled];
    [_rightBtnView setBackgroundImage:[[UIImage imageNamed:@"icon_paopao_middle_right_highlighted.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 10, 40, 10) resizingMode:UIImageResizingModeTile] forState:UIControlStateDisabled];
    [self addSubview:_leftBtnView];
    [self addSubview:_rightBtnView];
    
    CGFloat width = kScreenWidth - 180;
    CGFloat v_h_margin = 8;
    
    // create other views
    _imgView = [[UIImageView alloc] init];
    _imgView.contentMode = UIViewContentModeScaleAspectFill;
    _imgView.frame = CGRectMake(3, 0, width - 3 * 2 - 1, 100);
    _imgView.clipsToBounds = YES;
    [self addSubview:_imgView];
    
    _titleView = [[UILabel alloc] init];
    _titleView.font = [UIFont systemFontOfSize:16.0];
    _titleView.textColor = [UIColor blackColor];
    _titleView.textAlignment = NSTextAlignmentCenter;
    CGSize size = [UITool sizeWithText:@"" withMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) withFont:_titleView.font lineBreakMode:NSLineBreakByCharWrapping];
    
    _titleView.frame = CGRectMake(v_h_margin, _imgView.frame.origin.y + _imgView.frame.size.height + v_h_margin, width - 2 * v_h_margin, size.height);
    [self addSubview:_titleView];
    
    _playBtnView = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playBtnView addTarget:self action:@selector(playButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [_playBtnView setTitle:@"播放" forState:UIControlStateNormal];
    _playBtnView.titleLabel.font = [UIFont systemFontOfSize:14.0];
    _playBtnView.clipsToBounds = YES;
    _playBtnView.layer.cornerRadius = 3.0;
    _playBtnView.backgroundColor = [UIColor orangeColor];
    [_playBtnView setBackgroundImage:[UITool createImageWithColor:RGBColor(227, 111, 41)] forState:UIControlStateHighlighted];
    [_playBtnView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _playBtnView.frame = CGRectMake(width / 4.0, _titleView.frame.origin.y + _titleView.frame.size.height + v_h_margin, width / 2.0, 35);
    [self addSubview:_playBtnView];
    
    self.frame = CGRectMake(0, 0, width, _playBtnView.frame.origin.y + _playBtnView.frame.size.height + 3 * v_h_margin);
    [self updateViewFrame];
    
    self.layer.masksToBounds = YES;
    self.clipsToBounds = YES;
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii: (CGSize){10.0f, 10.0f}].CGPath;
    self.layer.mask = maskLayer;
}

- (void)playButtonTapped
{
    if(_delegate && [_delegate respondsToSelector:@selector(playerButtonTapped:)])
    {
        [_delegate playerButtonTapped:_annotation];
    }
    [self updatePlayButtonText];
}

- (void)setAnnotation:(NAPinAnnotation *)annotation
{
    _annotation = annotation;
    self.position = annotation.point;
    _imgView.image = [UIImage imageNamed:@"temp.png"];
    _titleView.text = annotation.title;
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
            [_playBtnView setTitle:@"暂停" forState:UIControlStateNormal];
        }
        else if([annotation isPaused])
        {
            [_playBtnView setTitle:@"继续" forState:UIControlStateNormal];
        }
        else
        {
            [_playBtnView setTitle:@"播放" forState:UIControlStateNormal];
        }
    }
}

- (void)updateViewFrame
{
    _leftBtnView.frame = CGRectMake(0, 0, self.frame.size.width / 2.0, self.frame.size.height);
    _rightBtnView.frame = CGRectMake(self.frame.size.width / 2.0, 0, self.frame.size.width / 2.0, self.frame.size.height);
}

#pragma - Private helpers

- (void)updatePosition
{
    CGPoint point = [self.mapView zoomRelativePoint:self.position];
    CGFloat xPos = point.x - (self.frame.size.width / 2.0f);
    CGFloat yPos = point.y - (self.frame.size.height) - ISSMapViewAnnotationCalloutAnchorYOffset;
    self.frame = CGRectMake(floor(xPos), yPos, self.frame.size.width, self.frame.size.height);
}
@end
