//
//  Product.h
//  PMNavCtrl-CoreData
//
//  Created by Paola Mata Maldonado on 7/14/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Company;

@interface Product : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * logoName;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) Company *company;

@end
