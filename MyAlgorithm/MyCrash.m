//
//  MyCrash.m
//  MyAlgorithm
//
//  Created by wdyzmx on 2020/3/21.
//  Copyright © 2020 wdyzmx. All rights reserved.
//

#import "MyCrash.h"

@implementation MyCrash

//+ (void)setExceptionHandler {
//    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
//}
//
//+ (NSUncaughtExceptionHandler *)getHandler {
//    return NSGetUncaughtExceptionHandler();
//}
//
//void UncaughtExceptionHandler(NSException *exception) {
//    NSArray *stackArray = [exception callStackSymbols];
//    NSString *reason = [exception reason];
//    NSString *name = [exception name];
//
//    NSString *exceptionInfo = [NSString stringWithFormat:@"\n======Exception name:%@\n======Exception reason:%@\n======Exception stack:%@", name, reason, stackArray];
//    NSLog(@"%@", exceptionInfo);
//
//    NSString *url = [NSString stringWithFormat:@"=============异常崩溃报告=============\nname:\n%@\nreason:\n%@\ncallStackSymbols:\n%@",
//                  name,reason,[stackArray componentsJoinedByString:@"\n"]];
//    NSString *path = [applicationDocumentsDirectory() stringByAppendingPathComponent:@"Exception.txt"];
//    [url writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
//    //除了可以选择写到应用下的某个文件，通过后续处理将信息发送到服务器等
//    //还可以选择调用发送邮件的的程序，发送信息到指定的邮件地址
//    //或者调用某个处理程序来处理这个信息
//}
//
//NSString *applicationDocumentsDirectory() {
//    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
//}
//
//- (NSString *)applicationDocumentsDirectory {
//    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
//}

@end
