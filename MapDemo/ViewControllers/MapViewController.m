//
//  ViewController.m
//  MapDemo
//
//  Created by iss110302000283 on 16/3/1.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

#import "MapViewController.h"
#import "NAMapView.h"
#import "NAPinAnnotationMapView.h"
#import "NAPinAnnotation.h"
#import "MapLocationItemModel.h"
#import "FileUtil.h"
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

@interface MapViewController ()
{
    UIImage *image;
    BMKMapPoint leftTopCoor;
    MapItemModel *mapItem;
}
@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    mapItem = [[MapItemModel arrayOfModelsFromData:[FileUtil readFileFromPath:@"hand_drawing_map_list.json"] error:nil] objectAtIndex:0];
    
    leftTopCoor = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(mapItem.topLeftLat, mapItem.topLeftLng));
    
    NAMapView *mapView = [[NAPinAnnotationMapView alloc] initWithFrame:self.view.bounds];
    
    mapView.backgroundColor  = [UIColor colorWithRed:0.000f green:0.475f blue:0.761f alpha:1.000f];
    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    mapView.minimumZoomScale = 0.1f;
    mapView.maximumZoomScale = 2.5f;
    
    NSString *australia = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:mapItem.imgName];
    image = [UIImage imageWithContentsOfFile:australia];
    [mapView displayMap:image];
    
    mapView.zoomScale = [[UIScreen mainScreen] bounds].size.width / image.size.width;
    mapView.minimumZoomScale = mapView.minimumZoomScale < mapView.zoomScale ? mapView.zoomScale : mapView.minimumZoomScale;
    
    [self.view addSubview:mapView];
    
    for(MapLocationItemModel *locItem in mapItem.locationList)
    {
        NAPinAnnotation *melbourne = [NAPinAnnotation annotationWithPoint:[self locationCoordToCgPoint:CLLocationCoordinate2DMake(locItem.lat, locItem.lng)]];
        melbourne.title = locItem.name;
        melbourne.subtitle = @"I have a subtitle";
        melbourne.color = NAPinColorRed;
        [mapView addAnnotation:melbourne animated:NO];
    }
    
    CLLocationCoordinate2D pt = [self cgPointToLocationCoord:CGPointMake(1080, 1920)];
    NSLog(@"lat: %f, lng: %f", pt.latitude, pt.longitude);
    
    pt = [self cgPointToLocationCoord:CGPointMake(0, 0)];
    NSLog(@"lat: %f, lng: %f", pt.latitude, pt.longitude);
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
