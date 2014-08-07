//
//  WebViewController.h
//  PMNavCtrl
//
//  Created by Paola Mata Maldonado on 7/2/14.
//
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic) NSString *urlString;

@end
