//
//  PerformanceMonitor.m
//  SuperApp
//
//  Created by tanhao on 15/11/12.
//  Copyright © 2015年 Tencent. All rights reserved.
//

#import "PerformanceMonitor.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>

@interface PerformanceMonitor ()
{
    int timeoutCount;
    CFRunLoopObserverRef observer;
    
    @public
    dispatch_semaphore_t semaphore;
    CFRunLoopActivity activity;
}
@end

@implementation PerformanceMonitor

static int dsemaC = 0;
static int waitC = 0;
static int activityC = 0;


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
    
    moniotr->activity = activity;
    
    dispatch_semaphore_t semaphore = moniotr->semaphore;
    ///> 这个函数会使传入的信号量dsema的值加1
    dispatch_semaphore_signal(semaphore);
    dsemaC++;
//    NSLog(@"--------------------下一个-------dsemaC-------------");
}

- (void)stop
{
    if (!observer)
        return;
    
    CFRunLoopRemoveObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
    CFRelease(observer);
    observer = NULL;
}

- (void)start
{
    if (observer)
        return;
    
    // 信号  如果信号量是0，就会根据传入的等待时间来等待
    semaphore = dispatch_semaphore_create(0);
    
    // 注册RunLoop状态观察
    CFRunLoopObserverContext context = {0,(__bridge void*)self,NULL,NULL};
    observer = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                       kCFRunLoopAllActivities,
                                       YES,
                                       0,
                                       &runLoopObserverCallBack,
                                       &context);
    CFRunLoopAddObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
    
    // 在子线程监控时长
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (YES)
        {
            ///> 这个函数的作用是这样的，如果dsema信号量的值大于0，该函数所处线程就继续执行下面的语句，并且将信号量的值减1； 如果desema的值为0，那么这个函数就阻塞当前线程等待timeout   一直减少到 dispatch_semaphore_wait  这个函数返回 0 才会继续执行
            
            
            ///> 果然是等待 50毫秒才会执行下面的程序  只会等待这么久等待完就过去了
            long st = dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, 50 * NSEC_PER_MSEC));
            
            
            ////>  不等于0 表示 没有增加信号量  连续  还是本次的循环
            if (st != 0)
            {
                if (!observer)
                {
                    timeoutCount = 0;
                    semaphore = 0;
                    activity = 0;
                    return;
                }
                
                if (activity==kCFRunLoopBeforeSources || activity==kCFRunLoopAfterWaiting)
                {
                    if (++timeoutCount < 5)
                        continue;
                    
                    ////> 如何获取f当前的堆栈
                    
                    void* callstack[128];
                    int frames = backtrace(callstack, 128);
                    char **strs = backtrace_symbols(callstack, frames);
                    int i;
                    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
                    for (i = 0;i < 4;i++){
                        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
                    }
                    free(strs);
                    NSLog(@"=====>>>>>堆栈<<<<<=====\n%@",backtrace);
                    
                    NSLog(@"--------------------卡卡卡卡卡卡卡卡卡-------------");
                }
                
            } else {
                ///> ===0 表示已经释放。表示已经是下一个循环了
                waitC++;
//                NSLog(@"--------------------下一个-------waitC-------------");
            }
            timeoutCount = 0;
        }
    });
}

@end
