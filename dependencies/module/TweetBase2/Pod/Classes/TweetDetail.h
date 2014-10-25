//
//  TweetDetail.h
//  oschina
//
//  Created by wangjun on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Tweet;


@interface TweetDetail : UIViewController<UIWebViewDelegate,UITextViewDelegate,UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UITextView *txtComment;
@property (strong, nonatomic) IBOutlet UISwitch *switchToZone;
@property int tweetID;
@property (retain,nonatomic) Tweet * singleTweet;



- (IBAction)clickBackground:(id)sender;
- (IBAction)changeSwitchToZone:(id)sender;

@end
