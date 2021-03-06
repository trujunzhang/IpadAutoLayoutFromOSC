//
//  TweetDetail.m
//  oschina
//
//  Created by wangjun on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TweetDetail.h"
#import "Tweet.h"
#import "AFHTTPRequestOperation.h"
#import "AppContant.h"
#import "NdUncaughtExceptionHandler.h"
#import "AFOSCClient.h"
#import "Config.h"
#import "MBProgressHUD.h"
#import "Notification_CommentCount.h"


@implementation TweetDetail
@synthesize webView;
@synthesize txtComment;
@synthesize switchToZone;
@synthesize tweetID;
@synthesize singleTweet;

bool textViewIsEmpty;

#pragma mark - 生命周期
- (void)viewDidAppear:(BOOL)animated
{
    self.parentViewController.navigationItem.title = @"动弹详情";
    UIBarButtonItem *btnComment = [[UIBarButtonItem alloc] initWithTitle:@"发表" style:UIBarButtonItemStyleBordered target:self action:@selector(clickComment:)];
    self.parentViewController.navigationItem.rightBarButtonItem = btnComment;
    self.view.backgroundColor = [Tool getBackgroundColor];
    

//    //适配iOS7uinavigationbar遮挡tableView的问题
//    if([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
//    {
//        self.parentViewController.edgesForExtendedLayout = UIRectEdgeNone;
//        self.parentViewController.automaticallyAdjustsScrollViewInsets = YES;
//    }
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self.webView stopLoading];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [Tool roundTextView:self.txtComment];
    self.txtComment.delegate = self;
    //决定开关
    [self.switchToZone setOn:[Config Instance].getIsPostToMyZone];
    
    self.txtComment.text = @"点击此处输入评论";
    self.txtComment.textColor = [UIColor lightGrayColor];
    textViewIsEmpty =YES;
    if(IS_IPHONE_5)
    {
        self.txtComment.frame = CGRectMake(2, 403, 316, 50);
        self.webView.frame = CGRectMake(0, 0, 313, 375);
    }
    if(!IS_IPHONE_5)
    {
        self.txtComment.frame = CGRectMake(2, 315, 316, 50);
        self.webView.frame = CGRectMake(0, 0, 313, 310);
        if(IS_IOS7)
            self.webView.frame = CGRectMake(0, 0, 313, 375);
    }

    self.title = @"动弹详情";
    self.tabBarItem.title = @"动弹详情";
    self.tabBarItem.image = [UIImage imageNamed:@"tweet"];
    
    [Tool clearWebViewBackground:webView];
    self.webView.delegate = self;
    self.singleTweet = [[Tweet alloc] init];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [Tool showHUD:@"正在加载" andView:self.view andHUD:hud];
    NSString *url = [NSString stringWithFormat:@"%@?id=%d", api_tweet_detail, tweetID];
    [[AFOSCClient sharedClient] getPath:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [hud hide:YES];
        [Tool getOSCNotice2:operation.responseString];
        NSString *response = operation.responseString;
        @try {
            
            TBXML *xml = [[TBXML alloc] initWithXMLString:response error:nil];
            TBXMLElement *root = xml.rootXMLElement;
            if (root == nil) {
                [Tool ToastNotification:@"加载出现异常" andView:self.view andLoading:NO andIsBottom:NO];
                return ;
            }
            TBXMLElement *t = [TBXML childElementNamed:@"tweet" parentElement:root];
            if (t == nil) {
                [Tool ToastNotification:@"加载出现异常" andView:self.view andLoading:NO andIsBottom:NO];
                return ;
            }
            TBXMLElement *_id = [TBXML childElementNamed:@"id" parentElement:t];
            TBXMLElement *portrait = [TBXML childElementNamed:@"portrait" parentElement:t];
            TBXMLElement *body = [TBXML childElementNamed:@"body" parentElement:t];
            TBXMLElement *author = [TBXML childElementNamed:@"author" parentElement:t];
            TBXMLElement *authorid = [TBXML childElementNamed:@"authorid" parentElement:t];
            TBXMLElement *commentCount = [TBXML childElementNamed:@"commentCount" parentElement:t];
            TBXMLElement *pubDate = [TBXML childElementNamed:@"pubDate" parentElement:t];
            TBXMLElement *imgSmall = [TBXML childElementNamed:@"imgSmall" parentElement:t];
            TBXMLElement *imgBig = [TBXML childElementNamed:@"imgBig" parentElement:t];
            TBXMLElement *attach = [TBXML childElementNamed:@"attach" parentElement:t];
            TBXMLElement *appClient = [TBXML childElementNamed:@"appclient" parentElement:t];
            self.singleTweet = [[Tweet alloc] initWidthParameters:[[TBXML textForElement:_id] intValue] andAuthor:[TBXML textForElement:author] andAuthorID:[[TBXML textForElement:authorid] intValue] andTweet:[TBXML textForElement:body] andFromNowOn:[Tool intervalSinceNow:[TBXML textForElement:pubDate]] andImg:[TBXML textForElement:portrait] andCommentCount:[[TBXML textForElement:commentCount] intValue] andImgTweet:[TBXML textForElement:imgSmall] andImgBig:[TBXML textForElement:imgBig] andAppClient:[[TBXML textForElement:appClient] intValue] andAttach:[TBXML textForElement:attach]];
            //通知已经获取了帖子回复数 
            Notification_CommentCount *notification = [[Notification_CommentCount alloc] initWithParameters:self andCommentCount:self.singleTweet.commentCount];
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_DetailCommentCount object:notification];
            NSString *pubTime = [NSString stringWithFormat:@"在%@ 更新了动态 %@", self.singleTweet.fromNowOn, [Tool getAppClientString:singleTweet.appClient]];
            
            NSString *imgHtml = @"";
            if ([singleTweet.imgBig isEqualToString:@""] == NO) {
                imgHtml = [NSString stringWithFormat:@"<br/><a href='http://wangjuntom'><img style='max-width:300px;' src='%@'/></a>", [TBXML textForElement:imgBig]];
            }
            
            self.webView.backgroundColor = [Tool getBackgroundColor];
            
            BOOL is_audio = singleTweet.attach.length > 0;
            
            //读取语音动弹相关html、js
            NSString *audio_html = @"";
            NSString *jquery_js = @"";
            if(is_audio){
                audio_html = [Tool readResouceFile:@"audio" andExt:@"html"];
                audio_html = [NSString stringWithFormat:audio_html,singleTweet.attach,singleTweet.attach];
                jquery_js = [Tool readResouceFile:@"jquery-1.7.1.min" andExt:@"js"];
            }
            
            NSString *html = [NSString stringWithFormat:@"<!DOCTYPE html><html><head><script type='text/javascript'>%@</script></head>%@<body style='background-color:#EBEBF3'><div id='oschina_title'><a href='http://my.oschina.net/u/%d'>%@</a></div><div id='oschina_outline'>%@</div><br/><div id='oschina_body' style='font-weight:bold;font-size:14px;line-height:21px;'>%@</div>%@%@%@</body></html>",jquery_js,HTML_Style, singleTweet.authorID, singleTweet.author,pubTime,singleTweet.tweet,imgHtml,HTML_Bottom,audio_html];
            
            [self.webView loadHTMLString:html baseURL:nil];
            
        }
        @catch (NSException *exception) {
            [NdUncaughtExceptionHandler TakeException:exception];
        }
        @finally {

        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [hud hide:YES];
        [Tool ToastNotification:@"加载失败" andView:self.view andLoading:NO andIsBottom:NO];
    }];
    
    //适配iOS7uinavigationbar遮挡tableView的问题
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        self.parentViewController.edgesForExtendedLayout = UIRectEdgeNone;
        self.parentViewController.automaticallyAdjustsScrollViewInsets = YES;
    }

}
- (void)clickComment:(id)sender
{
    if ([Config Instance].isCookie == NO) {
        [self.txtComment resignFirstResponder];
        [Tool noticeLogin:self.view andDelegate:self andTitle:@"请先登录后发表评论"];
        return;
    }
    NSString *content = self.txtComment.text;
    if ([content isEqualToString:@""] || [content isEqualToString:@"点击此处输入评论"]) {
        [Tool ToastNotification:@"错误 评论内容不能为空" andView:self.view andLoading:NO andIsBottom:NO];
        return;
    }
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [Tool showHUD:@"正在发表" andView:self.view andHUD:hud];
    [[AFOSCClient sharedClient] postPath:api_comment_pub parameters:[NSDictionary dictionaryWithObjectsAndKeys:@"3",@"catalog",[NSString stringWithFormat:@"%d", singleTweet._id],@"id",[NSString stringWithFormat:@"%d", [Config Instance].getUID],@"uid",content,@"content",self.switchToZone.isOn ? @"1" : @"0",@"isPostToMyZone", nil] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [Tool getOSCNotice2:operation.responseString];
        [hud hide:YES];
        ApiError *error = [Tool getApiError2:operation.responseString];
        if (error == nil) {
            [Tool ToastNotification:operation.responseString andView:self.view andLoading:NO andIsBottom:NO];
            return;
        }
        switch (error.errorCode) {
            case 1:
            {
                [self clickBackground:nil];
                self.txtComment.text = @"";
                
                Comment *c = [Tool getMyLatestComment2:operation.responseString];
                if (c) {
                    [Config Instance].tempComment = c;
                    [Config Instance].tempComment.catalog = 3;
                    [Config Instance].tempComment.parentID = self.tweetID;
                }
            }
                break;
                //评论成功不需要提示
            case 0:
            case -2:
            case -1:
            {
                [Tool ToastNotification:[NSString stringWithFormat:@"错误 %@", error.errorMessage] andView:self.view andLoading:NO andIsBottom:NO];
            }
                break;
        }

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [hud hide:YES];
        [Tool ToastNotification:@"评论发表失败" andView:self.view andLoading:NO andIsBottom:NO];
        
    }];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [Tool processLoginNotice:actionSheet andButtonIndex:buttonIndex andNav:self.parentViewController.navigationController andParent:self];
}
- (void)viewDidUnload
{
    [Tool ReleaseWebView:self.webView];
    [self setWebView:nil];
    singleTweet = nil;
    [self setTxtComment:nil];
    [self setSwitchToZone:nil];
    [super viewDidUnload];
}

#pragma mark - 浏览器链接处理
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL.absoluteString isEqualToString:@"http://wangjuntom/"]) 
    {
        //弹出大图
        [Tool pushTweetImgDetail:singleTweet.imgBig andParent:self];
        return NO;
    }
    else
    {
        [Tool analysis:[request.URL absoluteString] andNavController:self.parentViewController.navigationController];
        if ([request.URL.absoluteString isEqualToString:@"about:blank"]) 
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
}
#pragma mark - 调整输入框与关闭键盘
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if(textViewIsEmpty)
    {
        self.txtComment.text = @"";
        self.txtComment.textColor = [UIColor blackColor];
        textViewIsEmpty = NO;
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-202, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if(self.txtComment.text.length == 0)
    {
        self.txtComment.textColor = [UIColor lightGrayColor];
        self.txtComment.text = @"点击此处输入评论";
        textViewIsEmpty = YES;
    }
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+202, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    return YES;
}
- (IBAction)clickBackground:(id)sender {
    [self.txtComment resignFirstResponder];
}
- (IBAction)changeSwitchToZone:(id)sender {
    [[Config Instance] saveIsPostToMyZone:self.switchToZone.isOn];
}

#pragma mark - 重定义键盘回车键
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString: @"\n"]) {
        [self clickComment:nil];
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


@end
