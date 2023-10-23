//
//  EIJServiceKey.m
//  EasyInject
//
//  Created by yuhan on 2023/10/18.
//

#import "EIJServiceKey.h"

@interface EIJServiceKey ()

@property (nonatomic) Protocol *serviceType;
@property (nonatomic, copy) NSString *serviceTypeName;
@property (nonatomic, copy) NSString *name;

@end

@implementation EIJServiceKey

+ (instancetype)keyWithServiceType:(Protocol *)serviceType {
    return [[EIJServiceKey alloc] initWithServiceType:serviceType name:@""];
}

+ (instancetype)keyWithServiceType:(Protocol *)serviceType name:(NSString *)name {
    return [[EIJServiceKey alloc] initWithServiceType:serviceType name:name];
}

- (instancetype)initWithServiceType:(Protocol *)serviceType name:(NSString *)name {
    self = [super init];
    if (self) {
        _serviceType = serviceType;
        _serviceTypeName = NSStringFromProtocol(serviceType);
        _name = name;
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    if (object == self) {
        return YES;
    }
    EIJServiceKey *key = (EIJServiceKey *)object;
    return [key.serviceTypeName isEqual:self.serviceTypeName] && [key.name isEqual:self.name];
}

- (NSUInteger)hash {
    return self.serviceTypeName.hash ^ self.name.hash;
}

#pragma mark - NSCopying

- (id)copyWithZone:(nullable NSZone *)zone {
    return [[EIJServiceKey allocWithZone:zone] initWithServiceType:self.serviceType name:self.name];
}

@end
