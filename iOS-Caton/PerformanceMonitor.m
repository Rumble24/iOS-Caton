//
//  PerformanceMonitor.m
//  SuperApp
//
//  Created by tanhao on 15/11/12.
//  Copyright © 2015年 Tencent. All rights reserved.
//

#import "PerformanceMonitor.h"
#import "BSBacktraceLogger.h"

@interface PerformanceMonitor ()

@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@property (nonatomic, assign) CFRunLoopActivity activity;
@property (nonatomic, assign) CFRunLoopObserverRef observer;
@property (nonatomic, assign) int timeoutCount;

@end

@implementation PerformanceMonitor



+ (instancetype)sharedInstance
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

static void runLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    PerformanceMonitor *moniotr = (__bridge PerformanceMonitor*)info;
    
    moniotr.activity = activity;
    
    dispatch_semaphore_t semaphore = moniotr.semaphore;
    ///> 这个函数会使传入的信号量dsema的值加1
    dispatch_semaphore_signal(semaphore);
}

- (void)stop
{
    if (!self.observer)
        return;
    
    CFRunLoopRemoveObserver(CFRunLoopGetMain(), self.observer, kCFRunLoopCommonModes);
    CFRelease(self.observer);
    self.observer = NULL;
}

- (void)start
{
    if (self.observer)
        return;
    
    // 信号  如果信号量是0，就会根据传入的等待时间来等待
    self.semaphore = dispatch_semaphore_create(0);
    
    // 注册RunLoop状态观察
    CFRunLoopObserverContext context = {0,(__bridge void*)self,NULL,NULL};
    self.observer = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                       kCFRunLoopAllActivities,
                                       YES,
                                       0,
                                       &runLoopObserverCallBack,
                                       &context);
    CFRunLoopAddObserver(CFRunLoopGetMain(), self.observer, kCFRunLoopCommonModes);
    
    // 在子线程监控时长
    __weak typeof(self) weakSelf;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (YES)
        {
            ///> 这个函数的作用是这样的，如果dsema信号量的值大于0，该函数所处线程就继续执行下面的语句，并且将信号量的值减1； 如果desema的值为0，那么这个函数就阻塞当前线程等待timeout   一直减少到 dispatch_semaphore_wait  这个函数返回 0 才会继续执行
            
            
            ///> 果然是等待 50毫秒才会执行下面的程序  只会等待这么久等待完就过去了
            long st = dispatch_semaphore_wait(weakSelf.semaphore, dispatch_time(DISPATCH_TIME_NOW, 50 * NSEC_PER_MSEC));
            
            
            ////>  不等于0 表示 没有增加信号量  连续  还是本次的循环
            if (st != 0)
            {
                if (!weakSelf.observer)
                {
                    weakSelf.timeoutCount = 0;
                    weakSelf.semaphore = 0;
                    weakSelf.activity = 0;
                    return;
                }
                
                if (weakSelf.activity==kCFRunLoopBeforeSources || weakSelf.activity==kCFRunLoopAfterWaiting)
                {
                    if (++weakSelf.timeoutCount < 5)
                        continue;
                    
                    ////> 如何获取f当前的堆栈
                    BSLOG_MAIN
                    NSLog(@"--------------------卡卡卡卡卡卡卡卡卡-------------");
                }
                
            } else {
                ///> ===0 表示已经释放。表示已经是下一个循环了
            }
            weakSelf.timeoutCount = 0;
        }
    });
}

@end
