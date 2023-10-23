//
//  EIJContainer.m
//  EasyInject
//
//  Created by yuhan on 2023/10/17.
//

#import "EIJContainer.h"
#import "EIJServiceKey.h"
#import "EIJServiceEntry.h"
#import "EIJInstanceStorage.h"
#import "EIJBlockInvoker.h"

@interface EIJContainer ()

@property (nonatomic) NSMutableDictionary<EIJServiceKey *, EIJServiceEntry *> *services;
@property (nonatomic) NSInteger resolutionDepth;
@property (nonatomic) NSInteger maxResolutionDepth;
@property (nonatomic) NSMutableArray *currentGraphEntries;

@end

@implementation EIJContainer

+ (instancetype)container {
    return [[EIJContainer alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _services = [NSMutableDictionary dictionary];
        _resolutionDepth = 0;
        _maxResolutionDepth = 200;
        _currentGraphEntries = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Register Implementation

- (EIJServiceEntry *)register:(Protocol *)serviceType factory:(id)factory storage:(id<EIJInstanceStorage>)storage {
    return [self register:serviceType name:@"" factory:factory storage:storage];
}

- (EIJServiceEntry *)register:(Protocol *)serviceType name:(NSString *)name factory:(id)factory storage:(id<EIJInstanceStorage>)storage {
    EIJServiceKey *key = [EIJServiceKey keyWithServiceType:serviceType name:name];
    EIJServiceEntry *entry = self.services[key];
    if (entry == nil) {
        entry = [EIJServiceEntry entryWithServiceType:serviceType factory:factory storage:storage];
        self.services[key] = entry;
    }
    return entry;
}

#pragma mark - Internal Resolve Methods

- (id)resolveEntry:(EIJServiceEntry *)entry arguments:(NSArray *)arguments {
    if (entry == nil) {
        return nil;
    }
    
    // increase current resolution depth
    [self increaseResolutionDepth];
    
    // get instance in current resolution graph
    id instance = [entry.storage instance];
    if (instance == nil) {
        // add entry into current resolution graph
        [self.currentGraphEntries addObject:entry];
        
        // resolve a instance with factory block and arguments
        instance = [EIJBlockInvoker invokeBlock:entry.factory arguments:arguments];
        
        // check resolved instance type
        NSAssert(instance == nil || [instance conformsToProtocol:entry.serviceType], @"Resolved instance type not match registered.");
        
        // save resolved intance
        [entry.storage setInstance:instance];
        
        // notify the entry that resolution complete
        [entry resolutionCompletedWithInstance:instance resolver:self];
    }
    
    // decrease current resolution depth
    [self decreaseResolutionDepth];
    
    return instance;
}

- (void)increaseResolutionDepth {
    NSAssert(self.resolutionDepth < self.maxResolutionDepth, @"Infinite recursive call for circular dependency has been detected.");
    self.resolutionDepth += 1;
}

- (void)decreaseResolutionDepth {
    NSAssert(self.resolutionDepth > 0, @"The depth cannot be negative.");
    self.resolutionDepth -= 1;
    if (self.resolutionDepth == 0) {
        [self graphResolutionCompleted];
    }
}

- (void)graphResolutionCompleted {
    for (EIJServiceEntry *entry in self.currentGraphEntries) {
        [entry.storage graphResolutionCompleted];
    }
    [self.currentGraphEntries removeAllObjects];
}

#pragma mark - Resolver Implementation

- (id)resolve:(Protocol *)serviceType arguments:(NSArray *)arguments {
    return [self resolve:serviceType name:@"" arguments:arguments];
}

- (id)resolve:(Protocol *)serviceType name:(NSString *)name arguments:(NSArray *)arguments {
    EIJServiceKey *key = [EIJServiceKey keyWithServiceType:serviceType name:name];
    EIJServiceEntry *entry = self.services[key];
    return [self resolveEntry:entry arguments:arguments];
}

@end
