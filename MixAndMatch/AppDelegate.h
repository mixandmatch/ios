//
//  AppDelegate.h
//  MixAndMatch
//
//  Created by Florian Schebelle on 23.02.12.
//  Copyright (c) 2012 metafinanz Informationssysteme GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "SetUserViewController.h"

@interface AppDelegate : NSObject <UIApplicationDelegate,
MFSetUserDelegate>
{
    NSString *_userName;
}

+ (NSDateFormatter *) GERMAN_DATE_FORMATTER;
+ (NSDateFormatter *) JSON_DATE_FORMATTER;
+ (void)showDefaultErrorAlert:(id)currentView;

@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property(nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet UIWindow *window;

@end
