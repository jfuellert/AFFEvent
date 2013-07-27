//
//  TestButton.m
//  AFFEvent
//
//  Created by Jeremy Fuellert on 2013-07-21.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "TestButton.h"

@implementation TestButton

AFFEventSynthesize(AFFEventInstance, evtPressed);

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addTarget:self action:@selector(onPress) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)onPress
{    
    [[self evtPressed] send:[NSNumber numberWithInt:arc4random() % 100 + 1]];
}

- (void)dealloc
{
    AFFRemoveAllEvents();
}

@end
