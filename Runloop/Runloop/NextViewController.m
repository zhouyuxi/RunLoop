//
//  NextViewController.m
//  Runloop
//
//  Created by zhouyuxi on 2017/11/14.
//  Copyright © 2017年 zhouyuxi. All rights reserved.
//

#import "NextViewController.h"

@interface NextViewController ()<UITableViewDataSource,UITableViewDelegate>
typedef void (^RunloopBlock)(void);

@property (nonatomic,strong) UITableView *myTalbleView;
@property (nonatomic,strong) NSMutableArray *tasks;
@property (nonatomic,assign) NSUInteger maxNum;

@end

@implementation NextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.maxNum = 18;
    [self buildUI];
    self.tasks = [NSMutableArray array];
    [self addRunloopObserver];
    self.view.backgroundColor = [UIColor orangeColor];
}

- (void)buildUI
{
    self.myTalbleView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.myTalbleView.dataSource = self;
    self.myTalbleView.delegate = self;
    [self.view addSubview:self.myTalbleView];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    for (UIView *view  in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    __weak typeof(self) weakSelf = self;
//       [weakSelf addImageWith:cell];
//       [weakSelf addImage1With:cell];
    [self addTask:^{
        [weakSelf addImageWith:cell];
    }];
    

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  80;
    
}


- (void)addImageWith:(UITableViewCell *)cell
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 80, 80)];
    UIImage *image = [UIImage imageNamed:@"mypunchcard_mark"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = image;
    [cell.contentView addSubview:imageView];
}

- (void)addImage1With:(UITableViewCell *)cell
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 0, 80, 80)];
    UIImage *image = [UIImage imageNamed:@"mypunchcard_mark"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = image;
    [cell.contentView addSubview:imageView];
}


- (void)addRunloopObserver{
    
    // 拿到当前的Runloop
    CFRunLoopRef runloop = CFRunLoopGetCurrent();
    
    // 上下文
    CFRunLoopObserverContext context = {
        0,
        (__bridge void *)self,
        &CFRetain,
        &CFRelease,
        NULL
    };
    
    
    // 创建观察者
    static CFRunLoopObserverRef runloopObserver;
    runloopObserver = CFRunLoopObserverCreate(NULL, kCFRunLoopBeforeWaiting, YES, 0, &callBack, &context);
    
    
    // 添加到当然Runloop中
    CFRunLoopAddObserver(runloop, runloopObserver, kCFRunLoopCommonModes);
    
    CFRelease(runloopObserver);
    
}

void callBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
    NSLog(@"callBack");
    
    //拿到控制器
    
    NextViewController *vc  = (__bridge NextViewController *)info; //__bridge OC 和 CF直接的对象桥接
    if (vc.tasks.count == 0) {
        return;
    }
    
    RunloopBlock block = vc.tasks.firstObject;
    block();
    [vc.tasks removeObjectAtIndex:0];
}

- (void)addTask:(RunloopBlock)task{
    
    // 将任务放到数组中
    [self.tasks addObject:task];
    
    if (self.tasks.count > self.maxNum) {
        [self.tasks removeObjectAtIndex:0];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
