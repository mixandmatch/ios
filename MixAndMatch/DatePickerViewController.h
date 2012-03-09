//
//  DatePickerViewController.h
//  MixAndMatch
//
//  Created by Florian Schebelle on 27.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DatePickerViewController;

@protocol DateControllerDelegate <NSObject>

@required
- (void) transferDate:(NSDate *) date;

@end

@interface DatePickerViewController : UIViewController<UIPickerViewDelegate>{
    UITextField *dateTextField;
    UIDatePicker *datePicker;
}

@property (nonatomic, retain) id<DateControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, retain) IBOutlet UITextField *dateTextField;
- (IBAction)updateDateValue:(id)sender;
@end
