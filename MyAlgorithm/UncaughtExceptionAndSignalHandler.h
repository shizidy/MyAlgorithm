//
//  UncaughtExceptionAndSignalHandler.h
//  MyAlgorithm
//
//  Created by wdyzmx on 2020/3/22.
//  Copyright © 2020 wdyzmx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface UncaughtExceptionAndSignalHandler : NSObject {
    BOOL dismissed;
}

/// 注册p崩溃handler
void InstallUncaughtExceptionAndSignalHandler(void);

@end

NS_ASSUME_NONNULL_END
