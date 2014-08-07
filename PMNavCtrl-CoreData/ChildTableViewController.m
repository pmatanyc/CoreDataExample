//
//  ChildTableViewController.m
//  PMNavCtrl
//
//  Created by Paola Mata Maldonado on 7/2/14.
//
//

#import "ChildTableViewController.h"

@interface ChildTableViewController ()

@end

@implementation ChildTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self initModelContext];
    [self loadData];
}


-(IBAction)undoButton:(id)sender{
    [self.context undo];
    [self loadData];
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.products count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    product = [self.products objectAtIndex:indexPath.row];
    cell.textLabel.text = product.name;
    cell.imageView.image = [UIImage imageNamed: product.logoName];
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
    
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self deleteProductAtIndex:indexPath.row];
    [self saveChanges];
        
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    
    product = [self.products objectAtIndex:indexPath.row];
    self.webViewVC_IB.urlString = product.url;
    self.webViewVC_IB.title = product.name;
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:self.webViewVC_IB animated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)initModelContext
{
    self.model = [NSManagedObjectModel mergedModelFromBundles:nil];
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.model];
    NSString *path = [self archivePath];
    NSURL *storeURL = [NSURL fileURLWithPath:path];
    NSError *error = nil;
    if(![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        [NSException raise:@"Open failed" format:@"Reason: %@", [error localizedDescription]];
    }
    self.context = [[NSManagedObjectContext alloc] init];
    
    self.context.undoManager = [[NSUndoManager alloc] init];
    
    [self.context setPersistentStoreCoordinator:psc];
    
}

-(NSString*)archivePath
{
    NSArray *documentsDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [documentsDirectories objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"Companies.data"];
}

-(void)loadData
{
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [[self.model entitiesByName] objectForKey:@"Product"];
    [request setEntity:entity];
    [request setPredicate:[NSPredicate predicateWithFormat:@"company.name == %@",self.companyName]];
    NSError *error = nil;
    NSArray *result = [self.context executeFetchRequest:request error:&error];
    if(!result){
        [NSException raise:@"Fetch Failed" format:@"Reason: %@", [error localizedDescription]];
    }
    else{
        NSLog(@"Products count: %d", [result count]);
    }
    self.products = [result mutableCopy];
    [self.tableView reloadData];
}


-(void)deleteProductAtIndex:(int)index{
    
    product = [[self products] objectAtIndex:index];
        
    [[self context] deleteObject:product];
    
    [self loadData];
}

-(void) saveChanges
{
    NSError *err = nil;
    BOOL successful = [self.context save:&err];
    if(!successful){
        NSLog(@"Error saving: %@", [err localizedDescription]);
    }
    NSLog(@"Data Saved");
    [self.tableView reloadData];
    
}



@end
