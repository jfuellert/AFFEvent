//
//  AppDelegate.m
//  TestHarnessOSX
//
//  Created by Jeremy Fuellert on 2013-08-05.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AppDelegate.h"
#import "TestButton.h"

@implementation AppDelegate

const NSUInteger windowWidth = 300;
const NSUInteger windowHeight = 300;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.window = [[NSWindow alloc] initWithContentRect:NSMakeRect(100, 100, windowWidth, windowHeight) styleMask:NSTitledWindowMask | NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:FALSE];
    self.window.backgroundColor = [NSColor whiteColor];
    [self.window makeKeyAndOrderFront:NSApp];
    
    [self createOutputLabel];
    [self createButtons];
}

- (void)createOutputLabel
{
    outputLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(0, windowHeight - 140, windowWidth, 80)];
    outputLabel.backgroundColor = [NSColor clearColor];
    outputLabel.textColor = [NSColor darkGrayColor];
    [outputLabel setBezeled:FALSE];
    [outputLabel setDrawsBackground:FALSE];
    [outputLabel setEditable:TRUE];
    [outputLabel setSelectable:FALSE];
    outputLabel.alignment = kCTTextAlignmentCenter;
    [[self.window contentView] addSubview:outputLabel];
}

- (void)createButtons
{
    NSInteger width = 130;
    NSInteger height = 40;
    NSInteger x = (windowWidth - width) / 2;
    NSInteger y = (windowHeight - height) / 2;
    
    buttonOne = [[TestButton alloc] initWithFrame:NSMakeRect(x, y, width, height)];
    [[buttonOne evtPressed] addHandler:AFFHandler(@selector(onButtonPressed:))];
    [[self.window contentView] addSubview:buttonOne];
}

- (void)onButtonPressed:(AFFEvent *)event
{
    outputLabel.stringValue = [NSString stringWithFormat:@"%d", [event.data intValue]];
}

@end
