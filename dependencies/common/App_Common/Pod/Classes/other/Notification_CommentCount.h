//
//  Notification_CommentCount.h
//  oschina
//
//  Created by wangjun on 12-3-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Notification_CommentCount : NSObject

@property (retain,nonatomic) id attachment;
@property int commentCount;
@property int projectId;

- (id)initWithParameters:(id)nattachment andCommentCount:(int)ncommentCount;

- (id)initWithParameters:(id)nattachment andCommentCount:(int)ncommentCount projectId:(int )projectId;
@end
