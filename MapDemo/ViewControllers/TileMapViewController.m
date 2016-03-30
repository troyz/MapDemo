//
//  TileMapViewController.m
//  MapDemo
//
//  Created by iss110302000283 on 16/3/29.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

#import "TileMapViewController.h"
#import "NATiledImageMapView.h"
#import "NAPinAnnotation.h"
#import "MapLocationItemModel.h"
#import "FileUtil.h"
#import <ARTiledImageView/ARLocalTiledImageDataSource.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

@interface TileMapViewController ()
{
    BMKMapPoint leftTopCoor;
    MapItemModel *mapItem;
    NATiledImageMapView *mapView;
    ARLocalTiledImageDataSource *dataSource;
}
@end

@implementation TileMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    mapItem = [[MapItemModel arrayOfModelsFromData:[FileUtil readFileFromPath:@"hand_drawing_map_list.json"] error:nil] objectAtIndex:0];
    
    leftTopCoor = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(mapItem.topLeftLat, mapItem.topLeftLng));
    
    dataSource = [[ARLocalTiledImageDataSource alloc] init];
    dataSource.maxTiledHeight = 1920;
    dataSource.maxTiledWidth = 1080;
    dataSource.minTileLevel = 9;
    dataSource.maxTileLevel = 11;
    dataSource.tileSize = 256;
    dataSource.tileFormat = @"jpg";
    dataSource.tileBasePath = [NSString stringWithFormat:@"%@/Maps/bailixia", [NSBundle mainBundle].resourcePath];
    
    mapView = [[NATiledImageMapView alloc] initWithFrame:self.view.bounds tiledImageDataSource:dataSource];
    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    mapView.displayTileBorders = YES;

    mapView.backgroundColor  = [UIColor colorWithRed:0.000f green:0.475f blue:0.761f alpha:1.000f];
    mapView.zoomStep = 3.0f;
    
    [self.view addSubview:mapView];
    
    for(NSInteger i = 0; i < mapItem.locationList.count; i++)
    {
        MapLocationItemModel *locItem = mapItem.locationList[i];
        NAPinAnnotation *melbourne = [NAPinAnnotation annotationWithPoint:[self locationCoordToCgPoint:CLLocationCoordinate2DMake(locItem.lat, locItem.lng)]];
        melbourne.title = locItem.name;
        melbourne.subtitle = @"I have a subtitle 野三坡景区商业街 I have a subtitle 野三坡景区商业街 I have a subtitle 野三坡景区商业街 I have a subtitle 野三坡景区商业街 I have a subtitle 野三坡景区商业街 I have a subtitle 野三坡景区商业街 ";
        melbourne.color = i % 3;
        [mapView addAnnotation:melbourne animated:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [mapView zoomToFit:animated];
}

- (CGPoint)locationCoordToCgPoint:(CLLocationCoordinate2D)coor
{
    BMKMapPoint point = BMKMapPointForCoordinate(coor);
    return CGPointMake((point.x - leftTopCoor.x) * mapItem.zoomRate, (point.y - leftTopCoor.y) * mapItem.zoomRate);
}

- (CLLocationCoordinate2D)cgPointToLocationCoord:(CGPoint)point
{
    BMKMapPoint mapPoint;
    mapPoint.x = point.x / mapItem.zoomRate + leftTopCoor.x;
    mapPoint.y = point.y / mapItem.zoomRate + leftTopCoor.y;
    return BMKCoordinateForMapPoint(mapPoint);
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

@end
