//
//  ISSPinAnnotation.h
//  MapDemo
//
//  Created by xdzhangm on 16/3/30.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

#import "NAAnnotation.h"
#import "NAPinAnnotation.h"

@interface ISSPinAnnotation : NAPinAnnotation
@property (nonatomic, assign) ISSLocationType locType;
@property (nonatomic, copy) NSString *imgPath;
@end
