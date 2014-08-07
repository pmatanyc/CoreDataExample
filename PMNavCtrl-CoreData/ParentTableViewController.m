//
//  ParentTableViewController.m
//  PMNavCtrl
//
//  Created by Paola Mata Maldonado on 7/2/14.
//
//

#import "ParentTableViewController.h"


@interface ParentTableViewController ()

@end


@implementation ParentTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.title = @"Mobile Device Makers";
    
//THIS SHOULD WORK (BELOW) BUT DOESN'T, SO WAS MOVED TO VIEWWILLAPPEAR
//    self.childTableVC_IB = [[ChildTableViewController alloc]init];
   
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    if (self) {
        [self initModelContext];
    }
    
    [self loadCompanies];
    
    if([self.companyList count] == 0){
        [self createCompanies];
        [self loadCompanies];
    }
    
    [self getStockPrices];
    
    self.childTableVC_IB = [[ChildTableViewController alloc]init];
    
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
    return [self.companyList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Company *company = [self.companyList objectAtIndex:indexPath.row];
    if (company.stockPrice)
       cell.textLabel.text = [NSString stringWithFormat:@"%@: %@",company.name, company.stockPrice];
    else cell.textLabel.text = company.name;
    cell.imageView.image = [UIImage imageNamed: company.logoName];
  
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
    
    Company *company = [self.companyList objectAtIndex:indexPath.row];

    
    self.childTableVC_IB.title = [NSString stringWithFormat:@"%@ mobile devices",company.name ];
    

    self.childTableVC_IB.companyName = company.name;
    
    // Push the view controller.

    [self.navigationController pushViewController:self.childTableVC_IB animated:YES];
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

-(void)getStockPrices{
    
    //ASYNC CALL TO RETRIEVE STOCK PRICES
    NSString *baseURL = @"http://finance.yahoo.com/d/quotes.csv?s=";
    
    for (Company *co in self.companyList){
        if (co != [self.companyList lastObject]) {
            baseURL = [baseURL stringByAppendingString: [NSString stringWithFormat:@"%@+",co.stockSym]];
        }
        else{
        baseURL = [baseURL stringByAppendingString: [NSString stringWithFormat:@"%@&f=a",co.stockSym]];
            }
            
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:baseURL]];
    
    NSURLConnection *conn = [NSURLConnection connectionWithRequest:request delegate:self];
    
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    
    NSString *responseString = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
    
    self.stockPrices = [[NSMutableArray alloc]initWithArray:[responseString componentsSeparatedByString:@"\n"]];
    
    for (Company *company in self.companyList) {
        company.stockPrice = [self.stockPrices objectAtIndex:[self.companyList indexOfObject:company]];
        [self.tableView reloadData];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    
    if ([error.localizedDescription isEqualToString:@"The Internet connection appears to be offline."]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Connection Error" message:error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
}


-(id)init{
    if(self = [super init]){
        
        [self initModelContext];
    }
    return self;
}

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
    //    [self.context setUndoManager:nil];
    
}

-(NSString*)archivePath
{
    NSArray *documentsDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [documentsDirectories objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"Companies.data"];
}



-(void)loadCompanies
{
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [[self.model entitiesByName] objectForKey:@"Company"];
    [request setEntity:entity];
    NSError *error = nil;
    NSArray *result = [self.context executeFetchRequest:request error:&error];
    if(!result){
        [NSException raise:@"Fetch Failed" format:@"Reason: %@", [error localizedDescription]];
    }
    else{
        self.companyList = [[NSMutableArray alloc]initWithArray:result];
        NSLog(@"Companies Count %d", [self.companyList count]);
        
    }
    [self.tableView reloadData];
}


-(void)undoLast{
    [self.context undo];
    [self loadCompanies];
}

-(void) saveChanges
{
    NSError *err = nil;
    BOOL successful = [self.context save:&err];
    if(!successful){
        NSLog(@"Error saving: %@", [err localizedDescription]);
    }
    NSLog(@"Data Saved");
    
}

-(void)createCompanies{
    Company *company1 = [NSEntityDescription insertNewObjectForEntityForName:@"Company" inManagedObjectContext:self.context];
    company1.name = @"Apple";
    company1.stockSym = @"AAPL";
    company1.logoName = @"apple-logo.png";
    ;

    Product *product1 = [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:self.context];
    product1.name = @"iPhone";
    product1.logoName = @"apple-logo.png";
    product1.url = @"http://apple.com/iphone";
    product1.company = company1;
    [company1 addProductsObject:product1];

    Product *product2 = [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:self.context];
    product2.name = @"iPad";
    product2.logoName = @"apple-logo.png";
    product2.url = @"http://apple.com/ipad";
    product2.company = company1;
    [company1 addProductsObject:product2];

    Product *product3 = [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:self.context];
    product3.name = @"iPod Touch";
    product3.logoName = @"apple-logo.png";
    product3.url = @"http://apple.com/ipod-touch";
    product3.company = company1;
    [company1 addProductsObject:product3];

    company1.products = [NSSet setWithObjects:product1,product2, product3, nil];

    Company *company2 = [NSEntityDescription insertNewObjectForEntityForName:@"Company" inManagedObjectContext:self.context];
    company2.name = @"Samsung";
    company2.stockSym = @"SSNLF";
    company2.logoName = @"samsung-logo.jpeg";

    Product *product4 = [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:self.context];
    product4.name = @"Galaxy S5";
    product4.logoName = @"samsung-logo.jpeg";
    product4.url = @"http://www.samsung.com";
    product4.company = company2;
    [company2 addProductsObject:product4];

    Product *product5 = [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:self.context];
    product5.name = @"Galaxy Tab";
    product5.logoName = @"samsung-logo.jpeg";
    product5.url = @"http://www.samsung.com";
    product5.company = company2;
    [company2 addProductsObject:product5];

    Product *product6 = [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:self.context];
    product6.name = @"Galaxy Note";
    product6.logoName = @"samsung-logo.jpeg";
    product6.url = @"http://www.samsung.com";
    product6.company = company2;
    [company2 addProductsObject:product6];

    company2.products = [NSSet setWithObjects:product4,product5, product6, nil];

    Company *company3 = [NSEntityDescription insertNewObjectForEntityForName:@"Company" inManagedObjectContext:self.context];
    company3.name = @"Google";
    company3.stockSym = @"GOOG";
    company3.logoName = @"google-logo.png";

    Product *product7 = [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:self.context];
    product7.name = @"Google Glass";
    product7.logoName = @"google-logo.png";
    product7.url = @"http://www.google.com";
    product7.company = company3;
    [company3 addProductsObject:product7];

    Product *product8 = [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:self.context];
    product8.name = @"Nexus 10";
    product8.logoName = @"google-logo.png";
    product8.url = @"http://www.google.com";
    product8.company = company3;
    [company3 addProductsObject:product8];

    Product *product9 = [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:self.context];
    product9.name = @"Chromecast";
    product9.logoName = @"google-logo.png";
    product9.url = @"http://www.google.com";
    product9.company = company3;
    [company3 addProductsObject:product9];
    company3.products = [NSSet setWithObjects:product7,product8, product9, nil];

    Company *company4 = [NSEntityDescription insertNewObjectForEntityForName:@"Company" inManagedObjectContext:self.context];
    company4.name = @"Windows";
    company4.stockSym = @"MSFT";
    company4.logoName = @"windows-logo.png";

    Product *product10 = [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:self.context];
    product10.name = @"Huawei W1";
    product10.logoName = @"windows-logo.png";
    product10.url = @"http://www.windowsphone.com/en-us/";
    product10.company = company4;
    [company4 addProductsObject:product10];

    Product *product11 = [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:self.context];
    product11.name = @"Nokia Lumia";
    product11.logoName = @"windows-logo.png";
    product11.url = @"http://www.windowsphone.com/en-us/";
    product11.company = company4;
    [company4 addProductsObject:product11];

    Product *product12 = [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:self.context];
    product12.name = @"Samsung ATV SE";
    product12.logoName = @"windows-logo.png";
    product12.url = @"http://www.windowsphone.com/en-us/";
    product12.company = company4;
    [company4 addProductsObject:product12];

    company4.products = [NSSet setWithObjects:product10,product11, product12, nil];

    [self saveChanges];

}




@end
