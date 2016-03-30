//
//  MapLocationItemModel.h
//  MapDemo
//
//  Created by iss110302000283 on 16/3/29.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

#import "ISSJSONModel.h"

@protocol MapLocationItemModel <NSObject>
@end

@interface MapLocationItemModel : ISSJSONModel
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) CGFloat lat;
@property (nonatomic, assign) CGFloat lng;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, assign) ISSLocationType locType;
@end

@interface MapItemModel : ISSJSONModel
@property (nonatomic, copy) NSString *imgName;
@property (nonatomic, assign) CGFloat topLeftLat;
@property (nonatomic, assign) CGFloat topLeftLng;
@property (nonatomic, assign) CGFloat zoomRate;
@property (nonatomic, strong) NSMutableArray<MapLocationItemModel> *locationList;
@end