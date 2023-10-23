//
//  EIJRegister.h
//  EasyInject
//
//  Created by yuhan on 2023/10/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class EIJServiceEntry;
@protocol EIJInstanceStorage;

@protocol EIJRegister <NSObject>

/// Adds a registration for the specified service with the factory block to specify how the service is resolved.
/// @param serviceType The service type to register.
/// @param factory The factory block. Return value type must be id. Arguments type must be id or its subtype. 'id(^)(NSString *a, NSNumber *b)' for example.
/// @note Must use 'resolve:arguments:' method for resolution.
- (EIJServiceEntry *)register:(Protocol *)serviceType factory:(id)factory storage:(id<EIJInstanceStorage>)storage;

/// Adds a registration for the specified service with the factory block to specify how the service is resolved.
/// @param serviceType The service type to register.
/// @param name Used to differentiate from other registrations that have the same service type and factory.
/// @param factory The factory block. Return value type must be id. Arguments type must be id or its subtype. 'id(^)(NSString *a, NSNumber *b)' for example.
/// @note Must use 'resolve:name:arguments:' method for resolution.
- (EIJServiceEntry *)register:(Protocol *)serviceType name:(NSString *)name factory:(id)factory storage:(id<EIJInstanceStorage>)storage;

@end

NS_ASSUME_NONNULL_END
