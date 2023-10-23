//
//  EIJServiceEntry.h
//  EasyInject
//
//  Created by yuhan on 2023/10/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol EIJResolver;
@protocol EIJInstanceStorage;

typedef void(^EIJResolutionCompletedHandler)(id instance, id<EIJResolver> resolver);

@interface EIJServiceEntry : NSObject

@property (nonatomic, readonly) Protocol *serviceType;
@property (nonatomic, readonly) id factory;
@property (nonatomic, readonly) id<EIJInstanceStorage> storage;

+ (instancetype)entryWithServiceType:(Protocol *)serviceType factory:(id)factory storage:(id<EIJInstanceStorage>)storage;

- (void)resolutionCompletedWithHandler:(EIJResolutionCompletedHandler)handler;
- (void)resolutionCompletedWithInstance:(id)instance resolver:(id<EIJResolver>)resolver;

@end

NS_ASSUME_NONNULL_END
