//
//  EIJContainer.h
//  EasyInject
//
//  Created by yuhan on 2023/10/17.
//

#import <Foundation/Foundation.h>
#import <EasyInject/EIJRegister.h>
#import <EasyInject/EIJResolver.h>

NS_ASSUME_NONNULL_BEGIN

@interface EIJContainer : NSObject <EIJRegister, EIJResolver>

+ (instancetype)container;

@end

NS_ASSUME_NONNULL_END
