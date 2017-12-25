//
//  main.m
//  Runloop
//
//  Created by zhouyuxi on 2017/11/14.
//  Copyright © 2017年 zhouyuxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        
        NSLog(@"来这里");
        
        //死循环 -- runloop -- 监听事件
        int a =  UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        
        NSLog(@"come here");
        return a;
    }
}
