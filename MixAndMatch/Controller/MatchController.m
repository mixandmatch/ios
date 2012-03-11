//
//  MatchController.m
//  MixAndMatch
//
//  Created by Florian Schebelle on 23.02.12.
//  Copyright (c) 2012 metafinanz Informationssysteme GmbH. All rights reserved.
//

#import "MatchController.h"
#import "Match.h"
#import "AppDelegate.h"

@interface MatchController ()

@end

@implementation MatchController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
	// Do any additional setup after loading the view, typically from a nib.
    NSMutableString *requestPath = [[NSMutableString alloc] initWithString:@"/users/"];
    if([self.masterController respondsToSelector:@selector(loginUserName)])
    {
        [requestPath appendString:[self.masterController loginUserName]];
    }
    [requestPath appendString:@"/matches"];
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:requestPath objectMapping:[Match mapping] delegate:self];
    [requestPath release];
    
    [self.activityIndicatorView startAnimating];

}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Match *item;
    
    if(indexPath.section==HVU)
    {
        item = [self.entriesHVU objectAtIndex:indexPath.row];
    }else if(indexPath.section==KP)
    {
        item = [self.entriesKP objectAtIndex:indexPath.row];
    }else
    {
        item = [self.entriesOthers objectAtIndex:indexPath.row];
    }
    
    static NSString *cellIdentifier = @"Match";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        [cell autorelease];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    
    [item retain];
    NSMutableString *itemText = [[NSMutableString alloc] initWithString:@""];
    NSDateFormatter *formatter = [AppDelegate GERMAN_DATE_FORMATTER];
    [formatter retain];
    
    for(NSString *user in item.users)
    {
        [itemText appendString:user];
        [itemText appendString:@" "];
    }
    cell.detailTextLabel.text = itemText;
    
    NSMutableString *detailText = [[NSMutableString alloc] initWithString:[formatter stringFromDate: item.date]];
    [detailText appendString:@":"];
    cell.textLabel.text=detailText;
    
    [cellIdentifier release];
    [item release];
    [itemText release];
    [detailText release];
    [formatter release];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Match *item;
    
    if(indexPath.section==HVU)
    {
        item = [self.entriesHVU objectAtIndex:indexPath.row];
    }else if(indexPath.section==KP)
    {
        item = [self.entriesKP objectAtIndex:indexPath.row];
    }else
    {
        item = [self.entriesOthers objectAtIndex:indexPath.row];
    }
    [item retain];
    
    Class controllerClass = NSClassFromString(@"MatchDetailViewController");
    UIViewController* viewController = [[controllerClass alloc] initWithMatchDetail:item];
    if (viewController) {
        [self presentViewController:viewController animated:YES completion: nil];
        if (viewController.title == nil) {
            viewController.title = @"Match Detail";
        }
        [viewController release];
    }
    [item release];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark RestKit Object Loader

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    NSMutableArray *_hvuEvents = [[NSMutableArray alloc] init];
    NSMutableArray *_kpEvents = [[NSMutableArray alloc] init];
    NSMutableArray *_othersEvents = [[NSMutableArray alloc] init];
    
    for (Match *match in objects) {
        // Only for rearl matches
        if([match.users count] > 1)
        {
            if([@"HVU" caseInsensitiveCompare:match.locationKey] == NSOrderedSame)
            {
                [_hvuEvents addObject:match];
            }else if([@"kistenpfennig" caseInsensitiveCompare:match.locationKey] == NSOrderedSame)
            {
                [_kpEvents addObject:match];
            }else
            {
                [_othersEvents addObject:match];
            }
        }
    }
    [self resetEvents];
    //Sort Arrays
    [self setEntriesHVU:[_hvuEvents sortedArrayUsingSelector:@selector(compareDate:)]];
    [self setEntriesKP:[_kpEvents sortedArrayUsingSelector:@selector(compareDate:)]];
    [self setEntriesOthers:[_othersEvents sortedArrayUsingSelector:@selector(compareDate:)]];
    
    
    [self.activityIndicatorView stopAnimating];
    
    [self.tableView reloadData];
}
@end
