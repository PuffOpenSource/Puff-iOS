//
//  PFDBExporter.h
//  Puff
//
//  Created by bob.sun on 12/01/2017.
//  Copyright © 2017 bob.sun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PFDBExporter : NSObject
typedef void(^PFDBExporterCallback)(NSError *err, NSObject *result);
- (void)runWithCompletion:(PFDBExporterCallback)callback;
@end
