//
//  UncaughtExceptionHandler.m
//  MyAlgorithm
//
//  Created by wdyzmx on 2020/3/21.
//  Copyright © 2020 wdyzmx. All rights reserved.
//

#import "UncaughtExceptionHandler.h"
#import <stdatomic.h>
#include <libkern/OSAtomic.h>
#include <execinfo.h>

//NSString * const UncaughtExceptionHandlerSignalExceptionName = @"UncaughtExceptionHandlerSignalExceptionName";
//
//NSString * const UncaughtExceptionHandlerSignalKey = @"UncaughtExceptionHandlerSignalKey";
//
//NSString * const UncaughtExceptionHandlerAddressesKey = @"UncaughtExceptionHandlerAddressesKey";
//
//volatile int32_t UncaughtExceptionCount = 0;
//
//const int32_t UncaughtExceptionMaximum = 10;
//
//const NSInteger UncaughtExceptionHandlerSkipAddressCount = 4;
//
//const NSInteger UncaughtExceptionHandlerReportAddressCount = 5;
 
@implementation UncaughtExceptionHandler
 
//+ (NSArray *)backtrace {
//    void* callstack[128];
//    int frames = backtrace(callstack, 128);  // 用于获取当前线程的函数调用堆栈，返回实际获取的指针个数
//    char **strs = backtrace_symbols(callstack, frames);  // 从backtrace函数获取的信息转化为一个字符串数组
//    int i;
//    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
//    for (i = UncaughtExceptionHandlerSkipAddressCount; i < UncaughtExceptionHandlerSkipAddressCount + UncaughtExceptionHandlerReportAddressCount; i++) {
//       [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
//    }
//    free(strs);
//    return backtrace;
//}
////
//- (void)alertView:(UIAlertView *)anAlertView clickedButtonAtIndex:(NSInteger)anIndex {
//  if (anIndex == 0) {
//      dismissed = YES;
//  }
//}
//
//#pragma mark - handleException
//- (void)handleException:(NSException *)exception {
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Unhandled exception", nil)
//                                                    message:[NSString stringWithFormat:NSLocalizedString(@"You can try to continue but the application may be unstable.\n"@"%@\n%@", nil), [exception reason], [[exception userInfo] objectForKey:UncaughtExceptionHandlerAddressesKey]]
//                                                   delegate:self
//                                          cancelButtonTitle:NSLocalizedString(@"Quit", nil)
//                                          otherButtonTitles:NSLocalizedString(@"Continue", nil), nil];
//    [alert show];
//
//    // 本次异常处理
//    CFRunLoopRef runloop = CFRunLoopGetCurrent();
//    CFArrayRef   allMode = CFRunLoopCopyAllModes(runloop);
//    while (!dismissed) {
//        // machO
//        // 后台更新 - log
//        // kill
//        //
//        for (NSString *mode in (__bridge NSArray *)allMode) {
//            CFRunLoopRunInMode((CFStringRef)mode, 0.0001, false);
//        }
//    }
//    CFRelease(allMode);
//
//    NSSetUncaughtExceptionHandler(NULL);
//
//    signal(SIGABRT, SIG_DFL);
//    signal(SIGILL, SIG_DFL);
//    signal(SIGSEGV, SIG_DFL);
//    signal(SIGFPE, SIG_DFL);
//    signal(SIGBUS, SIG_DFL);
//    signal(SIGPIPE, SIG_DFL);
//
//    if ([[exception name] isEqual:UncaughtExceptionHandlerSignalExceptionName]) {
//        kill(getpid(), [[[exception userInfo] objectForKey:UncaughtExceptionHandlerSignalKey] intValue]);
//    } else {
//        [exception raise];
//    }
//}
//
//
//NSString *getAppInfo(){
//    NSString *appInfo = [NSString stringWithFormat:@"App : %@ %@(%@)\nDevice : %@\nOS Version : %@ %@\n",
//                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"],
//                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
//                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"],
//                         [UIDevice currentDevice].model,
//                         [UIDevice currentDevice].systemName,
//                         [UIDevice currentDevice].systemVersion];
//    //                         [UIDevice currentDevice].uniqueIdentifier];
//    NSLog(@"Crash!!!! %@", appInfo);
//    return appInfo;
//}
//
////void MySignalHandler(int signal) {
////    NSLog(@"%@", __func__);
////}
//
//void MySignalHandler(int signal) {
////    int32_t exceptionCount = atomic_fetch_add(UncaughtExceptionCount, 1);
//    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
//    if (exceptionCount > UncaughtExceptionMaximum) {
//        return;
//    }
//    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:signal] forKey:UncaughtExceptionHandlerSignalKey];
//    NSArray *callStack = [UncaughtExceptionHandler backtrace];
//    [userInfo setObject:callStack forKey:UncaughtExceptionHandlerAddressesKey];
//    [[[UncaughtExceptionHandler alloc] init] performSelectorOnMainThread:@selector(handleException:)
//                                                              withObject:[NSException exceptionWithName:UncaughtExceptionHandlerSignalExceptionName reason:[NSString stringWithFormat:NSLocalizedString(@"Signal %d was raised.\n"@"%@", nil), signal, getAppInfo()]
//                                                                                               userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:signal] forKey:UncaughtExceptionHandlerSignalKey]] waitUntilDone:YES];
//}
//
//void InstallUncaughtExceptionHandler() {
//
//signal(SIGABRT, MySignalHandler);
//
//signal(SIGILL, MySignalHandler);
//
//signal(SIGSEGV, MySignalHandler);
//
//signal(SIGFPE, MySignalHandler);
//
//signal(SIGBUS, MySignalHandler);
//
//signal(SIGPIPE, MySignalHandler);
//
//}


@end


