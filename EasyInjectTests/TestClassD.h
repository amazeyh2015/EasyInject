//
//  TestClassD.h
//  EasyInjectTests
//
//  Created by yuhan on 2023/10/18.
//

#import <Foundation/Foundation.h>
#import "TestProtocolD.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TestProtocolC;

@interface TestClassD : NSObject <TestProtocolD>

@property (nonatomic, weak) id<TestProtocolC> propertyc;

@end

NS_ASSUME_NONNULL_END
