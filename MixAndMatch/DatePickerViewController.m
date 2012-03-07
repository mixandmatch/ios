//
//  DatePickerViewController.m
//  MixAndMatch
//
//  Created by Florian Schebelle on 27.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DatePickerViewController.h"
#import "AppDelegate.h"

@interface DatePickerViewController ()

@end

@implementation DatePickerViewController

@synthesize delegate=_delegate;
@synthesize datePicker=_datePicker;
@synthesize dateTextField=_dateTextField;

- (void)dealloc
{
    [_dateTextField release];
    [_datePicker release];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setCurrentDateFromPicker];
    [self reloadInputViews];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if([_delegate respondsToSelector:@selector(transfeDate:)])
    {
        [_delegate transfeDate:[_datePicker date]];
    }
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self setCurrentDateFromPicker];
    [self reloadInputViews];
}

- (void)setCurrentDateFromPicker
{
    NSDateFormatter *formatter = [AppDelegate jsonToObject];
    _dateTextField.text = [formatter stringFromDate: [_datePicker date]];
}

- (void)updateDateValue:(id)sender
{
    NSDateFormatter *formatter = [AppDelegate jsonToObject];
    NSDate *date = [_datePicker date];
    _dateTextField.text = [formatter stringFromDate:date];
    [self reloadInputViews];
}

@end
