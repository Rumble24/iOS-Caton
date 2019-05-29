//
//  BSBacktraceLogger.h
//  BSBacktraceLogger
//
//  Created by 张星宇 on 16/8/27.
//  Copyright © 2016年 bestswifter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSBacktraceLogger : NSObject


///> 获取所有的线程
+ (NSString *)bs_backtraceOfAllThread;

///> 获取当前线程
+ (NSString *)bs_backtraceOfCurrentThread;

///> 获取主线程
+ (NSString *)bs_backtraceOfMainThread;

///> 获取某一个线程
+ (NSString *)bs_backtraceOfNSThread:(NSThread *)thread;

@end
