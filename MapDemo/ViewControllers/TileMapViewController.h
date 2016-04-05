//
//  TileMapViewController.h
//  MapDemo
//
//  Created by iss110302000283 on 16/3/29.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapLocationItemModel.h"

#ifdef IS_MOCK_NAVIGATION
@protocol MockLocationModel
@end

@interface MockLocationModel : ISSJSONModel
@property (nonatomic, strong) NSMutableArray<UserLocationModel> *mocList;
@end
#endif

@interface TileMapViewController : UIViewController
@property (nonatomic, strong) MapItemModel *mapItem;
#ifdef IS_MOCK_NAVIGATION
@property (nonatomic, strong) NSMutableArray<UserLocationModel> *mockLocList;
#endif
@end
