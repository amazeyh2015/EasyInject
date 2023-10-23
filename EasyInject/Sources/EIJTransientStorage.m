//
//  EIJTransientStorage.m
//  EasyInject
//
//  Created by yuhan on 2023/10/18.
//

#import "EIJTransientStorage.h"

@interface EIJTransientStorage ()

@property (nonatomic, nullable) id instance;

@end

@implementation EIJTransientStorage

+ (instancetype)storage { 
    return [[EIJTransientStorage alloc] init];
}

- (void)graphResolutionCompleted {
    self.instance = nil;
}

@end
