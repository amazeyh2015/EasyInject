//
//  EIJWeakStorage.m
//  EasyInject
//
//  Created by yuhan on 2023/10/18.
//

#import "EIJWeakStorage.h"

@interface EIJWeakStorage ()

@property (nonatomic, weak, nullable) id instance;

@end

@implementation EIJWeakStorage

+ (instancetype)storage { 
    return [[EIJWeakStorage alloc] init];
}

- (void)graphResolutionCompleted {
    // do nothing
}

@end
