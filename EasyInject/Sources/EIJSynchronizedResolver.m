//
//  EIJSynchronizedResolver.m
//  EasyInject
//
//  Created by yuhan on 2023/10/23.
//

#import "EIJSynchronizedResolver.h"
#import "EIJContainer.h"

@interface EIJSynchronizedResolver ()

@property (nonatomic) EIJContainer *container;
@property (nonatomic) NSRecursiveLock *lock;

@end

@implementation EIJSynchronizedResolver

+ (instancetype)resolverWithContainer:(EIJContainer *)container {
    return [[EIJSynchronizedResolver alloc] initWithContainer:container];
}

- (instancetype)initWithContainer:(EIJContainer *)container {
    self = [super init];
    if (self) {
        _container = container;
        _lock = [[NSRecursiveLock alloc] init];
    }
    return self;
}

#pragma mark - Resolver Implementation

- (id)resolve:(Protocol *)serviceType arguments:(NSArray *)arguments {
    [self.lock lock];
    id instance = [self.container resolve:serviceType arguments:arguments];
    [self.lock unlock];
    return instance;
}

- (id)resolve:(Protocol *)serviceType name:(NSString *)name arguments:(NSArray *)arguments {
    [self.lock lock];
    id instance = [self.container resolve:serviceType name:name arguments:arguments];
    [self.lock unlock];
    return instance;
}

@end
