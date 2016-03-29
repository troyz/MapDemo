//
//  WebTileMapViewController.m
//  MapDemo
//
//  Created by iss110302000283 on 16/3/29.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

#import "WebTileMapViewController.h"
#import "NATiledImageMapView.h"
#import "NAPinAnnotationMapView.h"
#import "NAPinAnnotation.h"
#import "MapLocationItemModel.h"
#import "FileUtil.h"
#import <ARTiledImageView/ARWebTiledImageDataSource.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

@interface WebTileMapViewController ()
{
    BMKMapPoint leftTopCoor;
    MapItemModel *mapItem;
    NATiledImageMapView *mapView;
    ARWebTiledImageDataSource *dataSource;
}
@end

@implementation WebTileMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    mapItem = [[MapItemModel arrayOfModelsFromData:[FileUtil readFileFromPath:@"hand_drawing_map_list.json"] error:nil] objectAtIndex:0];
    
    leftTopCoor = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(mapItem.topLeftLat, mapItem.topLeftLng));
    
    dataSource = [[ARWebTiledImageDataSource alloc] init];
    dataSource.maxTiledHeight = 15000;
    dataSource.maxTiledWidth = 15000;
    dataSource.minTileLevel = 9;
    dataSource.maxTileLevel = 14;
    dataSource.tileSize = 256;
    dataSource.tileFormat = @"jpg";
    dataSource.tileBaseURL = [NSURL URLWithString:@"http://10.28.51.57:8080/"];
    
    mapView = [[NATiledImageMapView alloc] initWithFrame:self.view.bounds tiledImageDataSource:dataSource];
    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //    mapView.displayTileBorders = YES;
    
    mapView.backgroundColor  = [UIColor colorWithRed:0.000f green:0.475f blue:0.761f alpha:1.000f];
    mapView.zoomStep = 3.0f;
    
    [self.view addSubview:mapView];
    
//    for(MapLocationItemModel *locItem in mapItem.locationList)
//    {
//        NAPinAnnotation *melbourne = [NAPinAnnotation annotationWithPoint:[self locationCoordToCgPoint:CLLocationCoordinate2DMake(locItem.lat, locItem.lng)]];
//        melbourne.title = locItem.name;
//        melbourne.subtitle = @"I have a subtitle";
//        melbourne.color = NAPinColorRed;
//        [mapView addAnnotation:melbourne animated:NO];
//    }
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
