AFFEvent
========
AFFEvent is an alternative event system built for iOS. The event system strays away from the traditional NSNotificationCenter and delegation and instead holds an alterable event system that lets you add, remove, and modify events and / or handlers. It also allows for multiple parameter methods to be called upon an event being fired. AFFEvent still allows for default NSNotificationCenter and delegation usage. 

##Purpose
The purpose of this software is to give developers an alternative way to handle events in iOS. It's primary goal is to minimize delegation usage in areas where it should not neccesarily be needed. By removing this need for delegation, classes have more control over events and can do unique things with them, including firing an instance event of one class using a different class, or using class events.

##Support
Earliest tested and supported build and deployment target - iOS 5.0.
Latest tested and supported build and deployment target - iOS 7.0.

##ARC Compatibility
AFFramework is built from non-ARC but is ARC-compatible thanks to Nick Lockwood's ARCHelper found here https://gist.github.com/1563325.
	
##Installation
Copy the AFFEvent folder and contents to your project.
Add the current line to your <AppName>-Prefix.pch file :
		
    #import "AFFEventCenter.h"

##Event Usage
###About
AFFramework events are handled through a central system, much like NSNotificationCenter. Events do not use a 'name' convention; instead they use an object's hash in combination with a unique method name from a class. You may, if needed, modify events through the global AFFEventSystemHandler class, but the recommended way to modify events would be through the event methods themselves.

###Event Levels
There are two event levels available for AFFEvent. AFFEventInstance defines an instance event for it's class, only being accessible through an instance of that class. AFFEventClass defines a class event for it's class, which may be accessible from anywhere yet fired from any method type of that class.

###Event Creation 
Events are created in a class's header file and synthesized in it's implementation using macros. These macros essentially create class and / or instance methods for a class and are therefore are treated as regular objective-c methods.

Header file : 

    AFFEventCreate( $eventLevel, $eventName )

    //@param : $eventLevel 
    //@type : Macro
    //@options : AFFEventClass  AFFEventInstance   

    //@param : $eventName 
    //@type : NSString

Implementation file : 

    AFFEventSynthesize( $eventLevel, $eventName ) 

    //@param : $eventLevel 
    //@type : Macro
    //@options : AFFEventClass  AFFEventInstance   

    //@param : $eventName 
    //@type : NSString

###Event Removal
A class in which an event is created is also responsible for destroying that event in it's deallocation. This can easily be done by using AFFRemoveAllEvents() in a class's dealloc method. This will remove any event objects for that class from the AFFEventSystemHandler. To remove a specific event from a class use AFFRemoveEvent( $eventName ).

    AFFRemoveAllEvents()

    AFFRemoveEvent( $eventName )
    //@param: $eventName 
    //@type : NSString

###Sending an event
An event may be sent by the class in which the event was created and / or by classes outside of it. Any handlers listening for the event will be called and there will be an AFFEvent object sent for the listener's method. Events are sent to all listeners with or without data. 

    //Send events from class
    [[self $eventName] send];
    [[self $eventName] send:data];

    //Send events from an instance of a class
    [[instance $eventName] send];
    [[instance $eventName] send:data];
###Listening for an event
Events may be listened for much like how they are listened for using NSNotificationCenter. To add a handler simply add it to the event you want to listen for and add the selector and arguments, if any.

    [[class $eventName] addHandler:AFFHandler(@selector(SEL))];
    [[instance $eventName] addHandler:AFFHandler(@selector(SEL))];

With arguments:

    [[class $eventName] addHandler:AFFHandlerWithArgs(@selector(SEL:::::…), arg0, arg1, arg2, arg3…)];
    [[instance $eventName] addHandler:AFFHandlerWithArgs(@selector(SEL:::::…), arg0, arg1, arg2, arg3…)];

One time handlers are handlers that are only called once then destroyed from the event sender:

    [[class $eventName] addHandlerOneTime:AFFHandler(@selector(SEL))];
    [[instance $eventName] addHandlerOneTime:AFFHandler(@selector(SEL))];

One time handlers with arguments:

    [[class $eventName] addHandlerOneTime:AFFHandlerWithArgs(@selector(SEL:::::…), arg0, arg1, arg2, arg3…)];
    [[instance $eventName] addHandlerOneTime:AFFHandlerWithArgs(@selector(SEL:::::…), arg0, arg1, arg2, arg3…)];

###Retrieving data from the event to the handler
Retrieving data from an event is very similar to NSNotification usage. The selector for which an event is going to trigger can have multiple parameters. If the event being sent has no data and doesn't need any sender information, then the selector does not need to have an AFFEvent object parameter.

    - (void)eventHandler {}

An event where there is data being sent and / or you'd want to know more information about the event can have an AFFEvent object parameter.

    - (void)eventHandler:(AFFEvent *)event {}

A handler with one or more other parameters must include an AFFEvent object as it's first parameter.

    - (void)eventHandler:(AFFEvent *)event withArg0:(id)arg0 andArg1:(id)arg1 andArg2:(id)arg2 {} 

###Event object
The event object itself has three accessible properties:

    @property (nonatomic, readonly) id sender;
    @property (nonatomic, readonly) id data;
    @property (nonatomic, readonly) NSString *eventName;

The 'sender' property references the object that sent the event.
The 'data' property is the data being sent by the event.
The 'eventName' property is the name of the event that was sent.

###Example Usage
Here is an example of basic usage of AFFEvents. An event is first created in the header file then synthesized through the implementation file. A handler as a selector is then added to the event. 'myAction' method will, when triggered, send the event with data. This data will be retrieved via the handler attached a the data will be logged out. 

    @interface MyClass : NSObject

    AFFEventCreate(AFFEventInstance, evtTest);

    @end

    @implementation MyClass

    AFFEventSynthesize(AFFEventInstance, evtTest);

    - (id)init
    {
        [[self evtTest] addHandler:AFFHandler(@selector(myEvent:))]; 
        [self myAction];
    }

    - (void)myAction
    {
     	[[self evtTest] send:[NSNumber numberWithInt:15]];
    }

    - (void)myEvent:(AFFEvent *)event
    {
    	int result = [[event data] intValue];
    	//result will be '15'
    }

    - (void)dealloc
    {
     	AFFRemoveAllEvents();
        [super dealloc];
    }

    @end
