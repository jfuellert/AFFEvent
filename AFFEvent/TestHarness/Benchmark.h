//
//  Benchmark.h
//  NekoLogic
//
//  Created by Cory on 10/07/29.
//  Copyright 2010 Cory R. Leach. All rights reserved.
//
//	Objective-C Code Timing Functions.
//	(Although a pure C implementation would be better, this is just meant to be a simple
//	quick and easy solution, and therefore may not be appropriate for all cases.)
//
//	Benchmark code can significantly slow down time critical functions,
//  and should be used only to calculate the average time it takes a
//  block of code to excecute, and then should be removed from any
//  release version of the software.
//
//	It is best to use the Benchmark Macros defined below, because they
//  can easily be 'compiled out' of the code by removing the BENCHMARK_ON define
//
//  There are two kinds of benchmarks: Normal and Mach
//  normal benchmarks results are calculated in seconds
//  mach benchmark results are calculated in cpu cycles
//
//
//  Normal Macros (Seconds)
//  =============
//  BENCHMARK_START( key )
//  BENCHMARK_FINISH( key )
//  BENCHMARK_REPORT_AVERAGE( key )
//
//  Mach Macros (CPU Cycles)
//  ===========
//  BENCHMARK_START_MACH( key )
//  BENCHMARK_FINISH_MACH( key )
//  BENCHMARK_REPORT_MACH_AVERAGE( key )
//  * mach benchmark results can be converted to nanoseconds using machTimeToNanoseconds:
//	* 'key' is used as the key to a NSDictionary
//  * average macros will find the average value of multiple benchmarks with the same key

#import <mach/mach.h>
#import <mach/mach_time.h>
#import <unistd.h>
#import <Foundation/Foundation.h>

//FLAG
#define BENCHMARK_ON //Comment out to easily remove benchmark code

//Log to console flags
//#define BENCHMARK_LOG_START //Log start of a benchmark to console
//#define BENCHMARK_LOG_FINISH //Log finish of a benchmark to console
#define BENCHMARK_LOG_AVERAGE //Log average of a benchmark to console

//Uncomment to remove data for benchmark key when finish is called
//This should probably be left defined unless you really know what you're doing
#define BENCHMARK_CLEAR_KEY_ON_FINISH

#ifdef TARGET_OS_IPHONE
//iOS Devices
#import <MobileCoreServices/MobileCoreServices.h>
#else
//OSX
#import <CoreServices/CoreServices.h>
#endif

//BENCHMARK MACROS
#ifdef BENCHMARK_ON

#define BENCHMARK_START( key ) [Benchmark start: key ];
#define BENCHMARK_FINISH( key ) [Benchmark finish: key ];
#define BENCHMARK_REPORT_AVERAGE( key ) [Benchmark average: key ];

#define BENCHMARK_START_MACH( key ) [Benchmark startMach: key ];
#define BENCHMARK_FINISH_MACH( key ) [Benchmark finishMach: key ];
#define BENCHMARK_REPORT_MACH_AVERAGE( key ) [Benchmark averageMach: key ];

#else

//Define The Functions as Nothing if BENCHMARK_ON is not defined
#define BENCHMARK_START( key )
#define BENCHMARK_FINISH( key )
#define BENCHMARK_REPORT_AVERAGE( key )

#define BENCHMARK_START_MACH( key )
#define BENCHMARK_FINISH_MACH( key )
#define BENCHMARK_REPORT_MACH_AVERAGE( key )

#endif

@interface Benchmark : NSObject {
    
	NSMutableDictionary* dateBenchmarks;
	NSMutableDictionary* machBenchmarks;
	NSMutableDictionary* machRecords;
	NSMutableDictionary* dateRecords;
    
}

//Convinience Functions
+ (void)start:(NSObject*)key;
+ (uint64_t)finish:(NSObject*)key;
+ (void)startMach:(NSObject*)key;
+ (uint64_t)finishMach:(NSObject*)key;

+ (uint64_t)averageMach:(NSObject*)key;
+ (NSTimeInterval)average:(NSObject*)key;

//Benchmarks in Seconds
- (void)startWithKey:(NSObject*)key;
- (NSTimeInterval)finishWithKey:(NSObject*)key;
- (NSTimeInterval)averageWithKey:(NSObject*)key;

//Benchmarks in CPU time
- (void)startMachWithKey:(NSObject*)key;
- (uint64_t)finishMachWithKey:(NSObject*)key;
- (uint64_t)averageMachWithKey:(NSObject *)key;

//Used for calculating averages (Values are added automatically on a call to a finish function)
- (void) addDateRecord:(NSTimeInterval)time forKey:(NSObject*)key;
- (void) addMachRecord:(uint64_t)value forKey:(NSObject*)key;

//
+ (Benchmark*)sharedInstance;
+ (uint64_t) machTimeToNanoseconds:(uint64_t)machTime;

@end
