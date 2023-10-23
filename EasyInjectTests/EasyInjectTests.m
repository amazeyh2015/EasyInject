//
//  EasyInjectTests.m
//  EasyInjectTests
//
//  Created by yuhan on 2023/10/18.
//

#import <XCTest/XCTest.h>
@import EasyInject;
#import "TestClassA.h"
#import "TestClassB.h"
#import "TestClassC.h"
#import "TestClassD.h"
#import "TestClassE.h"

@interface EasyInjectTests : XCTestCase

@end

@implementation EasyInjectTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testServiceKey {
    EIJServiceKey *key1 = [EIJServiceKey keyWithServiceType:@protocol(TestProtocolA)];
    EIJServiceKey *key2 = [EIJServiceKey keyWithServiceType:@protocol(TestProtocolA)];
    EIJServiceKey *key3 = [EIJServiceKey keyWithServiceType:@protocol(TestProtocolA) name:@"nameA"];
    EIJServiceKey *key4 = [EIJServiceKey keyWithServiceType:@protocol(TestProtocolA) name:@"nameA"];
    EIJServiceKey *key5 = [EIJServiceKey keyWithServiceType:@protocol(TestProtocolA) name:@"nameB"];
    EIJServiceKey *key6 = [EIJServiceKey keyWithServiceType:@protocol(TestProtocolB)];
    EIJServiceKey *key7 = [EIJServiceKey keyWithServiceType:@protocol(TestProtocolB) name:@"nameA"];
    
    XCTAssertTrue([key1 isEqual:key2]);
    XCTAssertTrue([key3 isEqual:key4]);
    XCTAssertFalse([key2 isEqual:key3]);
    XCTAssertFalse([key4 isEqual:key5]);
    XCTAssertFalse([key1 isEqual:key6]);
    XCTAssertFalse([key4 isEqual:key7]);
    
    EIJServiceKey *key8 = [key1 copy];
    EIJServiceKey *key9 = [key2 copy];
    EIJServiceKey *key10 = [key6 copy];
    XCTAssertTrue([key8 isEqual:key1]);
    XCTAssertTrue([key8 isEqual:key9]);
    XCTAssertFalse([key10 isEqual:key8]);
}

- (void)testRegisteration {
    EIJContainer *container = [EIJContainer container];
    
    Protocol *serviceType = @protocol(TestProtocolA);
    id<TestProtocolA>(^factory)(void) = ^{
        return [[TestClassA alloc] init];
    };
    id<EIJInstanceStorage> storage = [EIJTransientStorage storage];
    
    EIJServiceEntry *entry1 = [container register:serviceType factory:factory storage:storage];
    XCTAssertTrue(entry1.serviceType == serviceType);
    XCTAssertTrue(entry1.factory == factory);
    XCTAssertTrue(entry1.storage == storage);
    
    EIJServiceEntry *entry2 = [container register:serviceType factory:factory storage:storage];
    XCTAssertTrue(entry1 == entry2);
    
    EIJServiceEntry *entry3 = [container register:serviceType name:@"name1" factory:factory storage:storage];
    EIJServiceEntry *entry4 = [container register:serviceType name:@"name1" factory:factory storage:storage];
    EIJServiceEntry *entry5 = [container register:serviceType name:@"name2" factory:factory storage:storage];
    XCTAssertTrue(entry3 == entry4);
    XCTAssertTrue(entry4 != entry5);
}

- (void)testResolution {
    EIJContainer *container = [EIJContainer container];
    
    [container register:@protocol(TestProtocolA) factory:^{
        
    } storage:[EIJTransientStorage storage]];
    
    [container register:@protocol(TestProtocolB) factory:^{
        return [[TestClassA alloc] init];
    } storage:[EIJTransientStorage storage]];
    
    @try {
        [container resolve:@protocol(TestProtocolA) arguments:nil];
    } @catch (NSException *exception) {
        XCTAssertTrue([exception.description isEqualToString:@"Return type of block must be id or its subtype."]);
    }
    
    @try {
        [container resolve:@protocol(TestProtocolB) arguments:nil];
    } @catch (NSException *exception) {
        XCTAssertTrue([exception.description isEqualToString:@"Resolved instance type not match registered."]);
    }
}

- (void)testResolutionWithTransientStorage {
    EIJContainer *container = [EIJContainer container];
    
    [container register:@protocol(TestProtocolA) factory:^{
        return [[TestClassA alloc] init];
    } storage:[EIJTransientStorage storage]];
    
    id instance1 = [container resolve:@protocol(TestProtocolA) arguments:nil];
    id instance2 = [container resolve:@protocol(TestProtocolA) arguments:nil];
    XCTAssertTrue([instance1 isKindOfClass:[TestClassA class]]);
    XCTAssertTrue([instance2 isKindOfClass:[TestClassA class]]);
    XCTAssertTrue(instance1 != instance2);
    
    // Test whether the resolved instance can be release correctly
    __block __weak id wi;
    @autoreleasepool {
        id instance = [container resolve:@protocol(TestProtocolA) arguments:nil];
        wi = instance;
        instance = nil;
    }
    XCTAssertTrue(wi == nil);
}

- (void)testResolutionWithStrongStorage {
    EIJContainer *container = [EIJContainer container];
    
    [container register:@protocol(TestProtocolA) factory:^{
        return [[TestClassA alloc] init];
    } storage:[EIJStrongStorage storage]];
    
    id instance1 = [container resolve:@protocol(TestProtocolA) arguments:nil];
    id instance2 = [container resolve:@protocol(TestProtocolA) arguments:nil];
    XCTAssertTrue([instance1 isKindOfClass:[TestClassA class]]);
    XCTAssertTrue([instance2 isKindOfClass:[TestClassA class]]);
    XCTAssertTrue(instance1 == instance2);
}

- (void)testResolutionWithWeakStorage {
    EIJContainer *container = [EIJContainer container];
    
    TestClassA *a = [[TestClassA alloc] init];
    __weak TestClassA *wa = a;
    
    [container register:@protocol(TestProtocolA) factory:^{
        return wa;
    } storage:[EIJWeakStorage storage]];
    
    @autoreleasepool {
        id instance1 = [container resolve:@protocol(TestProtocolA) arguments:nil];
        id instance2 = [container resolve:@protocol(TestProtocolA) arguments:nil];
        XCTAssertTrue(instance1 != nil);
        XCTAssertTrue(instance2 != nil);
        XCTAssertTrue(instance1 == instance2);
    }
    
    a = nil;
    
    id instance3 = [container resolve:@protocol(TestProtocolA) arguments:nil];
    XCTAssertTrue(instance3 == nil);
}

- (void)testResolutionWithTransientStorageForCircluarDependency {
    EIJContainer *container = [EIJContainer container];
    
    [[container register:@protocol(TestProtocolC) factory:^{
        TestClassC *c = [[TestClassC alloc] init];
        return c;
    } storage:[EIJTransientStorage storage]] resolutionCompletedWithHandler:^(id instance, id<EIJResolver> resolver) {
        TestClassC *c = (TestClassC *)instance;
        c.propertyd = [resolver resolve:@protocol(TestProtocolD) arguments:nil];
    }];
    
    [[container register:@protocol(TestProtocolD) factory:^{
        TestClassD *d = [[TestClassD alloc] init];
        return d;
    } storage:[EIJTransientStorage storage]] resolutionCompletedWithHandler:^(id instance, id<EIJResolver> resolver) {
        TestClassD *d = (TestClassD *)instance;
        d.propertyc = [resolver resolve:@protocol(TestProtocolC) arguments:nil];
    }];
    
    TestClassC *instance1 = [container resolve:@protocol(TestProtocolC) arguments:nil];
    TestClassD *instance2 = [container resolve:@protocol(TestProtocolD) arguments:nil];
    
    XCTAssertTrue([instance1 isKindOfClass:[TestClassC class]]);
    XCTAssertTrue([instance2 isKindOfClass:[TestClassD class]]);
    XCTAssertTrue(instance1.propertyd != instance2);
    XCTAssertTrue(instance2.propertyc != instance1);
}

- (void)testResolutionWithStrongStorageForCircluarDependency {
    EIJContainer *container = [EIJContainer container];
    
    [[container register:@protocol(TestProtocolC) factory:^{
        TestClassC *c = [[TestClassC alloc] init];
        return c;
    } storage:[EIJStrongStorage storage]] resolutionCompletedWithHandler:^(id instance, id<EIJResolver> resolver) {
        TestClassC *c = (TestClassC *)instance;
        c.propertyd = [resolver resolve:@protocol(TestProtocolD) arguments:nil];
    }];
    
    [[container register:@protocol(TestProtocolD) factory:^{
        TestClassD *d = [[TestClassD alloc] init];
        return d;
    } storage:[EIJStrongStorage storage]] resolutionCompletedWithHandler:^(id instance, id<EIJResolver> resolver) {
        TestClassD *d = (TestClassD *)instance;
        d.propertyc = [resolver resolve:@protocol(TestProtocolC) arguments:nil];
    }];
    
    TestClassC *instance1 = [container resolve:@protocol(TestProtocolC) arguments:nil];
    TestClassD *instance2 = [container resolve:@protocol(TestProtocolD) arguments:nil];
    
    XCTAssertTrue([instance1 isKindOfClass:[TestClassC class]]);
    XCTAssertTrue([instance2 isKindOfClass:[TestClassD class]]);
    XCTAssertTrue(instance1.propertyd == instance2);
    XCTAssertTrue(instance2.propertyc == instance1);
}

- (void)testResolutionForMultipleArgumentsFactory {
    EIJContainer *container = [EIJContainer container];
    
    [container register:@protocol(TestProtocolE) factory:^(NSNumber *i, NSNumber *b, NSString *s){
        TestClassE *instance = [[TestClassE alloc] init];
        instance.i = i.intValue;
        instance.b = b.boolValue;
        instance.s = s;
        return instance;
    } storage:[EIJTransientStorage storage]];
    
    id instance2 = [container resolve:@protocol(TestProtocolE) arguments:@[@8, @(YES), @"Age"]];
    XCTAssertTrue([instance2 isKindOfClass:[TestClassE class]]);
    XCTAssertTrue([[instance2 execute] isEqualToString:@"Age 9"]);
}

- (void)testResolutionFromMultipleThreadsWithSynchronizedResolver {
    EIJContainer *container = [EIJContainer container];
    id<EIJResolver> resolver = [EIJSynchronizedResolver resolverWithContainer:container];
    
    [container register:@protocol(TestProtocolA) factory:^{
        return [[TestClassA alloc] init];
    } storage:[EIJTransientStorage storage]];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0);
    __block int exceptionCount = 0;
    for (int i = 0; i < 1000; i++) {
        dispatch_group_enter(group);
        dispatch_async(queue, ^{
            @try {
                [resolver resolve:@protocol(TestProtocolA) arguments:nil];
            } @catch (NSException *exception) {
                exceptionCount++;
            } @finally {
                dispatch_group_leave(group);
            }
        });
    }
    dispatch_group_notify(group, queue, ^{
        dispatch_semaphore_signal(semaphore);
    });
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    XCTAssertTrue(exceptionCount == 0);
}

@end
