//
//  AFFBlock.h
//  AFFEvent
//
//  Created by Jeremy Fuellert on 2013-08-03.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFFBlock : NSObject

@property (nonatomic, assign) BOOL isLocked;
@property (nonatomic, assign) BOOL isOneTimeBlock;
@property (nonatomic, retain) NSString *blockName;
@property (nonatomic, copy) void(^block)(void);

@end
