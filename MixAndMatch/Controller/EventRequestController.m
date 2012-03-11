//
//  EventRequestControllerViewController.m
//  MixAndMatch
//
//  Created by Florian Schebelle on 22.02.12.
//  Copyright (c) 2012 metafinanz Informationssysteme GmbH. All rights reserved.
//

#import "EventRequestController.h"
#import "EventRequest.h"
#import "AppDelegate.h"
#import "NSString+StringUtils.h"

@interface EventRequestController ()

@end

@implementation EventRequestController

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSMutableString *requestPath = [[NSMutableString alloc] initWithString:@"/requests"];
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:requestPath objectMapping:[EventRequest mapping] delegate:self];
    [requestPath release];
    
    [self.activityIndicatorView startAnimating];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EventRequest *item;
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
    
    static NSString *cellIdentifier = @"EventRequest";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        [cell autorelease];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    NSMutableString *itemText = [[NSMutableString alloc] initWithString:@""];
    NSDateFormatter *formatter = [AppDelegate GERMAN_DATE_FORMATTER];
    [formatter retain];
    
    if(![NSString isBlank:item.userid])
    {
        [itemText appendString:item.userid];
    }
    cell.detailTextLabel.text = itemText;
    
    NSMutableString *detailText = [[NSMutableString alloc] initWithString:[formatter stringFromDate: item.date]];
    [detailText appendString:@":"];
    cell.textLabel.text=detailText;
    
    [item release];
    [itemText release];
    [detailText release];
    [cellIdentifier release];
    [formatter release];
    
    return cell;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark RestKit Object Loader

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    
    NSMutableArray *_hvuEvents = [[NSMutableArray alloc] init];
    NSMutableArray *_kpEvents = [[NSMutableArray alloc] init];
    NSMutableArray *_othersEvents = [[NSMutableArray alloc] init];
    
    for (EventRequest *event in objects) {
        if(event.userid)
        {
            if([@"HVU" caseInsensitiveCompare:event.locationKey] == NSOrderedSame)
            {
                [_hvuEvents addObject:event];
            }else if([@"kistenpfennig" caseInsensitiveCompare:event.locationKey] == NSOrderedSame)
            {
                [_kpEvents addObject:event];
            }else
            {
                [_othersEvents addObject:event];
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
