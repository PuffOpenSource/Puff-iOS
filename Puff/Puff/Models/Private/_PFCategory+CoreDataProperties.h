//
//  _PFCategory+CoreDataProperties.h
//  
//
//  Created by bob.sun on 25/11/2016.
//
//

#import "_PFCategory+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface _PFCategory (CoreDataProperties)

+ (NSFetchRequest<_PFCategory *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *icon;
@property (nonatomic) int64_t identifier;
@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) int64_t type;

@end

NS_ASSUME_NONNULL_END
