//
//  RootViewController.m
//  MixAndMatch
//
//  Created by Florian Schebelle on 23.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SetUserViewController.h"
#import "NSString+StringUtils.h"
#import "SetupLunchViewController.h"
#import "EventRequestController.h"
#import "MatchController.h"

@interface SetUserViewController ()

@end

@implementation SetUserViewController

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
    UITabBarController *controller = (UITabBarController *)[[self view].window rootViewController];
    
    if(![NSString isBlank:_userNameTextField.text]
       && [_userNameTextField.text length] > 2
       && [_userNameTextField.text length] < 5)
    {
        if(_userName)
        {
            [_userName release];
        }
        _userName = [[NSString alloc] initWithString:_userNameTextField.text];
        NSLog(@"Username: %@", _userName);
        for(int i = 1; i<4; i++)
        {
            UIViewController *viewController = [controller.viewControllers objectAtIndex:i];
            [viewController.tabBarItem setEnabled:YES];
        }
    }
    else {
        for(int i = 1; i<4; i++)
        {
            UIViewController *viewController = [controller.viewControllers objectAtIndex:i];
            [viewController.tabBarItem setEnabled:NO];
        }
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
