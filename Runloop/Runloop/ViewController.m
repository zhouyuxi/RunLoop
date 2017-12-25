//
//  ViewController.m
//  Runloop
//
//  Created by zhouyuxi on 2017/11/14.
//  Copyright © 2017年 zhouyuxi. All rights reserved.
//

#import "ViewController.h"
#import "Zhou_Thread.h"
#import "NextViewController.h"

@interface ViewController ()
@property (nonatomic,assign) BOOL isFinish;
@property (nonatomic,strong)  dispatch_source_t timer;


@end

@implementation ViewController

- (void)push
{
    NextViewController *next = [[NextViewController alloc] init];
    [self.navigationController pushViewController:next animated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, 20, 100, 100);
    btn.backgroundColor = [UIColor blueColor];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
    
    UITextView *textView = [[UITextView alloc] init];
    textView.backgroundColor = [UIColor redColor];
    textView.frame = CGRectMake(10, 200, 200, 50);
    [self.view addSubview:textView];
    textView.text = @"哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈";

    
    _isFinish = NO;
    
    Zhou_Thread *thread  = [[Zhou_Thread alloc] initWithBlock:^{
        NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timeMethod) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        
//         //让runloop 跑起来（死循环）保证线程不退出
//        [[NSRunLoop currentRunLoop] run]; // 一旦run ruanloop就不会停下来，一直打印
        
//        while (true) {
//            //保命
//
//            NSLog(@"保命"); // 死循环啥也没干
//        }
        
//        while (!_isFinish) {
//            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.00001]]; // 每条线程里面都有个runloop任务，在执行，所以不会被回收
//        }
//
       NSLog(@"-------%@",[NSThread currentThread]);
        
    }];
    
    [thread start]; // 执行完这句后thread就释放了
    
    [self GCDTimer];
}

- (void)GCDTimer
{
    // 创建timer
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        NSLog(@"GCD---来了额");
        if (_isFinish == YES) {
         dispatch_source_cancel(_timer);
        }
    });
    // 启动timer
    dispatch_resume(timer);
    _timer = timer;
}



// 暂停
-(void) pauseTimer{
    if(_timer){
        dispatch_suspend(_timer);
    }
}
// 重启
-(void) resumeTimer{
    if(_timer){
        dispatch_resume(_timer);
    }
}
//取消
-(void) stopTimer{
    if(_timer){
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}


- (void)timeMethod {
    
    if (_isFinish == YES) {
        [NSThread exit];
    }
    
    NSLog(@"进入的timer的回调方法----%@",[NSThread currentThread]);
    
    [NSThread sleepForTimeInterval:1];
    
     static int num = 0;
    NSLog(@"%@---num的值%d",[NSThread currentThread],num++);
}

 - (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    _isFinish = YES;
    
}


@end
