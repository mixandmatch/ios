//
//  MatchController.h
//  MixAndMatch
//
//  Created by Florian Schebelle on 23.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@interface MatchController : UITableViewController <RKObjectLoaderDelegate>
{
@private
    NSMutableArray *matches;
    
}

@end
