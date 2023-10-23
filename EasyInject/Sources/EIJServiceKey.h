//
//  EIJServiceKey.h
//  EasyInject
//
//  Created by yuhan on 2023/10/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EIJServiceKey : NSObject <NSCopying>

+ (instancetype)keyWithServiceType:(Protocol *)serviceType;
+ (instancetype)keyWithServiceType:(Protocol *)serviceType name:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
