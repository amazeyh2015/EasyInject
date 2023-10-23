//
//  EIJBlockInvoker.h
//  EasyInject
//
//  Created by yuhan on 2023/10/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EIJBlockInvoker : NSObject

+ (nullable id)invokeBlock:(id)block arguments:(nullable NSArray *)arguments;

@end

NS_ASSUME_NONNULL_END
