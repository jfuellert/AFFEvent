//
//  Benchmark.m
//  NekoLogic
//
//  Created by Cory on 10/07/29.
//  Copyright 2010 Cory R. Leach. All rights reserved.
//

#import "Benchmark.h"

static Benchmark* sharedInstance = nil;

@implementation Benchmark

- (id) init {
    
	if ( (self = [super init] ) ) {
        
		dateBenchmarks = [[NSMutableDictionary alloc] init];
		machBenchmarks = [[NSMutableDictionary alloc] init];
		dateRecords = [[NSMutableDictionary alloc] init];
		machRecords = [[NSMutableDictionary alloc] init];
        
	}
    
	return self;
    
}

- (void)startWithKey:(NSObject*)key {
    
#ifdef BENCHMARK_LOG_START
	NSLog(@"Start %@",key);
#endif
    
	NSDate* start = [NSDate date];
	[dateBenchmarks setObject:start forKey:key];
    
}

- (NSTimeInterval)finishWithKey:(NSObject*)key {
    
	NSDate* end = [NSDate date];
	NSDate* start = [dateBenchmarks objectForKey:key];
    
	if ( start == nil ) {
		NSLog(@"No Benchmark Exists for Key %@!",key);
		return 0;
	}
    
	NSTimeInterval time = [end timeIntervalSinceDate:start];
    
#ifdef BENCHMARK_LOG_FINISH
	NSLog(@"Finish %@: %f",key,time);
#endif
    
#ifdef BENCHMARK_CLEAR_KEY_ON_FINISH
	[dateBenchmarks removeObjectForKey:key];
#endif
    
	//Record For Averaging
	[self addDateRecord:time forKey:key];
    
	return time;
    
}

- (NSTimeInterval)averageWithKey:(NSObject*)key {
    
	NSMutableArray* array = [dateRecords objectForKey:key];
    
	if ( array == nil ) {
		return 0;
	}
    
	NSTimeInterval average = 0;
	NSUInteger index = 1;
    
	//Computer Average Incrementally
	for ( NSNumber* number in array ) {
		average = average + (([number doubleValue] - average)/index);
		index++;
	}
    
#ifdef BENCHMARK_LOG_AVERAGE
	NSLog(@"Average %@: %f",key,average);
#endif
    
	return average;
    
}

- (void)startMachWithKey:(NSString*)key {
    
	uint64_t* start;
	NSData* data = [machBenchmarks objectForKey:key];
    
	if ( data == nil ) {
		start = malloc(sizeof(uint64_t));
		data = [[NSData alloc] initWithBytesNoCopy:start length:sizeof(uint64_t) freeWhenDone:YES];
		[machBenchmarks setObject:data forKey:key];
	} else {
		start = (uint64_t*)[data bytes];
	}
    
#ifdef BENCHMARK_LOG_START
	NSLog(@"Start %@",key);
#endif
    
	*start = mach_absolute_time();
    
}

- (uint64_t)finishMachWithKey:(NSString*)key {
    
	uint64_t end = mach_absolute_time();
	uint64_t start;
	uint64_t elapsed;
	NSData* data = [machBenchmarks objectForKey:key];
    
	if ( data == nil ) {
		NSLog(@"No Benchmark Exists for Key %@!",key);
		return 0;
	}
    
	start = *((uint64_t*)[data bytes]);
	elapsed = end - start;
    
#ifdef BENCHMARK_LOG_FINISH
	NSLog(@"Finish %@: %qu",key,elapsed);
#endif
    
#ifdef BENCHMARK_CLEAR_KEY_ON_FINISH
	[machBenchmarks removeObjectForKey:key];
#endif
    
	//Auto Record
	[self addMachRecord:elapsed forKey:key];
    
	return elapsed;
}

- (uint64_t)averageMachWithKey:(NSObject *)key {
    
	NSMutableArray* array = [machRecords objectForKey:key];
    
	if ( array == nil ) {
		NSLog(@"No Array For Key: %@",key);
		return 0;
	}
    
	uint64_t average = 0;
	NSUInteger index = 1;
	//Computer Average Incrementally
	for ( NSNumber* number in array ) {
        
		uint64_t n = [number unsignedLongLongValue];
        
		if ( average > n ) {
			//Change Algorithm to prevent Overflow
			average = average - ((average - n)/index);
		} else {
			average = average + ((n - average)/index);
		}
        
		index++;
        
	}
    
#ifdef BENCHMARK_LOG_AVERAGE
	NSLog(@"Average %@: %qu",key,average);
#endif
    
	return average;
    
}

- (void) addDateRecord:(NSTimeInterval)time forKey:(NSObject*)key {
    
	NSMutableArray* array = [dateRecords objectForKey:key];
    
	if ( array == nil ) {
		array = [[NSMutableArray alloc] init];
		[dateRecords setObject:array forKey:key];
		[array release];
	}
    
	[array addObject:[NSNumber numberWithDouble:time]];
    
}

- (void) addMachRecord:(uint64_t)value forKey:(NSObject*)key {
    
	NSMutableArray* array = [machRecords objectForKey:key];
    
	if ( array == nil ) {
		array = [[NSMutableArray alloc] init];
		[machRecords setObject:array forKey:key];
		[array release];
	}
    
	[array addObject:[NSNumber numberWithUnsignedLongLong:value]];
    
}

+ (uint64_t) machTimeToNanoseconds:(uint64_t)machTime {
    
	static mach_timebase_info_data_t sTimebaseInfo;
    
	if ( sTimebaseInfo.denom == 0 ) {
        (void) mach_timebase_info(&sTimebaseInfo);
    }
    
	uint64_t elapsedNano = machTime * sTimebaseInfo.numer / sTimebaseInfo.denom;
    
	return elapsedNano;
    
}

+ (void)start:(NSObject*)key {
	[[Benchmark sharedInstance]  startWithKey:key];
}

+ (uint64_t)finish:(NSObject*)key {
	return [[Benchmark sharedInstance] finishWithKey:key];
}

+ (void)startMach:(NSObject*)key {
	[[Benchmark sharedInstance]  startMachWithKey:key];
}

+ (uint64_t)finishMach:(NSObject*)key {
	return [[Benchmark sharedInstance] finishMachWithKey:key];
}

+ (uint64_t)finishMach:(NSObject*)key inNanoseconds:(BOOL)nano {
    
	if ( nano ) {
		uint64_t time = [sharedInstance finishMachWithKey:key];
		return [Benchmark machTimeToNanoseconds:time];
	} else {
		return [[Benchmark sharedInstance] finishMachWithKey:key];
	}
    
}

+ (NSTimeInterval)average:(NSObject*)key {
	return [[Benchmark sharedInstance] averageWithKey:key];
}

+ (uint64_t)averageMach:(NSObject*)key {
	return [[Benchmark sharedInstance] averageMachWithKey:key];
}

#pragma mark Singleton methods

+ (Benchmark*) sharedInstance {
    
    @synchronized(self) {
		if (sharedInstance == nil) {
			sharedInstance = [[Benchmark alloc] init];
		}
    }
    return sharedInstance;
}

+ (id) allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedInstance == nil) {
			sharedInstance = [super allocWithZone:zone];
			return sharedInstance;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (id) copyWithZone:(NSZone *)zone {
    return self;
}

- (id) retain {
    return self;
}

- (unsigned) retainCount {
    return UINT_MAX;  // denotes an object that cannot be released
}

- (void) release {
    //do nothing
}

- (id) autorelease {
    return self;
}

@end