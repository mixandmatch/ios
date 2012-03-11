//
//  RootViewController.m
//  MixAndMatch
//
//  Created by Florian Schebelle on 23.02.12.
//  Copyright (c) 2012 metafinanz Informationssysteme GmbH. All rights reserved.
//

#import "SetUserViewController.h"
#import "NSString+StringUtils.h"

@interface SetUserViewController ()

@end

@implementation SetUserViewController

@synthesize userNameTextField = _userNameTextField;

- (void)dealloc
{
    [_userNameTextField release];_userNameTextField=nil;
    [_masterController release]; _masterController=nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil masterController:(id<MFSetUserDelegate>)delegate
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        _masterController = delegate;
        [_masterController retain];
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    @throw [NSException exceptionWithName:@"Wrong initializer"
                                   reason:@"Use initWithNibName: bundle: masterController:"
                                 userInfo:nil];
    return nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_userNameTextField becomeFirstResponder];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
# pragma mark Actions

- (void)enableControllers:(BOOL)flag
{
    UITabBarController *controller = (UITabBarController *)[[self view].window rootViewController];
    // Disable all other tabs
    for(int i = 1; i<4; i++)
    {
        UIViewController *viewController = [controller.viewControllers objectAtIndex:i];
        [viewController.tabBarItem setEnabled:flag];
    }
}

- (void)confirmUser
{
    if(![NSString isBlank:_userNameTextField.text]
       && [_userNameTextField.text length] > 2
       && [_userNameTextField.text length] < 5)
    {
        if([_masterController respondsToSelector:@selector(setLoginUserName:)])
        {
            [_masterController setLoginUserName:_userNameTextField.text.lowercaseString];  
            NSLog(@"Username: %@", [_masterController loginUserName]);
            // enable all other tabs
            [self enableControllers:YES];
        }
    }
    else {
        // Reset user name
        if([_masterController respondsToSelector:@selector(setLoginUserName:)])
        {
            [_masterController setLoginUserName:nil];
        }
        // Disalbe controllers
        [self enableControllers:NO];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
# pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self confirmUser];
    [textField resignFirstResponder];
    
    return YES;
}

@end
