//
//  NSObject+CashProtector.m
//  ChildViewControllers
//
//  Created by BIN on 2017/12/4.
//  Copyright © 2017年 BIN. All rights reserved.
//

#import "NSObject+CashProtector.h"

#import <objc/runtime.h>
#import "NSObject+Hook.h"
#import "NNForwardingTarget.h"
 
#define isOpenCashProtector  1
#define isOpenAssert         1
//isOpenAssert配合异常断点一起使用(自动定位到崩溃位置)

static NNForwardingTarget *_target = nil;

@implementation NSObject (CashProtector)

//+(BOOL)swizzleMethodClass:(Class)clz origMethod:(SEL)origSelector newMethod:(SEL)newSelector{
//    //1. 通过class_getInstanceMethod()函数从当前对象中的method list获取method结构体，如果是类方法就使用class_getClassMethod()函数获取。
//    Method original = class_getInstanceMethod(clz, origSelector);
//    Method replace = class_getInstanceMethod(clz, newSelector);
//    
//    //2.若UIViewController类没有该方法,那么它会去UIViewController的父类去寻找,为了避免不必要的麻烦,我们先进行一次添加
//    BOOL AddMethod = class_addMethod(clz, origSelector, method_getImplementation(replace), method_getTypeEncoding(replace));
//    //3.如果原来类没有这个方法,可以成功添加;如果原来类里面有这个方法,那么将会添加失败
//    if (!AddMethod) {
//        method_exchangeImplementations(original, replace);
//        return YES;
//    }
//    else{
//        class_replaceMethod(clz, newSelector, method_getImplementation(original),  method_getTypeEncoding(original));
//
//    }
//    return NO;
//}

#pragma mark - - load

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _target = [NNForwardingTarget new];;

        if (isOpenCashProtector) { 
            swizzleInstanceMethod(NSClassFromString(@"__NSArrayI"),
                                  @selector(objectAtIndex:), NSSelectorFromString(@"safe_objectAtIndex:"));
            swizzleInstanceMethod(NSClassFromString(@"__NSArrayI"),
                                  @selector(objectAtIndexedSubscript:), @selector(safe_objectAtIndexedSubscript:));
            
            swizzleInstanceMethod(NSClassFromString(@"__NSArrayM"),
                                  @selector(objectAtIndex:), NSSelectorFromString(@"safe_objectAtIndex:"));
            swizzleInstanceMethod(NSClassFromString(@"__NSArrayM"),
                                  @selector(objectAtIndexedSubscript:), NSSelectorFromString(@"safe_objectAtIndexedSubscript:"));
            swizzleInstanceMethod(NSClassFromString(@"__NSArrayM"),
                                  @selector(addObject:), NSSelectorFromString(@"safe_addObject:"));
            swizzleInstanceMethod(NSClassFromString(@"__NSArrayM"),
                                  @selector(insertObject:atIndex:), NSSelectorFromString(@"safe_insertObject:atIndex:"));
            
            
            //NSClassFromString(@"__NSDictionaryM"),objc_getClass("__NSDictionaryM")
            swizzleInstanceMethod(NSClassFromString(@"__NSDictionaryM"),
                                  @selector(setObject:forKey:), NSSelectorFromString(@"safe_setObject:forKey:"));
            swizzleInstanceMethod(NSClassFromString(@"__NSDictionaryM"),
                                  @selector(setObject:forKeyedSubscript:), @selector(safe_setObject:forKeyedSubscript:));
            swizzleInstanceMethod(NSClassFromString(@"__NSDictionaryM"),
                                  @selector(removeObjectForKey:), @selector(safe_removeObjectForKey:));
            
            
            swizzleInstanceMethod(self.class,
                                  @selector(forwardingTargetForSelector:), @selector(swz_forwardingTargetForSelector:));
        }
    });
}

+ (BOOL)isWhiteListClass:(Class)class {
    NSString *classString = NSStringFromClass(class);
    BOOL isInternal = [classString hasPrefix:@"_"];
    if (isInternal) {
        return NO;
    }
    BOOL isNull = [classString isEqualToString:NSStringFromClass(NSNull.class)];
//    BOOL isMyClass  = [classString ...];//前缀处理
//    return isNull || isMyClass;
    return isNull;
}

- (id)swz_forwardingTargetForSelector:(SEL)aSelector {
    id result = [self swz_forwardingTargetForSelector:aSelector];
    if (result) {
        return result;
    }
    BOOL isWhiteListClass = [self.class isWhiteListClass: self.class];
    if (!isWhiteListClass) {
        return nil;
    }
    result = _target;
    return result;
}


@end


@implementation NSMutableDictionary (CashProtector)

- (void)safe_setObject:(id)anObject forKey:(id <NSCopying>)aKey{
    if (isOpenAssert) NSAssert(anObject && aKey, @"anObject和aKey不能为nil");
    if (anObject && aKey) {
        [self safe_setObject:anObject forKey:aKey];
    }
}


- (void)safe_setObject:(id)anObject forKeyedSubscript:(id <NSCopying>)aKey {
    if (isOpenAssert) NSAssert(anObject && aKey, @"anObject和aKey不能为nil");
    if (anObject && aKey) {
        [self safe_setObject:anObject forKeyedSubscript:aKey];
    }
}

- (void)safe_removeObjectForKey:(id <NSCopying>)aKey {
    if (isOpenAssert) NSAssert(aKey, @"aKey不能为nil");
    if (aKey) {
        [self safe_removeObjectForKey:aKey];
    }
}

@end


@implementation NSArray (CashProtector)

- (id)safe_objectAtIndex:(NSUInteger)index{
    if (index >= self.count) {
        if (isOpenAssert) NSAssert(index < self.count, @"index越界");
        return nil;
    }
    return [self safe_objectAtIndex:index];
}

- (id)safe_objectAtIndexedSubscript:(NSUInteger)index {
    NSUInteger count = self.count;
    if (count == 0 || index >= count) {
        if (isOpenAssert) NSAssert(index < self.count, @"index越界");
        return nil;
    }
    return [self safe_objectAtIndexedSubscript:index];
}

@end


@implementation NSMutableArray (CashProtector)

- (id)safe_objectAtIndex:(NSUInteger)index{
    if (index >= self.count) {
//        DDLog(@"index越界");
        if (isOpenAssert) NSAssert(index < self.count, @"index越界");
        return nil;
    }
    return [self safe_objectAtIndex:index];
}

- (id)safe_objectAtIndexedSubscript:(NSUInteger)index {
    NSUInteger count = self.count;
    if (count == 0 || index >= count) {
        return nil;
    }
    return [self safe_objectAtIndexedSubscript:index];
}

- (void)safe_addObject:(id)anObject{
    if(!anObject){
        if (isOpenAssert) NSAssert(anObject, @"anObject不能为nil");
        return ;
    }
    [self safe_addObject:anObject];
}

- (void)safe_insertObject:(id)anObject atIndex:(NSUInteger)index{
    if(!anObject){
        if (isOpenAssert) NSAssert(anObject, @"anObject不能为nil");
        return ;
    }
    [self safe_insertObject:anObject atIndex:index];
}


@end




