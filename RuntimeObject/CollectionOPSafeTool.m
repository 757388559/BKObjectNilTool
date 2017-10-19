//
//  CollectionOPSafeTool.m
//  RuntimeObject
//
//  Created by liugangyi on 2017/10/19.
//  Copyright © 2017年 liugangyi. All rights reserved.
//

#import "CollectionOPSafeTool.h"
#import <objc/runtime.h>

// 字典

#pragma mark - NSDictionary

@interface NSDictionary (SafeTool)

@end

@implementation NSDictionary (SafeTool)

/**
 获取需要被替换的原始Method
 
 @return Method
 */
+ (Method)originalInstanceLiteralMethod {
    
    return class_getInstanceMethod([self reallClass], @selector(initWithObjects:forKeys:count:));
}

/**
 获取用来替换原始Method的Method
 
 @return Method
 */
+ (Method)exchangeInstanceLiteralMethod {
    
    return class_getInstanceMethod([self reallClass], @selector(safe_initWithObjects:forKeys:count:));
}


/**
 字面量创建真实类
 
 @return Reall literal class
 */
+ (Class)reallClass {
    
    return NSClassFromString(@"__NSPlaceholderDictionary");
}

- (instancetype)safe_initWithObjects:(id  _Nonnull const [])objects forKeys:(id<NSCopying>  _Nonnull const [])keys count:(NSUInteger)cnt {
    
    id validObjects[cnt];
    id<NSCopying> validKeys[cnt];
    NSUInteger count = 0;
    
    for (int i = 0; i < cnt ; i++) {
        
        if (objects[i]) {
            validObjects[count] = objects[i];
            validKeys[count] = keys[i];
            count++;
        }
    }
    return [self safe_initWithObjects:validObjects forKeys:validKeys count:count];
}

@end


#pragma mark - NSMutableDictionary

@interface NSMutableDictionary (SafeTool)

@end

@implementation NSMutableDictionary (SafeTool)

/***************** 添加值 *******************/

/**
 获取需要被替换的原始Method
 
 @return Method
 */
+ (Method)originalInstanceSetObjMethod {
    
   return class_getInstanceMethod([self reallClass], @selector(setObject:forKey:));
}

/**
 获取用来替换原始Method的Method
 
 @return Method
 */
+ (Method)exchangeInstanceSetObjMethod {
    
    return class_getInstanceMethod([self reallClass], @selector(safe_setObject:forKey:));
}

/***************** 移除值 *******************/
/**
 获取需要被替换的原始Method
 
 @return Method
 */
+ (Method)originalInstanceRemoveObjectMethod {
    
    return class_getInstanceMethod([self reallClass], @selector(removeObjectForKey:));
}

/**
 获取用来替换原始Method的Method
 
 @return Method
 */
+ (Method)exchangeInstanceRemoveObjectMethod {
    
    return class_getInstanceMethod([self reallClass], @selector(safe_removeObjectForKey:));
}


/**
 获取真是类名

 @return 类
 */
+ (Class)reallClass {
    
    return NSClassFromString(@"__NSDictionaryM");
}


/**
 添加值

 @param anObject anObject description
 @param aKey aKey
 */
- (void)safe_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    
    if (!anObject || !aKey) {
        return;
    }
    [self safe_setObject:anObject forKey:aKey];
}

/**
 移除值

 @param aKey key
 */
- (void)safe_removeObjectForKey:(id)aKey {
    if (!aKey) {
        return;
    }
    [self safe_removeObjectForKey:aKey];
}


@end



// 数组

#pragma mark - NSArray

@interface NSArray (SafeTool)

@end

@implementation NSArray (SafeTool)

/***************** 取值 *******************/
/**
 获取需要被替换的原始Method
 
 @return Method
 */
+ (Method)originalInstanceObjectMethod {
    
    return class_getInstanceMethod([self reallClass], @selector(objectAtIndex:));
}

/**
 获取用来替换原始Method的Method
 
 @return Method
 */
+ (Method)exchangeInstanceObjectMethod {
    
    return class_getInstanceMethod([self reallClass], @selector(safe_objectAtIndex:));
}


/**
 获取真实类名
 
 @return 真正操作的类
 */
+ (Class)reallClass {
    
    return NSClassFromString(@"__NSArrayI");
}

/**
 <#Description#>

 @param index <#index description#>
 @return <#return value description#>
 */
- (id)safe_objectAtIndex:(NSUInteger)index {
    
    if (index >= self.count) {
        return nil;
    }
    return [self safe_objectAtIndex:index];
}

@end

#pragma mark - NSMutableArray

@interface NSMutableArray (SafeTool)

@end

@implementation NSMutableArray (SafeTool)

/***************** 添加值 *******************/
/**
 获取需要被替换的原始Method
 
 @return Method
 */
+ (Method)originalInstanceInsertMethod {
    
    return class_getInstanceMethod([self reallClass], @selector(insertObject:atIndex:));
}

/**
 获取用来替换原始Method的Method
 
 @return Method
 */
+ (Method)exchangeInstanceInsertMethod {
    
    return class_getInstanceMethod([self reallClass], @selector(safe_insertObject:atIndex:));
}

/***************** 取值 *******************/
/**
 获取需要被替换的原始Method
 
 @return Method
 */
+ (Method)originalInstanceObjectMethod {
    
    return class_getInstanceMethod([self reallClass], @selector(objectAtIndex:));
}

/**
 获取用来替换原始Method的Method
 
 @return Method
 */
+ (Method)exchangeInstanceObjectMethod {
    
    return class_getInstanceMethod([self reallClass], @selector(safe_objectAtIndex:));
}

/**
 获取真实类名
 
 @return 真正操作的类
 */
+ (Class)reallClass {
    
    return NSClassFromString(@"__NSArrayM");
}


/**
 设置值代替方法

 @param anObject 插入的Object
 @param index 插入的index
 */
- (void)safe_insertObject:(id)anObject atIndex:(NSUInteger)index {
    
    if (!anObject || index>self.count) {
        return;
    }
    
    [self safe_insertObject:anObject atIndex:index];
}

- (id)safe_objectAtIndex:(NSUInteger)index {
    
    if (index >= self.count) {
        return nil;
    }
    return [self safe_objectAtIndex:index];
}




@end


#pragma mark - NSObject

@interface NSObject (MethodExchage)

/**
 用于方法替换

 @param originalMethod 原始方法
 @param exchangMethod 替代放法
 */
+ (void)method_exchangeOriginalMethod:(Method)originalMethod exchangMethod:(Method)exchangMethod;

@end

@implementation NSObject (MethodExchage)

+ (void)method_exchangeOriginalMethod:(Method)originalMethod exchangMethod:(Method)exchangMethod {
    
    method_exchangeImplementations(originalMethod, exchangMethod);
}

@end

#pragma mark - safeTool的实现

@implementation CollectionOPSafeTool

+ (void)registTool {
    
}

+ (void)load {
    [super load];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        // NSMutableDictionary
        [NSMutableDictionary method_exchangeOriginalMethod:[NSMutableDictionary originalInstanceSetObjMethod] exchangMethod:[NSMutableDictionary exchangeInstanceSetObjMethod]];
        [NSMutableDictionary method_exchangeOriginalMethod:[NSMutableDictionary originalInstanceRemoveObjectMethod] exchangMethod:[NSMutableDictionary exchangeInstanceRemoveObjectMethod]];
        
        // NSDictionary
        [NSDictionary method_exchangeOriginalMethod:[NSDictionary originalInstanceLiteralMethod] exchangMethod:[NSDictionary exchangeInstanceLiteralMethod]];
        
        // NSMutableArray
        [NSMutableArray method_exchangeOriginalMethod:[NSMutableArray originalInstanceObjectMethod] exchangMethod:[NSMutableArray exchangeInstanceObjectMethod]];
        [NSMutableArray method_exchangeOriginalMethod:[NSMutableArray originalInstanceInsertMethod] exchangMethod:[NSMutableArray exchangeInstanceInsertMethod]];
        
        // NSArray
        [NSArray method_exchangeOriginalMethod:[NSArray originalInstanceObjectMethod] exchangMethod:[NSArray exchangeInstanceObjectMethod]];
        
    });
}

@end



