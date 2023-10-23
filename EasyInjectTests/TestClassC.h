//
//  TestClassC.h
//  EasyInjectTests
//
//  Created by yuhan on 2023/10/18.
//

#import <Foundation/Foundation.h>
#import "TestProtocolC.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TestProtocolD;

@interface TestClassC : NSObject <TestProtocolC>

@property (nonatomic) id<TestProtocolD> propertyd;

@end

NS_ASSUME_NONNULL_END
