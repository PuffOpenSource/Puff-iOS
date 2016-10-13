//
//  NSObject+Events.h
//  Puff
//
//  Created by bob.sun on 13/10/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PFEvent : NSObject
@property (copy, nonatomic) NSString *name;
@property (retain, nonatomic) NSObject* data;

- (instancetype)initWithName:(NSString*)name andData:(NSObject*)obj;

@end

typedef void (^PFEventHanlder)(PFEvent* event);

@interface NSObject (Events)

+(void)setDispatchQueue:(NSOperationQueue*)queue;

-(void)subscribe:(NSString*)eventName handler:(PFEventHanlder)handler;
-(void)unsubscribe:(NSString*)eventName;
-(void)publish:(NSString*)eventName;
-(void)publish:(NSString *)eventName withData:(NSObject*)data;
-(void)cancelAll;
@end
