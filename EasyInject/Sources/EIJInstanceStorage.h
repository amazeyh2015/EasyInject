//
//  EIJInstanceStorage.h
//  EasyInject
//
//  Created by yuhan on 2023/10/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol EIJInstanceStorage <NSObject>

+ (instancetype)storage;

- (nullable id)instance;

- (void)setInstance:(nullable id)instance;

- (void)graphResolutionCompleted;

@end

NS_ASSUME_NONNULL_END
