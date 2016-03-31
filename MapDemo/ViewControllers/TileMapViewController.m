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

// 如果距离小于100米，则播报
#define MAX_NEAR_BY_DISTANCE                200

// 是否模拟导航
#define IS_MOCK_NAVIGATION                  1

@interface TileMapViewController ()<ISSPinAnnotationMapViewDelegate, BDSSpeechSynthesizerDelegate>
{
    ISSTiledImageMapView *mapView;
    UIButton *soundBtnView;
    
    BMKMapPoint leftTopCoor;
    MapItemModel *mapItem;
    ARLocalTiledImageDataSource *dataSource;
    NSMutableArray *pinList;
    ISSPinAnnotation *currentLocPinAnnotation;
    // 最近一次播报的景点index
    NSInteger lastNearIndex;
    BOOL isSoundAutoPlayDisabled;
#ifdef IS_MOCK_NAVIGATION
    UIButton *mockNavBtnView;
    NSMutableArray *mockLocList;
    NSInteger mockIndex;
#endif
}
@end

@implementation TileMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initVariables];
    
    [self initViews];
    
    [self initTTSConfig];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLocationUpdatedNotify) name:NOTIFICATION_LOCATION_UPDATED object:nil];
    [self userLocationUpdatedNotify];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [mapView zoomToFit:animated];
}

- (void)initVariables
{
    lastNearIndex = -1;
    
    mapItem = [[MapItemModel arrayOfModelsFromData:[FileUtil readFileFromPath:@"hand_drawing_map_list.json"] error:nil] objectAtIndex:0];
    
    leftTopCoor = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(mapItem.topLeftLat, mapItem.topLeftLng));
    
    dataSource = [[ARLocalTiledImageDataSource alloc] init];
    dataSource.maxTiledHeight = mapItem.originalImageHeight;
    dataSource.maxTiledWidth = mapItem.originalImageWidth;
    dataSource.minTileLevel = 9;
    dataSource.maxTileLevel = 11;
    dataSource.tileSize = 256;
    dataSource.tileFormat = @"jpg";
    dataSource.tileBasePath = [NSString stringWithFormat:@"%@/Maps/bailixia", [NSBundle mainBundle].resourcePath];
    
    pinList = [[NSMutableArray alloc] init];
    
#ifdef IS_MOCK_NAVIGATION
    mockIndex = -1;
    mockLocList = [[NSMutableArray alloc] init];
    mockLocList = [UserLocationModel arrayOfModelsFromData:[FileUtil readFileFromPath:@"mock_location_list.json"] error:nil];
#endif
}

- (void)initViews
{
    [self initMapView];
    [self initSoundControlView];
#ifdef IS_MOCK_NAVIGATION
    [self initMocButtonView];
#endif
}

- (void)initMapView
{
    mapView = [[ISSTiledImageMapView alloc] initWithFrame:self.view.bounds tiledImageDataSource:dataSource];
    mapView.mapDelegate = self;
    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //    mapView.displayTileBorders = YES;
    
    mapView.backgroundColor  = [UIColor colorWithRed:0.000f green:0.475f blue:0.761f alpha:1.000f];
    mapView.zoomStep = 3.0f;
    
    [self.view addSubview:mapView];
    
    for(NSInteger i = 0; i < mapItem.locationList.count; i++)
    {
        MapLocationItemModel *locItem = mapItem.locationList[i];
        ISSPinAnnotation *melbourne = [ISSPinAnnotation annotationWithPoint:[self locationCoordToCgPoint:CLLocationCoordinate2DMake(locItem.lat, locItem.lng)]];
        melbourne.title = locItem.name;
        [mapView addAnnotation:melbourne animated:YES];
        [pinList addObject:melbourne];
    }
}

#pragma mark 控制是否自动播报声音
- (void)initSoundControlView
{
    soundBtnView = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat wh = 40;
    soundBtnView.frame = CGRectMake(0, kScreenHeight - wh, wh, wh);
    [soundBtnView setImage:[UIImage imageNamed:@"btn_sound_click.png"] forState:UIControlStateNormal];
    [soundBtnView setImage:[UIImage imageNamed:@"btn_sound_nomal.png"] forState:UIControlStateSelected];
    [soundBtnView addTarget:self action:@selector(soundButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:soundBtnView];
}

- (void)initTTSConfig
{
    [[BDSSpeechSynthesizer sharedInstance] setSynthesizerDelegate:self];
    // 设置日志级别
    [BDSSpeechSynthesizer setLogLevel: BDS_PUBLIC_LOG_WARN];
    
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
    // 是否是播放靠近景区
    BOOL isPlayNearByMessage = (annotation == currentLocPinAnnotation);
    MapLocationItemModel *locItem = isPlayNearByMessage ? [mapItem.locationList objectAtIndex:lastNearIndex] : [mapItem.locationList objectAtIndex:index];
    BDSSynthesizerStatus status = [[BDSSpeechSynthesizer sharedInstance] synthesizerStatus];
    NSString *speakMessage = isPlayNearByMessage ? [NSString stringWithFormat:@"您已到达%@!", locItem.name] : locItem.desc;
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
            [[BDSSpeechSynthesizer sharedInstance] speak:speakMessage];
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
            [[BDSSpeechSynthesizer sharedInstance] speak:speakMessage];
        }
        [annotation play];
    }
    else if(status == BDS_SYNTHESIZER_STATUS_NONE)
    {
        NSLog(@"Synthesizer not initialized");
    }
    else
    {
        [[BDSSpeechSynthesizer sharedInstance] speak:speakMessage];
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

#pragma mark 位置信息刷新后
- (void)userLocationUpdatedNotify
{
    UserLocationModel *locModel = [UserLocationModel get];
    if(![locModel isValidLocation])
    {
        return;
    }
    CLLocationCoordinate2D coor;
    coor.latitude = locModel.lat;
    coor.longitude = locModel.lng;
    CGPoint point = [self locationCoordToCgPoint:coor];

    if(point.x < 0 || point.y < 0 || point.x > mapItem.originalImageWidth || point.y > mapItem.originalImageHeight)
    {
        NSLog(@"当前不在景区范围内");
        if(currentLocPinAnnotation)
        {
            [mapView removeAnnotation:currentLocPinAnnotation];
            [pinList removeObject:currentLocPinAnnotation];
            currentLocPinAnnotation = nil;
        }
    }
    else
    {
        NSLog(@"当前在景区范围内");
        if(currentLocPinAnnotation)
        {
            currentLocPinAnnotation.point = [self locationCoordToCgPoint:CLLocationCoordinate2DMake(locModel.lat, locModel.lng)];
            [currentLocPinAnnotation updatePosition];
        }
        else
        {
            currentLocPinAnnotation = [ISSPinAnnotation annotationWithPoint:[self locationCoordToCgPoint:CLLocationCoordinate2DMake(locModel.lat, locModel.lng)]];
            currentLocPinAnnotation.locType = LOC_TYPE_CURRENT;
            [mapView addAnnotation:currentLocPinAnnotation animated:YES];
            [pinList addObject:currentLocPinAnnotation];
        }
        [mapView bringSubviewToFront:currentLocPinAnnotation.view];
        // 获取最近的景点，并播报
        CGFloat latestDistance = CGFLOAT_MAX;
        NSInteger latestIndex = NSNotFound;
        
        CLLocationCoordinate2D currentCoor;
        currentCoor.latitude = locModel.lat;
        currentCoor.longitude = locModel.lng;
        
        for(NSInteger i = 0; i < mapItem.locationList.count; i++)
        {
            MapLocationItemModel *locItem = mapItem.locationList[i];
            CLLocationCoordinate2D coor;
            coor.latitude = locItem.lat;
            coor.longitude = locItem.lng;
            
            CGFloat distance = BMKMetersBetweenMapPoints(BMKMapPointForCoordinate(coor), BMKMapPointForCoordinate(currentCoor));
            if(distance < MAX_NEAR_BY_DISTANCE
               && distance < latestDistance)
            {
                latestDistance = distance;
                latestIndex = i;
            }
        }
        
        if(latestIndex != NSNotFound && latestIndex != lastNearIndex)
        {
            lastNearIndex = latestIndex;
            if(!isSoundAutoPlayDisabled)
            {
                [self playWithTTS:currentLocPinAnnotation];
            }
        }
    }
}

- (void)soundButtonTapped
{
    isSoundAutoPlayDisabled = !isSoundAutoPlayDisabled;
    [soundBtnView setSelected:isSoundAutoPlayDisabled];
    
#ifdef IS_MOCK_NAVIGATION
    mockNavBtnView.hidden = isSoundAutoPlayDisabled;
    if(mockNavBtnView.hidden)
    {
        [APP_DELEGATE() startLocation];
    }
    else
    {
        [APP_DELEGATE() stopLocation];
    }
#endif
}

#ifdef IS_MOCK_NAVIGATION
#pragma mark 模拟导航
- (void)initMocButtonView
{
    mockNavBtnView = [UIButton buttonWithType:UIButtonTypeCustom];
    mockNavBtnView.titleLabel.font = [UIFont systemFontOfSize:13];
    [mockNavBtnView setTitle:@"模拟导航" forState:UIControlStateNormal];
    [mockNavBtnView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [mockNavBtnView setBackgroundColor:[UIColor orangeColor]];
    [mockNavBtnView setBackgroundImage:[UITool createImageWithColor:RGBColor(227, 111, 41)] forState:UIControlStateHighlighted];
    CGFloat width = 120;
    CGFloat height = 35;
    mockNavBtnView.frame = CGRectMake((kScreenWidth - width) / 2.0, kScreenHeight - 8 - height, width, height);
    [mockNavBtnView addTarget:self action:@selector(mockButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mockNavBtnView];
}

- (void)mockButtonTapped
{
    mockIndex = (mockIndex + 1) % mockLocList.count;
    UserLocationModel *mockItem = [mockLocList objectAtIndex:mockIndex];
    UserLocationModel *userLocItem = [UserLocationModel get];
    userLocItem.lat = mockItem.lat;
    userLocItem.lng = mockItem.lng;
    [userLocItem save];
    [self userLocationUpdatedNotify];
}
#endif

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
