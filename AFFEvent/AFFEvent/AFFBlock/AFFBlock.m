//
//  AFFBlock.m
//  AFFEvent
//
//  Created by Jeremy Fuellert on 2013-08-03.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFFBlock.h"

@implementation AFFBlock

- (id)init
{
    self = [super init];
    if(self)
    {
        _isLocked = FALSE;
        _isOneTimeBlock = FALSE;
    }
    return self;
}

@end
