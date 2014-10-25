//
//  OSAppDelegate.h
//  IpadAutoLayoutFromOSC
//
//  Created by wangjun on 12-3-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "WXApi.h"


@class ProfileBase;
@class NewsBase;
@class PostBase;
@class TweetBase2;
@class SettingView;


@interface OSAppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate>
{
    int m_lastTabIndex;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;

@property (strong, nonatomic) NewsBase * newsBase;
@property (strong, nonatomic) PostBase * postBase;
@property (strong, nonatomic) TweetBase2 * tweetBase;
@property (strong, nonatomic) ProfileBase * profileBase;
@property (strong, nonatomic) SettingView * settingView;

@end
