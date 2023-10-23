//
//  TestClassE.m
//  EasyInjectTests
//
//  Created by yuhan on 2023/10/18.
//

#import "TestClassE.h"

@implementation TestClassE

- (NSString *)execute {
    NSInteger r = self.b ? self.i + 1 : self.i - 1;
    return [NSString stringWithFormat:@"%@ %ld", self.s, (long)r];
}

@end
