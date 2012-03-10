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
@synthesize userName = _userName;

- (void)dealloc
{
    [_userName release];_userName=nil;
    [_userNameTextField release];_userNameTextField=nil;
    [super dealloc];
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
        // In case of apreviousely setted user name, release the old object.
        if(_userName)
        {
            [_userName release];
        }
        _userName = [[NSString alloc] initWithString:_userNameTextField.text.lowercaseString];
        NSLog(@"Username: %@", _userName);
        // enable all other tabs
        [self enableControllers:YES];
    }
    else {
        // Reset user name
        [_userName release];
        _userName = nil;
        // Disalbe controllers
        [self enableControllers:NO];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
# pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self setUserName:[textField text]];
    [self confirmUser];
    [textField resignFirstResponder];
    
    return YES;
}

@end
