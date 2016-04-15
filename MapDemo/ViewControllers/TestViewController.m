//
//  TestViewController.m
//  MapDemo
//
//  Created by xdzhangm on 16/4/12.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

#import "TestViewController.h"
#import "ISSCirclePinAnnotationCallOutView.h"

@interface TestViewController ()<ISSCirclePinAnnotationCallOutViewDelegate>
{
    ISSCirclePinAnnotationCallOutView *outView;
    NSInteger i;
    UIView *view;
}
@end

@implementation TestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    i = 0;
    
    outView = [[ISSCirclePinAnnotationCallOutView alloc] init];
    outView.delegate = self;
    CGRect frame = outView.frame;
    frame.origin.x = 50;
    frame.origin.y = 100;
    outView.frame = frame;
    [self.view addSubview:outView];
    
    self.view.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    tapGestureRecognizer.numberOfTouchesRequired = 1;
    
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    view = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    view.layer.anchorPoint = CGPointMake(0.5, 0);
    view.backgroundColor = [UIColor orangeColor];
    view.layer.position = CGPointMake(150, 100);
    [self.view addSubview:view];
    
    UIView *pView = [[UIView alloc] initWithFrame:CGRectMake(150, 100, 2, 2)];
    pView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:pView];
}

-(void)handleTapGesture:(UIGestureRecognizer*)gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view];
    [outView showMenuAtPoint:point];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)buttonTapped:(id)sender
{
    i++;
    [outView hideMenu:YES];
}

- (IBAction)rotateButtonTapped:(id)sender
{
    view.transform = CGAffineTransformRotate(view.transform, M_PI_4);
}

- (NSInteger)numbersOfCircleForCallOutView
{
    return i % 8;
}

- (void)circleButton:(UIButton *)btnView atIndex:(NSInteger)i
{
    
}
@end
