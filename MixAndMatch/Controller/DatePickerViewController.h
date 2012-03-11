//
//  DatePickerViewController.h
//  MixAndMatch
//
//  Created by Florian Schebelle on 27.02.12.
//  Copyright (c) 2012 metafinanz Informationssysteme GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DatePickerViewController;

@protocol DateControllerDelegate <NSObject>

@required
- (void) transferDate:(NSDate *) date;

@end

@interface DatePickerViewController : UIViewController<UIPickerViewDelegate>{
    UIDatePicker *datePicker;
    NSDate *selectedDate;
}

@property (nonatomic, retain) id<DateControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;
- (IBAction)addDate:(id)sender;
- (IBAction)cancel:(id)sender;
@end
