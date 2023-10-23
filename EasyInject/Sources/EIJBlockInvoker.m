//
//  EIJBlockInvoker.m
//  EasyInject
//
//  Created by yuhan on 2023/10/18.
//

#import "EIJBlockInvoker.h"

struct EIJBlockLiteral {
    void *isa;
    int flags;
    int reserved;
    void (*invoke)(void *, ...);
    struct block_descriptor {
        unsigned long int reserved;
        unsigned long int size;
        void (*copy_helper)(void *dst, void *src);
        void (*dispose_helper)(void *src);
        const char *signature;
    } *descriptor;
};

enum {
    EIJBlockDescriptionFlagsHasCopyDispose = (1 << 25),
    EIJBlockDescriptionFlagsHasCtor = (1 << 26),
    EIJBlockDescriptionFlagsIsGlobal = (1 << 28),
    EIJBlockDescriptionFlagsHasStret = (1 << 29),
    EIJBlockDescriptionFlagsHasSignature = (1 << 30)
};

@implementation EIJBlockInvoker

+ (id)invokeBlock:(id)block arguments:(NSArray *)arguments {
    NSMethodSignature *signature = [self signatureForBlock:block];
    NSAssert(signature.methodReturnType[0] == '@', @"Return type of block must be id or its subtype.");
    NSAssert(arguments.count == signature.numberOfArguments - 1, @"Arguments count must match registered block.");
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    for (NSUInteger i = 1; i < signature.numberOfArguments; i++) {
        id argument = arguments[i - 1];
        [invocation setArgument:&argument atIndex:i];
    }
    [invocation invokeWithTarget:[block copy]];
    void *returnValue = malloc(sizeof(id));
    [invocation getReturnValue:returnValue];
    __unsafe_unretained id instance = *((__unsafe_unretained id *)returnValue);
    free(returnValue);
    return instance;
}

+ (NSMethodSignature *)signatureForBlock:(id)block {
    struct EIJBlockLiteral *blockRef = (__bridge struct EIJBlockLiteral *)block;
    NSAssert(blockRef->flags & EIJBlockDescriptionFlagsHasSignature, @"Block must has signature!");
    void *signatureLocation = blockRef->descriptor;
    signatureLocation += sizeof(unsigned long int);
    signatureLocation += sizeof(unsigned long int);
    if (blockRef->flags & EIJBlockDescriptionFlagsHasCopyDispose) {
        signatureLocation += sizeof(void (*)(void *dst, void *src));
        signatureLocation += sizeof(void (*)(void *src));
    }
    const char *signature = *(const char **)signatureLocation;
    return [NSMethodSignature signatureWithObjCTypes:signature];
}

@end
