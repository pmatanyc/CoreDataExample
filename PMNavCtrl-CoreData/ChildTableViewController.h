//
//  ChildTableViewController.h
//  PMNavCtrl
//
//  Created by Paola Mata Maldonado on 7/2/14.
//
//

#import <UIKit/UIKit.h>
#import "WebViewController.h"
#import "Product.h"


@interface ChildTableViewController : UITableViewController{
    Product *product;
}

@property (strong, nonatomic) IBOutlet WebViewController *webViewVC_IB;



@property(nonatomic)NSManagedObjectContext *context;
@property (nonatomic)NSManagedObjectModel *model;

@property (nonatomic)NSMutableArray *products;
@property (nonatomic)NSString*companyName;


-(IBAction)undoButton:(id)sender;

-(void)loadData;
-(void)deleteProductAtIndex:(int)index;


@end
