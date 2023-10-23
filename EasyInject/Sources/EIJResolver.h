//
//  EIJResolver.h
//  EasyInject
//
//  Created by yuhan on 2023/10/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol EIJResolver <NSObject>

/// Retrieves the instance with the specified service type, registration name and arguments for factory block. 
/// @param serviceType The service type to resolve.
/// @param arguments The arguments of block. Type of arguments must be id or its subtype.
/// @note Must use 'register:block:' method for registration.
- (nullable id)resolve:(Protocol *)serviceType arguments:(nullable NSArray *)arguments;

/// Retrieves the instance with the specified service type, registration name and arguments for factory block. 
/// @param serviceType The service type to resolve.
/// @param name The registration name.
/// @param arguments The arguments of block. Type of arguments must be id or its subtype.
/// @note Must use 'register:name:block:' method for registration.
- (nullable id)resolve:(Protocol *)serviceType name:(NSString *)name arguments:(nullable NSArray *)arguments;

@end

NS_ASSUME_NONNULL_END
