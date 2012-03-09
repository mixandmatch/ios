//
//  SetupLunchViewController.h
//  MixAndMatch
//
//  Created by Florian Schebelle on 25.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationController.h"
#import "Location.h"
#import "DatePickerViewController.h"

@interface SetupLunchViewController : UITableViewController<LocationControllerDelegate, DateControllerDelegate,RKObjectLoaderDelegate> 
{
    @private
    NSArray *tableSections;
    NSArray *tableContentDate;
    NSArray *tableContentLocation;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forUser: (NSString *) selectedUserName;
@property (nonatomic,retain) Location *selectedLocation;
@property (nonatomic, retain) NSDate *selectedDate;
@property (nonatomic, copy) NSString *userName;
- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;
@end
