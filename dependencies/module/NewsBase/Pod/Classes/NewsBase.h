//
//  NewsBase.h
//  oschina
//
//  Created by wangjun on 12-3-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NewsView;


@interface NewsBase : UIViewController

@property (strong,nonatomic) UISegmentedControl * segment_title;
@property (strong,nonatomic) NewsView * newsView;

- (NSString *)getSegmentTitle;
- (void)myInit;

@end
