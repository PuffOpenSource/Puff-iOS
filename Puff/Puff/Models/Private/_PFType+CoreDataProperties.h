//
//  _PFType+CoreDataProperties.h
//  
//
//  Created by bob.sun on 25/11/2016.
//
//

#import "_PFType+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface _PFType (CoreDataProperties)

+ (NSFetchRequest<_PFType *> *)fetchRequest;

@property (nonatomic) int64_t category;
@property (nullable, nonatomic, copy) NSString *icon;
@property (nonatomic) int64_t identifier;
@property (nullable, nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
