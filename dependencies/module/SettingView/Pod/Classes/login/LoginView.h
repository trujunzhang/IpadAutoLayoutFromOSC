//
//  LoginView.h
//  oschina
//
//  Created by wangjun on 12-3-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIHTTPRequestConfig.h"

@class ASIFormDataRequest;


@interface LoginView : UIViewController<UIWebViewDelegate> 
{
    ASIFormDataRequest *request;
}
@property (strong, nonatomic) IBOutlet UITextField *txt_Name;
@property (strong, nonatomic) IBOutlet UITextField *txt_Pwd;
@property (strong, nonatomic) IBOutlet UISwitch *switch_Remember;
@property BOOL isPopupByNotice;
@property (strong, nonatomic) IBOutlet UIWebView *webView;

- (IBAction)click_Login:(id)sender;
- (IBAction)textEnd:(id)sender;
- (IBAction)backgrondTouch:(id)sender;
- (void)analyseUserInfo:(NSString *)xml;

@end
