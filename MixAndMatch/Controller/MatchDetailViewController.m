//
//  MatchDetailViewControllerViewController.m
//  MixAndMatch
//
//  Created by Florian Schebelle on 11.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MatchDetailViewController.h"
#import "AppDelegate.h"
@interface MatchDetailViewController ()

@end

@implementation MatchDetailViewController
@synthesize tableView = _tableView;

- (id)initWithMatchDetail:(Match *)match
{
    self = [super initWithNibName:@"MatchDetailView" bundle:nil];
    
    if(self)
    {
        if(_match)
        {
            [_match release];
        }
        _match=match;
        [_match retain];
        _matchDetailContent = [[NSMutableArray alloc] init];
        _matchDetailText = [[NSMutableArray alloc] init];
        
        [_matchDetailText addObject:@"Location:"];
        [_matchDetailContent addObject:_match.locationKey];
        [_matchDetailText addObject:@"Date:"];
        NSDateFormatter *formatter = [AppDelegate GERMAN_DATE_FORMATTER];
        [formatter retain];
        [_matchDetailContent addObject:[formatter stringFromDate: _match.date]];
        [_matchDetailText addObject:@"Members"];
        NSMutableString *userString = [[NSMutableString alloc]initWithString:[_match.users objectAtIndex:0]];
        for(int i = 1; i < [_match.users count];i++)
        {
            [userString appendString:@", "];
            [userString appendString:[_match.users objectAtIndex:i]];
            
        }
        [_matchDetailContent addObject:userString];
        
        [formatter release];
        [userString release];
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    @throw [NSException exceptionWithName:@"Wrong initializer"
                                   reason:@"Use initWithMatchDetail:"
                                 userInfo:nil];
    return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *item=[_matchDetailContent objectAtIndex:indexPath.row];
    
    static NSString *cellIdentifier = @"Match";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        [cell autorelease];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    [item retain];
    cell.detailTextLabel.text = item;
    
    cell.textLabel.text=[_matchDetailText objectAtIndex:indexPath.row];
    
    [cellIdentifier release];
    [item release];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_matchDetailContent count];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
# pragma mark IBActions

-(IBAction)close:(id)sender
{
    [[self presentingViewController] dismissModalViewControllerAnimated:YES];
}
-(IBAction)importEvent:(id)sender
{
    EKEventStore *eventDB = [[EKEventStore alloc] init];
    
    EKEvent *myEvent  = [EKEvent eventWithEventStore:eventDB];
    
    NSMutableString *_eventTitle = [[NSMutableString alloc] initWithString:@""];
    
    [_eventTitle appendFormat:@"Lunch mit "];
    // Memebers
    [_eventTitle appendFormat:[_matchDetailContent objectAtIndex:2]];
    [_eventTitle appendFormat:@" in: "];
    [_eventTitle appendFormat:[_matchDetailContent objectAtIndex:0]];
    // Setup date with time
    NSDate *_eventDateStart = [_match.date dateByAddingTimeInterval:41400];
    [_eventDateStart retain];
    NSDate *_eventDateStop = [_match.date dateByAddingTimeInterval:44100];
	[_eventDateStop retain];
    myEvent.title     = _eventTitle;
    myEvent.startDate = _eventDateStart;
    myEvent.endDate   = _eventDateStop;
	myEvent.allDay = NO;
    
    [myEvent setCalendar:[eventDB defaultCalendarForNewEvents]];
    
    [_eventDateStart release];
    [_eventDateStop release];    
    
    NSError *err;
    
    [eventDB saveEvent:myEvent span:EKSpanThisEvent error:&err]; 
    
	if (err == noErr) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Lunch Event Created"
                              message:_eventTitle
                              delegate:nil
                              cancelButtonTitle:@"Okay"
                              otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
    
    [_eventTitle release];
    [eventDB release];
    
}

@end
