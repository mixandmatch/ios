//
//  RootViewController.m
//  MixAndMatch
//
//  Created by Florian Schebelle on 23.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "SetupLunchViewController.h"
#import "NSString+StringUtils.h"
@interface RootViewController ()

@end

@implementation RootViewController

@synthesize userNameTextField = _userNameTextField;
@synthesize userName = _userName;

- (void)dealloc
{
    [_userName release];_userName=nil;
    [_userNameTextField release];_userNameTextField=nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
# pragma mark Actions

- (IBAction)setUser:(id)sender
{
    if(![NSString isBlank:_userNameTextField.text]
       && [_userNameTextField.text length] > 2
       && [_userNameTextField.text length] < 5)
    {
        if(_userName)
        {
            [_userName release];
        }
        _userName = [[NSMutableString alloc] initWithString:_userNameTextField.text];
        NSLog(@"Username: %@", _userName);
    }
}

- (IBAction)changeToEventRequestView:(id)sender{
    NSLog(@"Change to Event Request view");
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self changeController:@"EventRequestController" changeView:@"EventRequestView_iPhone"];
    }else{
        [self changeController:@"EventRequestController" changeView:@"EventRequestView_iPad"];
    }
}

- (IBAction)changeToLocationView:(id)sender{
    NSLog(@"Change to Location view");
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self changeController:@"LocationController" changeView:@"LocationView_iPhone"];
    }else{
        [self changeController:@"LocationController" changeView:@"LocationView_iPad"];
    }
}

- (IBAction)changeToMatchView:(id)sender{
    NSLog(@"Change to Match view");
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self changeController:@"MatchController" changeView:@"MatchView_iPhone"];
    }else{
        [self changeController:@"MatchController" changeView:@"MatchView_iPad"];
    }
}
- (IBAction)changeToSetupLunchView:(id)sender
{
    
    NSLog(@"Change to Setup Lunch View");
    SetupLunchViewController *detailViewController;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        detailViewController = [[SetupLunchViewController alloc] initWithNibName:@"SetupLunchView_iPhone" bundle:nil forUser:_userName];
    }else{
        detailViewController = [[SetupLunchViewController alloc] initWithNibName:@"SetupLunchView_iPad" bundle:nil forUser:_userName];
    }
    
    UINavigationController *navController = [[UINavigationController alloc] 
                                             initWithRootViewController:detailViewController];
    [detailViewController release];
    
    [navController setModalPresentationStyle:UIModalPresentationFormSheet];
    [navController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    
    // navController is retained by self when presented
    [self presentModalViewController:navController animated:YES];
    
    [navController release];
}

- (void) changeController: (NSString *) controllerName changeView: (NSString *) viewName
{
    Class controllerClass = NSClassFromString(controllerName);
    UIViewController* viewController = [[controllerClass alloc] initWithNibName:viewName bundle:nil];
    if (viewController) {
        [self.navigationController pushViewController:viewController animated:YES];
        if (viewController.title == nil) {
            viewController.title = controllerName;
        }
        [viewController release];
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
# pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self setUserName:[textField text]];
    [textField resignFirstResponder];
    
    return YES;
}

@end
