AFFEvent
========
AFFEvent is an alternative event system built for iOS and OSX applications. The event system has an alterable event system that lets you add, remove, and modify events and / or handlers and blocks. It also allows for multiple parameter methods and blocks to be called upon an event being fired. 

##Purpose
The purpose of this software is to give developers an alternative way to handle events in iOS. It's primary goal is to minimize delegation usage in areas where it should not necessarily be needed. By removing this need for delegation, classes have more control over events and can do unique things with them including firing an instance event of one class using a another class, using class events, or firing single time events.

##Usage
1. Install via CocoaPods
Copy the AFFEvent folder and contents to your project. Be sure to always use the latest release binary for the easiest and most stable installation.

	```
	pod ‘AFFEvent’
	```
2. Import this header to your ```<AppName>-Prefix.pch``` file :
	```
	#import <AFFEvent/AFFEventCenter.h>
	```

##Support
####IOS
Earliest tested and supported build and deployment target - iOS 5.0.
Latest tested and supported build and deployment target - iOS 7.0.

####OSX
Earliest tested and supported build and deployment target - OSX 10.6.
Latest tested and supported build and deployment target - OSX 10.8.

##ARC Compatibility
AFFEvent is built from non-ARC and is currently not ARC friendly. Use ```-fno-objc-arc``` compiler flags in your project's Build Phases for AFFEvent files when using ARC.

##Event Usage
###About
Events are handled through a central system, much like NSNotificationCenter. Events do not use a 'name' convention or delegation; instead they use an object's hash in combination with a unique method name from a class. You may, if needed, modify events through the global AFFEventSystemHandler class, but the recommended way to modify events would be through the event methods themselves.

###Event Levels
There are two event levels available for AFFEvent. AFFEventInstance defines an instance event for it's class, only being accessible through an instance of that class. AFFEventClass defines a class event for it's class, which may be accessible from anywhere yet fired from any method type of that class.

###Event Creation 
Events are created in a class's header file and synthesized in it's implementation using macros. These macros essentially create class and / or instance methods for a class and are therefore are treated as regular objective-c methods.

Header file : 

``` objective-c
AFFEventCreate( $eventLevel, $eventName )

//@param : $eventLevel 
//@type : Macro
//@options : AFFEventClass, AFFEventInstance   

//@param : $eventName 
//@type : NSString
``` 

Implementation file : 

``` objective-c
AFFEventSynthesize( $eventLevel, $eventName ) 

//@param : $eventLevel 
//@type : Macro
//@options : AFFEventClass, AFFEventInstance   

//@param : $eventName 
//@type : NSString
``` 

##AFFEventAPI
The AFFEventAPI object is the container object for handler interactions. Here is where you can send events, check handlers or blocks, lock and unlock handlers or blocks, add handlers, add blocks, remove handlers, and remove blocks. Events handling can be changed at any time using any of the AFFEventAPI methods. These methods can also be chained.

###Locking / Unlocking Handlers and Blocks
AFFEventAPI objects control their handler and block counterparts so they have the ability to add, remove, or, in this case, lock and unlock any handlers and blocks. Locking a handler method or a block means that the method or block won't be fired upon sending an event. The handler or block is not removed from the event handler list so it can be used again by unlocking it. This locking and unlocking of method handlers and blocks is especially useful in cases where you'd want to temporarily disable interactions; let's say a pop-up menu that blocks other elements in an interface from interacting while the pop-up is active. Here is a list of locking and unlocking methods that AFFEvent provides:

``` objective-c
//Handler lock methods
- (void)lockHandler:(AFFEventHandler *)handler;
- (void)unlockHandler:(AFFEventHandler *)handler;
- (void)lockHandlers:(NSSet *)handlers;
- (void)unlockHandlers:(NSSet *)handlers;
- (void)lockHandlers;
- (void)unlockHandlers;
- (NSSet *)lockedHandlers;
- (NSSet *)unlockedHandlers;
- (BOOL)isHandlerLocked:(AFFEventHandler *)handler;  

//Block lock methods
- (void)lockBlockByName:(NSString *)blockName;
- (void)unlockBlockByName:(NSString *)blockName;
- (void)lockBlocksByNames:(NSSet *)blockNames;
- (void)unlockBlocksByNames:(NSSet *)blockNames;
- (void)lockBlocks;
- (void)unlockBlocks;
- (NSSet *)lockedBlocks;
- (NSSet *)unlockedBlocks;
- (BOOL)isBlockLocked:(NSString *)blockName;
```

Handler locks should be called outside of the class that created the handler's event. This means that '[[self $eventName] lockHandlers]' or '[[self $eventName] unlockHandlers]' should not be called from 'self'.

###Event Removal
A class in which an event is created is also responsible for destroying that event in it's deallocation. This can easily be done by using AFFRemoveAllEvents() in a class's dealloc method. This will remove any event objects for that class from the AFFEventSystemHandler. To remove a specific event from a class use AFFRemoveEvent( $eventName ).

``` objective-c
AFFRemoveAllEvents()

AFFRemoveEvent( $eventName )
//@param: $eventName 
//@type : NSString
``` 

###Sending an event
An event may be sent by the class in which the event was created and / or by classes outside of it. Any handlers listening for the event will be called and there will be an AFFEvent object sent for the listener's method. Events are sent to all listeners with or without data. 

``` objective-c
//Send events from class
[[self $eventName] send];
[[self $eventName] send:data];

//Send events from an instance of a class
[[instance $eventName] send];
[[instance $eventName] send:data];
```

###Listening for an event
Events may be listened for much like how they are listened for using NSNotificationCenter. To add a handler simply add it to the event you want to listen for and add the selector and arguments, if any.

``` objective-c
[[class $eventName] addHandler:AFFHandler(@selector(SEL))];
[[instance $eventName] addHandler:AFFHandler(@selector(SEL))];
``` 
With arguments:

``` objective-c
[[class $eventName] addHandler:AFFHandlerWithArgs(@selector(SEL:::::…), arg0, arg1, arg2, arg3…)];
[[instance $eventName] addHandler:AFFHandlerWithArgs(@selector(SEL:::::…), arg0, arg1, arg2, arg3…)];
``` 
One time handlers are handlers that are only called once then destroyed from the event sender:

``` objective-c
[[class $eventName] addHandlerOneTime:AFFHandler(@selector(SEL))];
[[instance $eventName] addHandlerOneTime:AFFHandler(@selector(SEL))];
``` 
One time handlers with arguments:

``` objective-c
[[class $eventName] addHandlerOneTime:AFFHandlerWithArgs(@selector(SEL:::::…), arg0, arg1, arg2, arg3…)];
[[instance $eventName] addHandlerOneTime:AFFHandlerWithArgs(@selector(SEL:::::…), arg0, arg1, arg2, arg3…)];
``` 

Background threaded handlers:

``` objective-c
[[class $eventName] addHandlerInBackgroundThread:AFFHandler(@selector(SEL))];
[[instance $eventName] addHandlerInBackgroundThread:AFFHandler(@selector(SEL))];
``` 

Background threaded handlers preformed only once:

``` objective-c
[[class $eventName] addHandlerInBackgroundThreadOneTime:AFFHandler(@selector(SEL))];
[[instance $eventName] addHandlerInBackgroundThreadOneTime:AFFHandler(@selector(SEL))];
```

Blocks can also be added as handlers to listen to an event. This is done is slightly different way than using a selector and uses a naming convention to organize the blocks. If you do not wish to ever change a block handler then you can simply pass 'nil' for the block name. Adding a block handler is similar to adding a selector handler.

``` objective-c
[[class $eventName] addBlock:^(AFFEvent *event){ } withName:name];
[[instance $eventName] addBlock:^(AFFEvent *event){ } withName:name];
``` 

One time handlers are handlers that are only called once then destroyed from the event sender:

``` objective-c
[[class $eventName] addBlockOneTime:^(AFFEvent *event){ } withName:name];
[[instance $eventName] addBlockOneTime:^(AFFEvent *event){ } withName:name];
```

Background threaded handlers:

``` objective-c
[[class $eventName] addBlockInBackgroundThread:^(AFFEvent *event){ } withName:name];
[[instance $eventName] addBlockInBackgroundThread:^(AFFEvent *event){ } withName:name];
``` 

Background threaded handlers preformed only once:

``` objective-c
[[class $eventName] addBlockInBackgroundThreadOneTime:^(AFFEvent *event){ } withName:name];
[[instance $eventName] addBlockInBackgroundThreadOneTime:^(AFFEvent *event){ } withName:name];
``` 

###Retrieving data from the event to the handler
Retrieving data from an event is very similar to NSNotification usage. The selector for which an event is going to trigger can have multiple parameters. If the event being sent has no data and doesn't need any sender information, then the selector does not need to have an AFFEvent object parameter.

``` objective-c
- (void)eventHandler {}
``` 

An event where there is data being sent and / or you'd want to know more information about the event can have an AFFEvent object parameter.

``` objective-c
- (void)eventHandler:(AFFEvent *)event {}
``` 

A handler with one or more other parameters must include an AFFEvent object as it's first parameter.

``` objective-c
- (void)eventHandler:(AFFEvent *)event withArg0:(id)arg0 andArg1:(id)arg1 andArg2:(id)arg2 {}
```  

###Event object
The AFFEvent is the object being sent, much like an NSNotification. The event object itself has three accessible properties:

``` objective-c
@property (nonatomic, readonly) id sender;
@property (nonatomic, readonly) id data;
@property (nonatomic, readonly) NSString *eventName;
```

The 'sender' property references the object that sent the event.
The 'data' property is the data being sent by the event.
The 'eventName' property is the name of the event that was sent.

###Example Usage
Here is an example of basic usage of AFFEvents. An event is first created in the header file then synthesized through the implementation file. A handler as a selector is then added to the event. 'myAction' method will, when triggered, send the event with data. This data will be retrieved via the handler attached a the data will be logged out. 

``` objective-c
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
``` 

##Changelog
- August 9, 2013: Released 1.3.1. This is a minor patch which changes the default background thread queue priority for handlers.
- August 6, 2013: Released 1.3.0. This release features small additions to selector and block handlers by allowing execution in a background thread. 
- August 5, 2013: Released 1.2.0. This is a small feature release to extend on block support. 
- August 5, 2013: Confirmed compatibility with MAC OSX 1.06 - 1.08. 
- August 5, 2013: Released version 1.1.0. This release features newly added block support with functionality similar to that of selector handlers as well as bug fixes. 
- August 4, 2013: Added the ability to use blocks instead of selectors when listening to an event. This will allow for more simplicity and flexibility.
- July 31, 2013: Temporarily removed ARC support due to leaks (1.0.1).
- July 30, 2013	: Released 1.0.0. First stable release.
- July 28, 2013	: Added AFFEventAPI locks and unlocks. This will allow for more control over an event's handlers.
- July 25, 2013: Added performance tweaks.
