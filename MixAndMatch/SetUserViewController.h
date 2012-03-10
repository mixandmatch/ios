//
//  RootViewController.h
//  MixAndMatch
//
//  Created by Florian Schebelle on 23.02.12.
//  Copyright (c) 2012 metafinanz Informationssysteme GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetupLunchViewController.h"

@interface SetUserViewController : UIViewController<UITextFieldDelegate>
{
}
@property (nonatomic, copy) NSString *userName;
@property(nonatomic,retain) IBOutlet UITextField *userNameTextField;

@end
