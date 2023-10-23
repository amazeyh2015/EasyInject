//
//  EIJStrongStorage.m
//  EasyInject
//
//  Created by yuhan on 2023/10/18.
//

#import "EIJStrongStorage.h"

@interface EIJStrongStorage ()

@property (nonatomic, nullable) id instance;

@end

@implementation EIJStrongStorage

+ (instancetype)storage { 
    return [[EIJStrongStorage alloc] init];
}

- (void)graphResolutionCompleted {
    // do nothing
}

@end
