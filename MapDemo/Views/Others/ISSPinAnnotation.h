//
//  ISSPinAnnotation.h
//  MapDemo
//
//  Created by xdzhangm on 16/3/30.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

#import "NAAnnotation.h"
#import "NAPinAnnotation.h"

// 播放状态
typedef NS_ENUM(NSInteger, ISSTTSPlayerStatus)
{
    TTS_PLAYER_STATUS_NONE          = 0,
    TTS_PLAYER_STATUS_PLAYING       = 1,    // 播放中
    TTS_PLAYER_STATUS_PAUSE         = 2     // 暂停
};

@interface ISSPinAnnotation : NAPinAnnotation
@property (nonatomic, assign) ISSLocationType locType;
@property (nonatomic, copy) NSString *imgPath;
@property (nonatomic, assign) ISSTTSPlayerStatus playerStatus;
- (BOOL)isPlaying;
- (BOOL)isPaused;
- (void)play;
- (void)pause;
- (void)stop;
@end
