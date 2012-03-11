//
//  SetupLunchViewController.h
//  MixAndMatch
//
//  Created by Florian Schebelle on 25.02.12.
//  Copyright (c) 2012 metafinanz Informationssysteme GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationController.h"
#import "Location.h"
#import "DatePickerViewController.h"

@interface SetupLunchViewController : UIViewController<LocationControllerDelegate, DateControllerDelegate,UITableViewDelegate, UITableViewDataSource, RKObjectLoaderDelegate> 
{
    @private
    NSArray *_tableSections;
    NSArray *_tableContentDate;
    NSArray *_tableContentLocation;
    UITableView *_table;
    UIBarButtonItem *_barButtonItemAdd;
    id<MFSetUserDelegate> _masterController;
}
@property (nonatomic,retain) Location *selectedLocation;
@property (nonatomic, retain) NSDate *selectedDate;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *barButtonItemAdd;
- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil masterController:(id)delegate;
@end
