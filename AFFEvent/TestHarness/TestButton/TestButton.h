//
//  TestButton.h
//  AFFEvent
//
//  Created by Jeremy Fuellert on 2013-07-21.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TestButton : NSButton

AFFEventCreate(AFFEventInstance, evtPressed);

@end
