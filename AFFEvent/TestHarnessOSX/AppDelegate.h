//
//  AppDelegate.h
//  TestHarnessOSX
//
//  Created by Jeremy Fuellert on 2013-08-05.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class TestButtonOSX;

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    @private
    TestButtonOSX *buttonOne;
    TestButtonOSX *buttonTwo;
    NSTextField *outputLabel;
}

@property (strong, nonatomic) NSWindow *window;

@end
