//
//  NSObject+Events.m
//  Puff
//
//  Created by bob.sun on 13/10/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

//Read Doc - http://blog.leichunfeng.com/blog/2015/06/26/objective-c-associated-objects-implementation-principle/

#import "NSObject+Events.h"
#import <objc/runtime.h>
#import <Foundation/Foundation.h>

static NSString * kEventsKey        =   @"kEventsKey";

@implementation PFEvent
- (instancetype)initWithName:(NSString*)name andData:(NSObject*)obj {
    self = [super init];
    if (self) {
        self.name = name;
        self.data = obj;
    }
    return self;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"PFEvent - name: %@, data %@", self.name, self.data];
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:self.class]) {
        return NO;
    }
    PFEvent *typed = object;
    return [_name isEqualToString:typed.name ] && [self.data isEqual:_data];
}
@end

@implementation NSObject (Events)
static NSOperationQueue *_queue;
static const char* kSubscriptions = "kSubscriptions";

+ (void)setDispatchQueue:(NSOperationQueue *)queue {
    _queue = queue;
}

-(void)subscribe:(NSString*)eventName handler:(PFEventHanlder)handler {
    [self unsubscribe:eventName];
    [[NSNotificationCenter defaultCenter] addObserverForName:eventName object:self queue:_queue usingBlock:^(NSNotification * _Nonnull note) {
        PFEvent *e = [[PFEvent alloc] init];
        e.name = note.name;
        e.data = note.object;
        handler(e);
    }];
    [self _addSubscription:eventName];
}

- (void)subscribe:(NSString*)eventName selector:(SEL)selector {
    [self unsubscribe:eventName];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:selector name:eventName object:nil];
    [self _addSubscription:eventName];
}

-(void)publish:(NSString*)eventName {
    [[NSNotificationCenter defaultCenter] postNotificationName:eventName object:self];
}

-(void)publish:(NSString *)eventName withData:(NSObject*)data {
    [[NSNotificationCenter defaultCenter] postNotificationName:eventName object:self userInfo:@{kEventsKey: data}];
}

-(void)unsubscribe:(NSString *)eventName {
    [self _removeSubscription:eventName];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:eventName object:self];
}

-(void)cancelAll {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Runtime variable management.

- (void)_addSubscription:(NSString*)eventName {
    NSMutableArray *subs = [self _getSubscriptionArray];
    [subs addObject:eventName];
}

- (BOOL)_hasSubscribed:(NSString*)eventName {
    NSMutableArray *subs = [self _getSubscriptionArray];
    return [subs containsObject:eventName];
}

- (void)_removeSubscription:(NSString*)evenName {
    NSMutableArray *subs = [self _getSubscriptionArray];
    [subs removeObject:evenName];
}

- (NSMutableArray*)_getSubscriptionArray {
    NSMutableArray *subs = objc_getAssociatedObject(self, kSubscriptions);
    if (subs == nil) {
        subs = [@[] mutableCopy];
        objc_setAssociatedObject(self, kSubscriptions, subs, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return subs;
}

@end
