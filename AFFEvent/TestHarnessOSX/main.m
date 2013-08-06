//
//  main.m
//  TestHarnessOSX
//
//  Created by Jeremy Fuellert on 2013-08-05.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"

int main(int argc, char *argv[])
{
    [NSApplication sharedApplication];
    
    AppDelegate *appDelegate = [[AppDelegate alloc] init];
    [NSApp setDelegate:appDelegate];
    [NSApp run];
    
    return 0;
}
