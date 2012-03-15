//
//  EventRequestRESTTests.h
//  MixAndMatch
//
//  Created by Florian Schebelle on 12.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseRESTFulTests.h"
#import "EventRequest.h"

@interface EventRequestRESTTests : BaseRESTFulTests
{
    BOOL done;
    BOOL runTest;
    EventRequest *requestForTestUser;
    NSDate *currentDate;
    double thinkTime;
}
@end
