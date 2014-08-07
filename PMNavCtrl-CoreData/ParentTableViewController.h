//
//  ParentTableViewController.h
//  PMNavCtrl
//
//  Created by Paola Mata Maldonado on 7/2/14.
//
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ChildTableViewController.h"
#import "Company.h"



@interface ParentTableViewController : UITableViewController<NSURLConnectionDelegate>{
    NSMutableData *_responseData;
}

@property (strong, nonatomic) IBOutlet ChildTableViewController *childTableVC_IB;

@property (nonatomic)NSManagedObjectContext *context;
@property (nonatomic)NSManagedObjectModel *model;
@property (nonatomic)NSMutableArray *companies;

-(NSString *) archivePath;
-(void)initModelContext;



@property (nonatomic) NSMutableArray *companyList;
@property (nonatomic) NSMutableArray *stockPrices;



@end
