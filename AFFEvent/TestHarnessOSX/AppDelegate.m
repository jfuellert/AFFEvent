//
//  AppDelegate.m
//  TestHarnessOSX
//
//  Created by Jeremy Fuellert on 2013-08-05.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AppDelegate.h"
#import "TestButtonOSX.h"

@implementation AppDelegate

const NSUInteger windowWidth = 300;
const NSUInteger windowHeight = 300;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.window = [[NSWindow alloc] initWithContentRect:NSMakeRect(100, 100, windowWidth, windowHeight) styleMask:NSTitledWindowMask | NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
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
    [outputLabel setBezeled:NO];
    [outputLabel setDrawsBackground:NO];
    [outputLabel setEditable:YES];
    [outputLabel setSelectable:NO];
    outputLabel.alignment = kCTTextAlignmentCenter;
    [[self.window contentView] addSubview:outputLabel];
}

- (void)createButtons
{
    NSInteger width = 150;
    NSInteger height = 40;
    NSInteger x = (windowWidth - width) / 2;
    NSInteger y = (windowHeight - height) / 2;
    
    buttonOne = [[TestButtonOSX alloc] initWithFrame:NSMakeRect(x, y, width, height)];
    buttonOne.title = @"Press for a number";
    [[self.window contentView] addSubview:buttonOne];
    
    [[buttonOne evtPressed] addHandler:AFFHandler(@selector(onButtonOnePressed:))];
    [[buttonOne evtPressed] addBlockInBackgroundThread:^(AFFEvent *event) {
        for(NSUInteger i = 0; i <= 5000; i++)
            NSLog(@"Background Block : %ld / 5000", (unsigned long)i);
    } withName:@"counter"];
    [[buttonOne evtPressed] addHandlerInBackgroundThreadOneTime:AFFHandler(@selector(runBackgroundSelector))];
    
    buttonTwo = [[TestButtonOSX alloc] initWithFrame:NSMakeRect(x, buttonOne.frame.origin.y - buttonOne.frame.size.height, width, height)];
    buttonTwo.title = @"Press for a color";
    [[self.window contentView] addSubview:buttonTwo];
    
    [[buttonTwo evtPressed] addHandler:AFFHandler(@selector(onButtonTwoPressed))];

}

- (void)onButtonOnePressed:(AFFEvent *)event
{
    outputLabel.stringValue = [NSString stringWithFormat:@"%d", [event.data intValue]];
}

- (void)runBackgroundSelector
{
    for(NSUInteger i = 0; i <= 5000; i++)
        NSLog(@"Background Selector : %ld / 5000", (unsigned long)i);
}

- (void)onButtonTwoPressed
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
    NSColor *color = [NSColor colorWithCalibratedHue:hue saturation:saturation brightness:brightness alpha:1];
    
    outputLabel.textColor = color;
}

@end
