//
//  main.m
//  app
//
//  Created by djzhang on 10/25/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "OSAppDelegate.h"


int main(int argc, char * argv[]) {
    @autoreleasepool {
//        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
       return UIApplicationMain(argc, argv, nil, NSStringFromClass([OSAppDelegate class]));
    }
}
