//
//  ViewController.h
//  TestHarness
//
//  Created by Jeremy Fuellert on 2013-07-21.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TestButton;

@interface ViewController : UIViewController
{
    @private
    UILabel *outputLabel;
    UILabel *textLabel;

    TestButton *buttonOne;
    TestButton *buttonTwo;
}

@end
