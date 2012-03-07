//
//  RootViewController.h
//  MixAndMatch
//
//  Created by Florian Schebelle on 23.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetupLunchViewController.h"

@interface RootViewController : UIViewController<UITextFieldDelegate>
{
}
@property (nonatomic, copy) NSString *userName;
@property(nonatomic,retain) IBOutlet UITextField *userNameTextField;

- (IBAction)setUser:(id)sender;
- (IBAction)changeToEventRequestView:(id)sender;
- (IBAction)changeToLocationView:(id)sender;
- (IBAction)changeToMatchView:(id)sender;
- (IBAction)changeToSetupLunchView:(id)sender;
@end
