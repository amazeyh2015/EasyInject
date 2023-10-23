//
//  TestClassE.h
//  EasyInjectTests
//
//  Created by yuhan on 2023/10/18.
//

#import <Foundation/Foundation.h>
#import "TestProtocolE.h"

NS_ASSUME_NONNULL_BEGIN

@interface TestClassE : NSObject <TestProtocolE>

@property (nonatomic) NSInteger i;
@property (nonatomic) BOOL b;
@property (nonatomic) NSString *s;

@end

NS_ASSUME_NONNULL_END
