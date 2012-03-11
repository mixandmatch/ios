//
//  BaseLunchController.h
//  
//
//  Created by Florian Schebelle on 11.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "SetUserViewController.h"

typedef enum _LocationTypes{
    HVU=0,
    KP=1
}_LocationEnum;

@interface BaseLunchController : UIViewController <RKObjectLoaderDelegate, UITableViewDelegate,UITableViewDataSource>
{   
    @private
    NSArray *_entriesHVU;
    NSArray *_entriesKP;
    NSArray *_entriesOthers;
    id<MFSetUserDelegate> _masterController;
    UIActivityIndicatorView* _activityIndicatorView;
    UITableView *_tableView;
}

@property(nonatomic, retain) NSArray *entriesHVU;
@property(nonatomic, retain) NSArray *entriesKP;
@property(nonatomic, retain) NSArray *entriesOthers;
@property(nonatomic, retain) id<MFSetUserDelegate> masterController;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil masterController:(id<MFSetUserDelegate>)delegate;
-(void)resetEvents;
@end
