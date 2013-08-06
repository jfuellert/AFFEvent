//
//  TestButton.m
//  AFFEvent
//
//  Created by Jeremy Fuellert on 2013-08-05.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "TestButton.h"

@implementation TestButton

AFFEventSynthesize(AFFEventInstance, evtPressed);

- (id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self)
    {
        [self setTitle: @"Press me"];
        [self setButtonType:NSMomentaryLightButton];
        [self setBezelStyle:NSRoundedBezelStyle];
        [self setTarget:self];
        [self setAction:@selector(onPress)];
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
