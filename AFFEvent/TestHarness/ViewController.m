//
//  ViewController.m
//  TestHarness
//
//  Created by Jeremy Fuellert on 2013-07-21.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "ViewController.h"
#import "TestButton.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createTextLabel];
    [self createOutputLabel];
    [self createButtons];
}

- (void)createTextLabel
{
    textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 80)];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textColor = [UIColor grayColor];
    textLabel.textAlignment = UITextAlignmentCenter;
    textLabel.text = @"Press the button to retrieve a number";
    [self.view addSubview:textLabel];
}

- (void)createOutputLabel
{
    outputLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 80)];
    outputLabel.backgroundColor = [UIColor clearColor];
    outputLabel.textColor = [UIColor darkGrayColor];
    outputLabel.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:outputLabel];
}

- (void)createButtons
{
    CGFloat buttonWidth = 200;
    CGFloat buttonHeight = 100;
    CGFloat buttonX = (self.view.frame.size.width - buttonWidth) / 2;
    CGFloat buttonY = (self.view.frame.size.height - buttonHeight) / 2 + 20;
    
    buttonOne = [[TestButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight)];
    buttonOne.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:buttonOne];
        
    buttonTwo = [[TestButton alloc] initWithFrame:CGRectMake(buttonX, buttonOne.frame.origin.y + buttonOne.frame.size.height + 20, buttonWidth, buttonHeight)];
    buttonTwo.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:buttonTwo];
    
    //Handler testing
    [[buttonOne evtPressed] addHandler:AFFHandlerWithArgs(@selector(onButtonOnePressed:withSomething:andSomethingElse:), [NSNumber numberWithInt:99], [NSNumber numberWithInt:98])];
    [[buttonOne evtPressed] addHandlerInBackgroundThreadOneTime:AFFHandler(@selector(runBackgroundSelector))];

    [[buttonTwo evtPressed] addHandler:AFFHandler(@selector(onButtonTwoPressed))];
    
    //Block testing
    [[buttonOne evtPressed] addBlock:^(AFFEvent *event) {
        NSLog(@"event.data : %d", [event.data integerValue]);
    } withName:@"blockName"];
    
    [[buttonOne evtPressed] addBlockInBackgroundThread:^(AFFEvent *event) {
        for(NSUInteger i = 0; i <= 5000; i++)
            NSLog(@"Background Block : %d / 5000", i);
    } withName:@"counter"];
}

//Actions
- (void)onButtonOnePressed:(AFFEvent *)event withSomething:(NSNumber *)something andSomethingElse:(NSNumber *)somethingElse
{   
    outputLabel.text = [NSString stringWithFormat:@"%d", [event.data intValue]];
}

- (void)runBackgroundSelector
{
    for(NSUInteger i = 0; i <= 5000; i++)
        NSLog(@"Background Selector : %d / 5000", i);
}

- (void)onButtonTwoPressed
{
    CGFloat hue = ( arc4random() % 256 / 256.0 ); 
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5; 
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    
    outputLabel.textColor = color;
}

@end
