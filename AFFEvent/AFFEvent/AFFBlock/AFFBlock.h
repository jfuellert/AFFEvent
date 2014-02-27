//
//  AFFBlock.h
//  AF Apps
//
//  Created by Jeremy Fuellert on 2013-08-03.
//  Copyright (c) 2013 AFApps. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "AFFEventStatics.h"

@class AFFEvent;

/** AFFBlock is a class used for handling a block within an AFFEventAPI. */
@interface AFFBlock : NSObject

/** A bitewise mask of block execution characteristics. */
@property (nonatomic, assign) AFFEventType type;

/** A BOOL determining if the block is locked. If |isLocked| is 'YES' then it will not execute it's block. */
@property (nonatomic, assign, setter = setLocked:) BOOL isLocked;

/** An NSString that determines the block name. This is usually related to the event name and method. */
@property (nonatomic, retain) NSString *blockName;

/** The block that belongs to AFFBlock. This will be executed, if enabled, upon an event being fired. */
@property (nonatomic, copy) void(^block)(AFFEvent *event);

@end