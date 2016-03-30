//
//  ISSTiledImageMapView.h
//  MapDemo
//
//  Created by xdzhangm on 16/3/30.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

#import "ISSPinAnnotationMapView.h"
#import <ARTiledImageView/ARTiledImageViewDataSource.h>

@interface ISSTiledImageMapView : ISSPinAnnotationMapView
- (id)initWithFrame:(CGRect)frame tiledImageDataSource:(NSObject <ARTiledImageViewDataSource> *)dataSource;

/// Zoom the map view to fit the current display.
- (void)zoomToFit:(BOOL)animate;

/// Display tile borders, usually for debugging purposes.
@property (readwrite, nonatomic, assign) BOOL displayTileBorders;

/// Set a background image, displayed while tiles are being downloaded.
@property (readwrite, nonatomic) NSURL *backgroundImageURL;

/// Set a background image, displayed while tiles are being downloaded.
@property (readwrite, nonatomic) UIImage *backgroundImage;

/// The current tile zoom level based on the DeepZoom algorithm.
@property (readonly, nonatomic, assign) NSInteger tileZoomLevel;
@end
