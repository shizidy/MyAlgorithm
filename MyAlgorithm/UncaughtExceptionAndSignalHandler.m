//
//  UncaughtExceptionAndSignalHandler.m
//  MyAlgorithm
//
//  Created by wdyzmx on 2020/3/22.
//  Copyright © 2020 wdyzmx. All rights reserved.
//

#import "UncaughtExceptionAndSignalHandler.h"
#import <stdatomic.h>
#include <libkern/OSAtomic.h>
#include <execinfo.h>

NSString * const UncaughtExceptionHandlerSignalExceptionName = @"UncaughtExceptionHandlerSignalExceptionName";
NSString * const UncaughtExceptionHandlerSignalKey = @"UncaughtExceptionHandlerSignalKey";
NSString * const UncaughtExceptionHandlerAddressesKey = @"UncaughtExceptionHandlerAddressesKey";
NSString * const UncaughtExceptionHandlerCallStackSymbolsKey = @"UncaughtExceptionHandlerCallStackSymbolsKey";
NSString * const UncaughtExceptionHandlerFileKey = @"UncaughtExceptionHandlerFileKey";
volatile int32_t UncaughtExceptionCount = 0;
const int32_t UncaughtExceptionMaximum = 10;
const NSInteger UncaughtExceptionHandlerSkipAddressCount = 4;
const NSInteger UncaughtExceptionHandlerReportAddressCount = 5;

@interface UncaughtExceptionAndSignalHandler () <UIAlertViewDelegate>

@end

@implementation UncaughtExceptionAndSignalHandler

/// 获取堆栈信息
+ (NSArray *)backtrace {
void* callstack[128];
int frames = backtrace(callstack, 128);  // 用于获取当前线程的函数调用堆栈，返回实际获取的指针个数
char **strs = backtrace_symbols(callstack, frames);  // 从backtrace函数获取的信息转化为一个字符串数组
int i;
NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
for (i = UncaughtExceptionHandlerSkipAddressCount; i < UncaughtExceptionHandlerSkipAddressCount + UncaughtExceptionHandlerReportAddressCount; i++) {
   [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
}
free(strs);
return backtrace;
}

/// 注册handler实现
void InstallUncaughtExceptionAndSignalHandler() {
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
    signal(SIGABRT, MySignalHandler);
    signal(SIGILL, MySignalHandler);
    signal(SIGSEGV, MySignalHandler);
    signal(SIGFPE, MySignalHandler);
    signal(SIGBUS, MySignalHandler);
    signal(SIGPIPE, MySignalHandler);
}

#pragma mark - UncaughtExceptionHandler
void UncaughtExceptionHandler(NSException *exception) {
    NSLog(@"__func__====%s",__func__);

    NSArray *callStack = [UncaughtExceptionAndSignalHandler backtrace];
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:exception.userInfo];
    [mDict setObject:callStack forKey:UncaughtExceptionHandlerAddressesKey];
    [mDict setObject:exception.callStackSymbols forKey:UncaughtExceptionHandlerCallStackSymbolsKey];
    [mDict setObject:@"UncaughtException" forKey:UncaughtExceptionHandlerFileKey];

    // exception - myException
    [[[UncaughtExceptionAndSignalHandler alloc] init] performSelectorOnMainThread:@selector(handlerUncaughtException:) withObject:[NSException exceptionWithName:[exception name] reason:[exception reason] userInfo:mDict] waitUntilDone:YES];
}

#pragma mark - 保存crash日志到本地沙盒
- (void)handlerUncaughtException:(NSException *)exception {
    // crash 处理
    // 存
    NSDictionary *userInfo = [exception userInfo];
    [self saveCrash:exception file:[userInfo objectForKey:UncaughtExceptionHandlerFileKey]];
}

- (void)saveCrash:(NSException *)exception file:(NSString *)file {
    NSArray *stackArray = [[exception userInfo] objectForKey:UncaughtExceptionHandlerCallStackSymbolsKey];// 异常的堆栈信息
    NSString *reason = [exception reason];// 出现异常的原因
    NSString *name = [exception name];// 异常名称

    // 或者直接用代码，输入这个崩溃信息，以便在console中进一步分析错误原因
    // NSLog(@"crash: %@", exception);

    NSString * _libPath  = [myApplicationDocumentsDirectory() stringByAppendingPathComponent:file];
    
    // 归档
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:_libPath]){
        [fileManager createDirectoryAtPath:_libPath withIntermediateDirectories:YES attributes:nil error:nil];
    }

    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval interval = [date timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%f", interval];

    NSString * savePath = [_libPath stringByAppendingFormat:@"/error%@.log",timeString];

    NSString *exceptionInfo = [NSString stringWithFormat:@"Exception reason：%@\nException name：%@\nException stack：%@",name, reason, stackArray];
    BOOL sucess = [exceptionInfo writeToFile:savePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"保存崩溃日志 sucess:%d,%@", sucess, savePath);
    
    //
    UIWindow *myWindow = UIApplication.sharedApplication.windows.lastObject;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    button.backgroundColor = [UIColor grayColor];
    [myWindow addSubview:button];
    button.center = myWindow.center;
    [button setTitle:@"我是alert警告(演示)" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Unhandled exception", nil)
//                                                    message:[NSString stringWithFormat:NSLocalizedString(@"You can try to continue but the application may be unstable.\n"@"%@\n%@", nil), [exception reason], [[exception userInfo] objectForKey:UncaughtExceptionHandlerAddressesKey]]
//                                                   delegate:self
//                                          cancelButtonTitle:NSLocalizedString(@"Quit", nil)
//                                          otherButtonTitles:NSLocalizedString(@"Continue", nil), nil];
//    [alert show];
    
    // 本次异常处理
    //进入runloop
    [self intoMyRunLoop:exception];
}

- (void)buttonClick:(UIButton *)btn {
    dismissed = YES;
    btn.hidden = YES;
}

#pragma mark - MySignalHandler
void MySignalHandler(int signal) {
//    int32_t exceptionCount = atomic_fetch_add(UncaughtExceptionCount, 1);
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    if (exceptionCount > UncaughtExceptionMaximum) {
        return;
    }
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:signal] forKey:UncaughtExceptionHandlerSignalKey];
    NSArray *callStack = [UncaughtExceptionAndSignalHandler backtrace];
    [userInfo setObject:callStack forKey:UncaughtExceptionHandlerAddressesKey];
    [[[UncaughtExceptionAndSignalHandler alloc] init] performSelectorOnMainThread:@selector(handleException:)
                                                              withObject:[NSException exceptionWithName:UncaughtExceptionHandlerSignalExceptionName reason:[NSString stringWithFormat:NSLocalizedString(@"Signal %d was raised.\n"@"%@", nil), signal, getAppInfo()]
                                                                                               userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:signal] forKey:UncaughtExceptionHandlerSignalKey]] waitUntilDone:YES];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        dismissed = YES;
    }
}

#pragma mark - handleException
- (void)handleException:(NSException *)exception {
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Unhandled exception", nil)
//                                                    message:[NSString stringWithFormat:NSLocalizedString(@"You can try to continue but the application may be unstable.\n"@"%@\n%@", nil), [exception reason], [[exception userInfo] objectForKey:UncaughtExceptionHandlerAddressesKey]]
//                                                   delegate:self
//                                          cancelButtonTitle:NSLocalizedString(@"Quit", nil)
//                                          otherButtonTitles:NSLocalizedString(@"Continue", nil), nil];
//    [alert show];
    //自定义alertView, UIAlertView已经弃用
    
    // 本次异常处理
    //进入runloop
    [self intoMyRunLoop:exception];
}

- (void)intoMyRunLoop:(NSException *)exception {
    // 本次异常处理
    CFRunLoopRef runloop = CFRunLoopGetCurrent();
    CFArrayRef   allMode = CFRunLoopCopyAllModes(runloop);
    while (!dismissed) {
        // machO
        // 后台更新 - log
        // kill
        //
        for (NSString *mode in (__bridge NSArray *)allMode) {
            CFRunLoopRunInMode((CFStringRef)mode, 0.0001, false);
        }
    }
    CFRelease(allMode);
    
    // 回收内存
    NSSetUncaughtExceptionHandler(NULL);
    
    signal(SIGABRT, SIG_DFL);
    signal(SIGILL, SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
    signal(SIGFPE, SIG_DFL);
    signal(SIGBUS, SIG_DFL);
    signal(SIGPIPE, SIG_DFL);

    if ([[exception name] isEqual:UncaughtExceptionHandlerSignalExceptionName]) {
        kill(getpid(), [[[exception userInfo] objectForKey:UncaughtExceptionHandlerSignalKey] intValue]);
    } else {
        [exception raise];
    }
}





NSString *getAppInfo() {
    NSString *appInfo = [NSString stringWithFormat:@"App : %@ %@(%@)\nDevice : %@\nOS Version : %@ %@\n",
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"],
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"],
                         [UIDevice currentDevice].model,
                         [UIDevice currentDevice].systemName,
                         [UIDevice currentDevice].systemVersion];
//                         [UIDevice currentDevice].uniqueIdentifier];
    NSLog(@"Crash!!!! %@", appInfo);
    return appInfo;
}

NSString *myApplicationDocumentsDirectory() {
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
}

NSString *myApplicationCachesDirectory() {
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
}


@end
