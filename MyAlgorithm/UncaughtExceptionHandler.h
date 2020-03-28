//
//  UncaughtExceptionHandler.h
//  MyAlgorithm
//
//  Created by wdyzmx on 2020/3/21.
//  Copyright © 2020 wdyzmx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UncaughtExceptionHandler : NSObject {
    BOOL dismissed;
}

//void InstallUncaughtExceptionHandler(void);

@end

NS_ASSUME_NONNULL_END
