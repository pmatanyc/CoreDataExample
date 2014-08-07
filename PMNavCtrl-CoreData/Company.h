//
//  Company.h
//  PMNavCtrl-CoreData
//
//  Created by Paola Mata Maldonado on 7/14/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Company : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * stockSym;
@property (nonatomic, retain) NSString * logoName;
@property (nonatomic, retain) NSString * stockPrice;
@property (nonatomic, retain) NSSet *products;
@end

@interface Company (CoreDataGeneratedAccessors)

- (void)addProductsObject:(NSManagedObject *)value;
- (void)removeProductsObject:(NSManagedObject *)value;
- (void)addProducts:(NSSet *)values;
- (void)removeProducts:(NSSet *)values;

@end
