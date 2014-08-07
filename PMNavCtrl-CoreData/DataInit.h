//
//  DataInit.h
//  PMNavCtrl-CoreData
//
//  Created by Paola Mata Maldonado on 7/14/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "Company.h"
#import "Product.h"


@interface DataInit : NSObject{
    
}

@property (nonatomic)NSManagedObjectContext *context;
@property (nonatomic)NSManagedObjectModel *model;
@property (nonatomic)NSMutableArray *companies;

-(NSString *) archivePath;
-(void)initModelContext;

-(void)createCompanies;
-(void)loadCompanies;

-(void)removeProduct:(Product *)product;

-(void)undoLast;
-(void) saveChanges;

@end
