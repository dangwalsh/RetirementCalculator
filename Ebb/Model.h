//
//  Model.h
//  Ebb
//
//  Created by Daniel Walsh on 5/19/12.
//  Copyright (c) 2012 Walsh walsh Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject {
    NSArray *inputHeaders;
    NSArray *inputLabels;
    NSMutableArray *inputDetails;
    
    NSArray *outputHeaders;
    NSArray *outputLabels;
    NSMutableArray *outputDetails;
}

- (NSUInteger) numberOfInputSections;
- (NSUInteger) numberOfInputRowsPerSection: (NSInteger) section;
- (NSString *) inputHeaderNames: (NSInteger) section;
- (NSArray *) inputLabelNames: (NSIndexPath *) indexPath;
- (NSArray *) inputDetailValues: (NSIndexPath *) indexPath;

- (NSMutableArray *) updateDetailValues: (NSIndexPath *) indexPath;

- (NSUInteger) numberOfOutputSections;
- (NSUInteger) numberOfOutputRowsPerSection: (NSInteger) section;
- (NSString *) outputHeaderNames: (NSInteger) section;//not used yet
- (NSArray *) outputLabelNames: (NSIndexPath *) indexPath;
- (NSArray *) outputDetailValues: (NSIndexPath *) indexPath;

- (void) calculateOutputDetails;

- (NSArray *) outputDetailValuesToPlot;

//- (NSUInteger) numberOfRowsInResults: (NSInteger) section;
//- (NSString *) text: (NSIndexPath *) indexPath row: (NSUInteger) row;

@property (nonatomic, assign) float currentAge;
@property (nonatomic, assign) float lifeExpectancy;
@property (nonatomic, assign) int resultsAge;

@end
