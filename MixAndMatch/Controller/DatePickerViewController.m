//
//  DatePickerViewController.m
//  MixAndMatch
//
//  Created by Florian Schebelle on 27.02.12.
//  Copyright (c) 2012 metafinanz Informationssysteme GmbH. All rights reserved.
//

#import "DatePickerViewController.h"
#import "AppDelegate.h"

@interface DatePickerViewController ()

@end

@implementation DatePickerViewController

@synthesize setupLunchDelegate=_delegate;

- (void)dealloc
{
    [_datePicker release];
    [selectedDate release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
# pragma mark IBAction

- (IBAction)addDate:(id)sender
{
    if(selectedDate)
    {
        [selectedDate release];
    }
    selectedDate = [_datePicker date];
    [selectedDate retain];
    if([_delegate respondsToSelector:@selector(transferDate:)])
    {
        [_delegate transferDate:selectedDate];
    }
    [[self presentingViewController] dismissModalViewControllerAnimated:YES];
}

- (IBAction)cancel:(id)sender
{
    [[self presentingViewController] dismissModalViewControllerAnimated:YES];
    
}
@end
