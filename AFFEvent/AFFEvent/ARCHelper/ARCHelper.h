//
//  ARC Helper
//
//  Version 2.2
//
//  Created by Nick Lockwood on 05/01/2012.
//  Copyright 2012 Charcoal Design
//
//  Distributed under the permissive zlib license
//  Get the latest version from here:
//
//  https://gist.github.com/1563325
//

#import <Availability.h>
#undef ah_retain
#undef ah_dealloc
#if __has_feature(objc_arc)
#define ah_retain self
#define ah_release self
#define ah_autorelease self
#define ah_dealloc self
#else
#define ah_retain retain
#define ah_release release
#define ah_autorelease autorelease
#define ah_dealloc dealloc
#undef __bridge
#define __bridge
#undef __bridge_transfer
#define __bridge_transfer
#endif

//  ARC Helper ends