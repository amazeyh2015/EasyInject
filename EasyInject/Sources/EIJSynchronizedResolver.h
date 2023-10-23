//
//  EIJSynchronizedResolver.h
//  EasyInject
//
//  Created by yuhan on 2023/10/23.
//

#import <Foundation/Foundation.h>
#import <EasyInject/EIJResolver.h>

NS_ASSUME_NONNULL_BEGIN

@class EIJContainer;

@interface EIJSynchronizedResolver : NSObject <EIJResolver>

+ (instancetype)resolverWithContainer:(EIJContainer *)container;

@end

NS_ASSUME_NONNULL_END
