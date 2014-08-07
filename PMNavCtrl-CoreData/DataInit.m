//
//  DataInit.m
//  PMNavCtrl-CoreData
//
//  Created by Paola Mata Maldonado on 7/14/14.
//
//

#import "DataInit.h"


@implementation DataInit

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
    product3.name = @"iPad";
    product3.logoName = @"apple-logo.png";
    product3.url = @"http://apple.com/ipad";
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
        self.companies = [[NSMutableArray alloc]initWithArray:result];
        NSLog(@"Companies Count %d", [self.companies count]);
            
        }
}

-(void)removeProduct:(Product *)product{

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Product" inManagedObjectContext:self.context]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"name == %@",product.name]];
    NSError* error;
    
    NSArray *result = [self.context executeFetchRequest:fetchRequest error:&error];

    [self.context deleteObject:result[0]];

//    [self saveChanges];
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



@end
