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
// 景区名称
@property (nonatomic, copy) NSString *scenicName;
// 手绘图原始图片，可以是本地图片或者网络图片
@property (nonatomic, copy) NSString *imgName;
// 瓦片图片路径，可以是本地或者网络地址
@property (nonatomic, copy) NSString *tileImageFolder;
// 图片左上角经纬度
@property (nonatomic, assign) CGFloat topLeftLat;
@property (nonatomic, assign) CGFloat topLeftLng;
/**
 * 手绘图跟标准平面图尺寸比例，标准平面坐标是在百度地图18级
 * 即如果18级，则zoomRate=1
 * 如果19级，则zoomRate=1.991150442477876
 */
@property (nonatomic, assign) CGFloat zoomRate;
// 原始图片尺寸
@property (nonatomic, assign) NSInteger originalImageWidth;
@property (nonatomic, assign) NSInteger originalImageHeight;
// 瓦片的最小、大level
@property (nonatomic, assign) NSInteger minTileLevel;
@property (nonatomic, assign) NSInteger maxTileLevel;
// 瓦片尺寸，默认256
@property (nonatomic, assign) NSInteger tileSize;
@property (nonatomic, strong) NSMutableArray<MapLocationItemModel> *locationList;
// 如果是本地图片的话，返回图片本地全路径，
- (NSString *)localImageFullPath;
// 是否有瓦片
- (BOOL)hasTiles;
// 是否是服务端瓦片
- (BOOL)isRemoteTiles;
@end