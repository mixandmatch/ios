//
//  MatchDetailViewControllerViewController.h
//  MixAndMatch
//
//  Created by Florian Schebelle on 11.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import "Match.h"

@interface MatchDetailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    Match *_match;
    UITableView *_tableView;
    NSMutableArray *_matchDetailContent;
    NSMutableArray *_matchDetailText;
}

@property(nonatomic,retain) IBOutlet UITableView *tableView;
-(IBAction)close:(id)sender;
-(IBAction)importEvent:(id)sender;
- (id)initWithMatchDetail:(Match *)match;



@end
