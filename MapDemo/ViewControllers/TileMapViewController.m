//
//  TileMapViewController.m
//  MapDemo
//
//  Created by iss110302000283 on 16/3/29.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

#import "TileMapViewController.h"
#import "ISSTiledImageMapView.h"
#import "ISSPinAnnotation.h"
#import "MapLocationItemModel.h"
#import "FileUtil.h"
#import <ARTiledImageView/ARLocalTiledImageDataSource.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "BDSSpeechSynthesizer.h"

@interface TileMapViewController ()<ISSPinAnnotationMapViewDelegate, BDSSpeechSynthesizerDelegate>
{
    BMKMapPoint leftTopCoor;
    MapItemModel *mapItem;
    ISSTiledImageMapView *mapView;
    ARLocalTiledImageDataSource *dataSource;
    NSMutableArray *pinList;
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
    
    mapView = [[ISSTiledImageMapView alloc] initWithFrame:self.view.bounds tiledImageDataSource:dataSource];
    mapView.mapDelegate = self;
    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    mapView.displayTileBorders = YES;

    mapView.backgroundColor  = [UIColor colorWithRed:0.000f green:0.475f blue:0.761f alpha:1.000f];
    mapView.zoomStep = 3.0f;
    
    [self.view addSubview:mapView];
    
    pinList = [[NSMutableArray alloc] init];
    for(NSInteger i = 0; i < mapItem.locationList.count; i++)
    {
        MapLocationItemModel *locItem = mapItem.locationList[i];
        ISSPinAnnotation *melbourne = [ISSPinAnnotation annotationWithPoint:[self locationCoordToCgPoint:CLLocationCoordinate2DMake(locItem.lat, locItem.lng)]];
        melbourne.title = locItem.name;
        melbourne.color = i % 3;
        [mapView addAnnotation:melbourne animated:YES];
        
        [pinList addObject:melbourne];
    }
    
    [self initTTSConfig];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [mapView zoomToFit:animated];
}

- (void)initTTSConfig
{
    [[BDSSpeechSynthesizer sharedInstance] setSynthesizerDelegate:self];
    // 设置日志级别
    [BDSSpeechSynthesizer setLogLevel: BDS_PUBLIC_LOG_VERBOSE];
    
    [[BDSSpeechSynthesizer sharedInstance] setApiKey:kBaiduTTSApiKey withSecretKey:kBaiduTTSSecretKey];
    
    [[BDSSpeechSynthesizer sharedInstance] setSynthesizerParam:[NSNumber numberWithInt:BDS_SYNTHESIZER_TEXT_ENCODE_UTF8]
                                                        forKey:BDS_SYNTHESIZER_PARAM_TEXT_ENCODE
     ];
    [[BDSSpeechSynthesizer sharedInstance] setSynthesizerParam:[NSNumber numberWithInt:BDS_SYNTHESIZER_SPEAKER_FEMALE]
                                                        forKey:BDS_SYNTHESIZER_PARAM_SPEAKER
     ];
    [[BDSSpeechSynthesizer sharedInstance] setSynthesizerParam:[NSNumber numberWithInt:BDS_SYNTHESIZER_AUDIO_ENCODE_AMR_15K85]
                                                        forKey:BDS_SYNTHESIZER_PARAM_AUDIO_ENCODING
     ];
    // 设置合成参数, 现在可被设置的参数为BDS_SYNTHESIZER_PARAM_SPEED,BDS_SYNTHESIZER_PARAM_VOLUME,BDS_SYNTHESIZER_PARAM_PITCH
    [[BDSSpeechSynthesizer sharedInstance] setSynthesizerParam:[NSNumber numberWithInt:5]
                                                        forKey:BDS_SYNTHESIZER_PARAM_VOLUME
     ];
    [[BDSSpeechSynthesizer sharedInstance] setSynthesizerParam:[NSNumber numberWithInt:5]
                                                        forKey:BDS_SYNTHESIZER_PARAM_SPEED
     ];
    [[BDSSpeechSynthesizer sharedInstance] setSynthesizerParam:[NSNumber numberWithInt:5]
                                                        forKey:BDS_SYNTHESIZER_PARAM_PITCH
     ];
    
    NSString *textDatfile = [[NSBundle mainBundle] pathForResource:@"Chinese_Text" ofType:@"dat"];
    NSString *speechDatfile = [[NSBundle mainBundle] pathForResource:@"Chinese_Speech_Female" ofType:@"dat"];
    // 检查音库文件
    NSError* err = nil;
    if ([[BDSSpeechSynthesizer sharedInstance] verifyDataFile: textDatfile error: &err] != NO) {
        NSLog( @"verify data file successfully");
    }
    
    [[BDSSpeechSynthesizer sharedInstance] setThreadPriority: 1.0f];
    
    // 获取音库文件参数
    NSString* paramValue = nil;
    if ([[BDSSpeechSynthesizer sharedInstance] getDataFileParam: textDatfile
                                                           type: TTS_DATA_PARAM_LANGUAGE
                                                          value: &paramValue
                                                          error: &err] != NO) {
        NSLog( @"param value is %@", paramValue );
    }
    // 启动合成引擎
    NSString* tempLicenseFilePath = [[NSBundle mainBundle] pathForResource:@"bdtts_license" ofType:@"dat"];
    BDSErrEngine ret = [[BDSSpeechSynthesizer sharedInstance] startTTSEngine: textDatfile
                                                              speechDataPath: speechDatfile
                                                             licenseFilePath: tempLicenseFilePath
                                                                 withAppCode: kBaiduTTSAppID];
    if (ret != BDS_ERR_ENGINE_OK) {
        NSLog(@"failed to start tts engine");
    }
    
    // Load data for supporting English synthesis with offline engine
    textDatfile = [[NSBundle mainBundle] pathForResource:@"English_Text" ofType:@"dat"];
    speechDatfile = [[NSBundle mainBundle] pathForResource:@"English_Speech_Female" ofType:@"dat"];
    ret = [[BDSSpeechSynthesizer sharedInstance] loadEnglishData:textDatfile speechData:speechDatfile];
    if (ret != BDS_ERR_ENGINE_OK) {
        NSLog(@"failed to load support for English synthesis");
    }
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

- (void)playerButtonTapped:(NAPinAnnotation *)annotation
{
    if(![annotation isKindOfClass:[ISSPinAnnotation class]])
    {
        return;
    }
    [self playWithTTS:(ISSPinAnnotation *)annotation];
}

- (void)playWithTTS:(ISSPinAnnotation *)annotation
{
    NSInteger index = [pinList indexOfObject:annotation];
    if(index == NSNotFound)
    {
        return;
    }
    for(ISSPinAnnotation *pinAnnotation in pinList)
    {
        if(pinAnnotation != annotation)
        {
            [pinAnnotation stop];
        }
    }
    MapLocationItemModel *locItem = [mapItem.locationList objectAtIndex:index];
    BDSSynthesizerStatus status = [[BDSSpeechSynthesizer sharedInstance] synthesizerStatus];
    if(status == BDS_SYNTHESIZER_STATUS_WORKING)
    {
        if([annotation isPlaying])
        {
            [[BDSSpeechSynthesizer sharedInstance] pause];
            [annotation pause];
        }
        else
        {
            [[BDSSpeechSynthesizer sharedInstance] cancel];
            [[BDSSpeechSynthesizer sharedInstance] speak:locItem.desc];
            [annotation play];
        }
    }
    else if(status == BDS_SYNTHESIZER_STATUS_PAUSED)
    {
        if([annotation isPaused])
        {
            [[BDSSpeechSynthesizer sharedInstance] resume];
        }
        else
        {
            [[BDSSpeechSynthesizer sharedInstance] cancel];
            [[BDSSpeechSynthesizer sharedInstance] speak:locItem.desc];
        }
        [annotation play];
    }
    else if(status == BDS_SYNTHESIZER_STATUS_NONE)
    {
        NSLog(@"Synthesizer not initialized");
    }
    else
    {
        [[BDSSpeechSynthesizer sharedInstance] speak:locItem.desc];
        [annotation play];
    }
}

#pragma mark BDSSpeechSynthesizerDelegate
- (void)synthesizerSpeechEndSentence:(NSInteger)SpeakSentence
{
    for(ISSPinAnnotation *pinAnnotation in pinList)
    {
        if([pinAnnotation isPlaying])
        {
            [pinAnnotation stop];
            [mapView.calloutView updatePlayButtonText];
        }
    }
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
