//
//  EIJServiceEntry.m
//  EasyInject
//
//  Created by yuhan on 2023/10/18.
//

#import "EIJServiceEntry.h"

@interface EIJServiceEntry ()

@property (nonatomic) Protocol *serviceType;
@property (nonatomic) id factory;
@property (nonatomic) id<EIJInstanceStorage> storage;
@property (nonatomic, copy) EIJResolutionCompletedHandler resolutionCompletedHandler;

@end

@implementation EIJServiceEntry

+ (instancetype)entryWithServiceType:(Protocol *)serviceType factory:(id)factory storage:(id<EIJInstanceStorage>)storage {
    return [[EIJServiceEntry alloc] initWithServiceType:serviceType factory:factory storage:storage];
}

- (instancetype)initWithServiceType:(Protocol *)serviceType factory:(id)factory storage:(id<EIJInstanceStorage>)storage {
    self = [super init];
    if (self) {
        _serviceType = serviceType;
        _factory = factory;
        _storage = storage;
    }
    return self;
}

- (void)resolutionCompletedWithHandler:(EIJResolutionCompletedHandler)handler {
    self.resolutionCompletedHandler = handler;
}

- (void)resolutionCompletedWithInstance:(id)instance resolver:(id<EIJResolver>)resolver {
    if (self.resolutionCompletedHandler) {
        self.resolutionCompletedHandler(instance, resolver);
    }
}

@end
