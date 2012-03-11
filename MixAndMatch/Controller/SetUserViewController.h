//
//  RootViewController.h
//  MixAndMatch
//
//  Created by Florian Schebelle on 23.02.12.
//  Copyright (c) 2012 metafinanz Informationssysteme GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SetUserViewController;

@protocol MFSetUserDelegate <NSObject>
@required
-(void)setLoginUserName:(NSString *)userName;
-(NSString *)loginUserName;
@end

@interface SetUserViewController : UIViewController<UITextFieldDelegate>
{
    @private
    id<MFSetUserDelegate> _masterController;
}
@property(nonatomic,retain) IBOutlet UITextField *userNameTextField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil masterController:(id<MFSetUserDelegate>)delegate;

@end
