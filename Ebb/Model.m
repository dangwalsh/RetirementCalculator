//
//  Model.m
//  Ebb
//
//  Created by Daniel Walsh on 5/19/12.
//  Copyright (c) 2012 Walsh walsh Studio. All rights reserved.
//

#import "Model.h"


@implementation Model

@synthesize currentAge;
@synthesize lifeExpectancy;
@synthesize resultsAge;

- (id) init {
    self = [super init];
    if (self) {

        inputHeaders = [NSArray arrayWithObjects:
                        @"Personal Information",
                        @"Assets - Savings",
                        @"Assets - SEP",
                        @"Assets - IRA/401k",
                        @"Assets - Taxable Invest",
                        @"Inflation",
                        nil
                        ];
        
        inputLabels = [NSArray arrayWithObjects:
                      
                      //Personal Information
                      [NSArray arrayWithObjects:
                       @"Age",
                       @"Annual Expenses",
                       @"Early Retire Age",
                       @"Full Retire Age",
                       @"Early Retire Income",
                       @"Retire Inc/Soc Sec",
                       nil
                       ],
                      
                      //Assets - Savings
                      [NSArray arrayWithObjects:
                       @"Account Balance",
                       @"Annual Return",
                       @"Annual Contribution",
                       nil
                       ],
                      
                      //Assets - SEP
                      [NSArray arrayWithObjects:
                       @"Account Balance",
                       @"Annual Rtn - Pre",
                       @"Annual Rtn - Early",
                       @"Annual Rtn - Retire",
                       @"Annual Contribution",
                       nil
                       ],
                      
                      //Assets - IRA/401k
                      [NSArray arrayWithObjects:
                       @"Account Balance",
                       @"Annual Return",
                       @"Annual Contribution",
                       nil
                       ],
                      
                      //Assets - Taxable Investments
                      [NSArray arrayWithObjects:
                       @"Account Balance",
                       @"Annual Ret - Pre",
                       @"Annual Ret - Early",
                       @"Annual Ret - Retire",
                       @"Annual Contribution",
                       @"Tax Rate", 
                       nil
                       ],
                      
                      //Inflation
                      [NSArray arrayWithObjects:
                       @"Inflation",
                       nil
                       ],
                      
                      nil
                      ];
        
        inputDetails = [NSMutableArray arrayWithObjects:
                      
                      //Personal Information
                      [NSMutableArray arrayWithObjects:
                       [NSNumber numberWithFloat:38],
                       [NSNumber numberWithFloat:100000],
                       [NSNumber numberWithFloat:50],
                       [NSNumber numberWithFloat:65],
                       [NSNumber numberWithFloat:0],
                       [NSNumber numberWithFloat:24000],
                       nil
                       ],
                      
                      //Assets - Savings
                      [NSMutableArray arrayWithObjects:
                       [NSNumber numberWithFloat:175000],
                       [NSNumber numberWithFloat:0.0025],
                       [NSNumber numberWithFloat:0],
                       nil
                       ],
                      
                      //Assets - SEP
                      [NSMutableArray arrayWithObjects:
                       [NSNumber numberWithFloat:52000],
                       [NSNumber numberWithFloat:0.12],
                       [NSNumber numberWithFloat:0.10],
                       [NSNumber numberWithFloat:0.08],
                       [NSNumber numberWithFloat:10000],
                       nil
                       ],
                      
                      //Assets - IRA/401k
                      [NSMutableArray arrayWithObjects:
                       [NSNumber numberWithFloat:18000],
                       [NSNumber numberWithFloat:0.06],
                       [NSNumber numberWithFloat:0],
                       nil
                       ],
                      
                      //Assets - Taxable Investments
                      [NSMutableArray arrayWithObjects:
                       [NSNumber numberWithFloat:125000],
                       [NSNumber numberWithFloat:0.50],
                       [NSNumber numberWithFloat:0.15],
                       [NSNumber numberWithFloat:0.10],
                       [NSNumber numberWithFloat:24000],
                       [NSNumber numberWithFloat:0.35], 
                       nil
                       ],
                      
                      //Inflation
                      [NSMutableArray arrayWithObjects:
                       [NSNumber numberWithFloat:0.03],
                       nil
                       ],
                      
                      nil
                      ];
        
        outputHeaders = [NSArray arrayWithObjects:
                         @"Results", 
                         nil
                         ];
        
        outputLabels = [NSArray arrayWithObjects:

                        //labels for results
                        [NSArray arrayWithObjects:
                         @"Age Adjustment",
                         @"Required Income",
                         @"Income",
                         @"Savings",
                         @"Retirement A",
                         @"Retirement B",
                         @"Taxable Invest",
                         @"Retired?",
                         @"Taxable Invest DD",
                         @"Retirement A DD",
                         @"Total Assets",
                         @"NW Change",
                         @"NW Change %",
                         nil
                         ],
                   
                        nil
                        ];
        
        outputDetails = [NSMutableArray arrayWithObjects:

                   //starting values to fill the array
                   [NSMutableArray arrayWithObjects:
                    [NSNumber numberWithFloat:0],
                    [NSNumber numberWithFloat:0],
                    [NSNumber numberWithFloat:0],
                    [NSNumber numberWithFloat:0],
                    [NSNumber numberWithFloat:0],
                    [NSNumber numberWithFloat:0],
                    [NSNumber numberWithFloat:0],
                    @"NO",
                    [NSNumber numberWithFloat:0],
                    [NSNumber numberWithFloat:0],
                    [NSNumber numberWithFloat:0],
                    [NSNumber numberWithFloat:0],
                    [NSNumber numberWithFloat:0],
                    nil                    
                    ],
                  
                   nil
                   ];
                   
    }
    return self;
}

//methods for user input view

- (NSUInteger) numberOfInputSections {
    return inputLabels.count;
}

- (NSUInteger) numberOfInputRowsPerSection: (NSInteger) section
{
    NSArray *inGroup = [inputLabels objectAtIndex: section];
    return inGroup.count;
}

- (NSString *) inputHeaderNames: (NSInteger) section {
    return [inputHeaders objectAtIndex:section];
}

- (NSArray *) inputLabelNames: (NSIndexPath *) indexPath {
    return [inputLabels objectAtIndex: indexPath.section];
}

- (NSArray *) inputDetailValues: (NSIndexPath *) indexPath {
    return [inputDetails objectAtIndex: indexPath.section];
}

//methods for edit view

- (NSMutableArray *) updateDetailValues: (NSIndexPath *) indexPath {
    return [inputDetails objectAtIndex: indexPath.section];
}

//methods for output calculations view

- (NSUInteger) numberOfOutputSections{
    return outputLabels.count;
}

- (NSUInteger) numberOfOutputRowsPerSection: (NSInteger) section
{
    NSArray *outGroup = [outputLabels objectAtIndex: section];
    return outGroup.count;
}

- (NSString *) outputHeaderNames: (NSInteger) section {
    return [outputHeaders objectAtIndex:section];
}

- (NSArray *) outputLabelNames: (NSIndexPath *) indexPath {
    return [outputLabels objectAtIndex: indexPath.section];
}

- (NSArray *) outputDetailValues: (NSIndexPath *) indexPath {
    return [outputDetails objectAtIndex: indexPath.section];
}

/*
- (NSString *) text: (NSIndexPath *) indexPath row: (NSUInteger) row
{
	indexPath = [indexPath indexPathByAddingIndex: row];
    return [inputLabels objectAtIndex: row];
}
*/

/*
- (NSUInteger) numberOfRowsInResults: (NSInteger) section {
    NSArray *outGroup = [outputDetails objectAtIndex: section];
    return outGroup.count;
}
*/


- (void) calculateOutputDetails {
    
    //declare constants
    self.lifeExpectancy = 100;
    
    //pullout user data arrays
    NSArray *information = [inputDetails objectAtIndex: 0];
    NSArray *savings = [inputDetails objectAtIndex: 1];
    NSArray *sep = [inputDetails objectAtIndex: 2];
    NSArray *fourK = [inputDetails objectAtIndex: 3];
    NSArray *taxable = [inputDetails objectAtIndex: 4];
    NSArray *inflationA = [inputDetails objectAtIndex: 5];
    
    //pullout user parameters from arrays
    self.currentAge = [[information objectAtIndex: 0] floatValue];
    float requiredIncome = [[information objectAtIndex: 1] floatValue];
    int earlyRetirement = [[information objectAtIndex: 2] intValue];
    int fullRetirement = [[information objectAtIndex: 3] intValue];
    float earlyIncome = [[information objectAtIndex: 4] floatValue];
    float retirementIncome = [[information objectAtIndex: 5] floatValue];
    
    float savingsBal = [[savings objectAtIndex: 0] floatValue];
    float savingsRet = [[savings objectAtIndex: 1] floatValue];
    float savingsCon = [[savings objectAtIndex: 2] floatValue];
    
    float sepBal = [[sep objectAtIndex: 0] floatValue];
    float sepRetPre = [[sep objectAtIndex: 1] floatValue];
    float sepRetSemi = [[sep objectAtIndex: 2] floatValue];
    float sepRetFull = [[sep objectAtIndex: 3] floatValue];
    float sepCon = [[sep objectAtIndex: 4] floatValue];

    float taxableBal = [[taxable objectAtIndex: 0] floatValue];
    float taxableRetPre = [[taxable objectAtIndex: 1] floatValue];
    float taxableRetSemi = [[taxable objectAtIndex: 2] floatValue];
    float taxableRetFull = [[taxable objectAtIndex: 3] floatValue];
    float taxableCon = [[taxable objectAtIndex: 4] floatValue];
    float taxableRate = [[taxable objectAtIndex: 5] floatValue];
    
    float fourKBal = [[fourK objectAtIndex: 0] floatValue];
    float fourKRet = [[fourK objectAtIndex: 1] floatValue];
    float fourKCon = [[fourK objectAtIndex: 2] floatValue];
    
    float inflation = [[inflationA objectAtIndex: 0] floatValue];
    
    //non-time-dependent calculations
    int time  = lifeExpectancy - currentAge;
    
    //initialize other variables
    float income = 0.0;
    float taxableInvDd = 0.0;
    float retirementDd = 0.0;
    
    NSString *retired = @"";
    
    NSMutableArray *totalAssetsA = [NSMutableArray arrayWithCapacity: time];
    NSMutableArray *nwDeltaA = [NSMutableArray arrayWithCapacity: time];
    NSMutableArray *nwPercA = [NSMutableArray arrayWithCapacity: time];
    
    //new arrays
    NSMutableArray *earlytIncomeA = [NSMutableArray arrayWithCapacity:time];
    NSMutableArray *retirementIncomeA = [NSMutableArray arrayWithCapacity:time];
    NSMutableArray *requiredIncomeA = [NSMutableArray arrayWithCapacity:time];    
    NSMutableArray *incomeA = [NSMutableArray arrayWithCapacity:time];    
    NSMutableArray *taxableInvDdA = [NSMutableArray arrayWithCapacity:time];    
    NSMutableArray *taxableBalA = [NSMutableArray arrayWithCapacity:time];    
    NSMutableArray *retirementDdA = [NSMutableArray arrayWithCapacity:time];
    NSMutableArray *savingsBalA = [NSMutableArray arrayWithCapacity:time];
    NSMutableArray *sepBalA = [NSMutableArray arrayWithCapacity:time];
    NSMutableArray *fourKBalA = [NSMutableArray arrayWithCapacity:time];
    NSMutableArray *retiredA = [NSMutableArray arrayWithCapacity:time];
    
    //increment the current age to skip the current year
    ++currentAge;
    
    //time-dependent calculations
    for (int i = 0; i < time; ++i) {
        
        //adjust the counter start point
        int age = i + currentAge;
        
        //inflate constants first
        earlyIncome += earlyIncome * inflation;
        retirementIncome += retirementIncome * inflation;
        requiredIncome += requiredIncome * inflation;
        
        [earlytIncomeA addObject:[NSNumber numberWithFloat:earlyIncome]];
        [retirementIncomeA addObject:[NSNumber numberWithFloat:retirementIncome]];
        [requiredIncomeA addObject:[NSNumber numberWithFloat:requiredIncome]];

        
        //determine income
        if (age < earlyRetirement) {
            income = 0;
        } else if (age < fullRetirement) {
            income = earlyIncome;
        } else {
            income = retirementIncome;
        }
        
        [incomeA addObject:[NSNumber numberWithFloat:income]];

        //determine taxable investment drawdown
        if (age < earlyRetirement) {
            taxableInvDd = 0;
        } else {
            taxableInvDd = requiredIncome - income;
        }
        
        [taxableInvDdA addObject:[NSNumber numberWithFloat:taxableInvDd]];
        
        //determine taxable investment value
        if (age < earlyRetirement) {
            taxableBal += (1 - taxableRate) * (taxableBal * taxableRetPre) + taxableCon;
        } else if (age < fullRetirement) {
            taxableBal += (1 - taxableRate) * (taxableBal * taxableRetSemi) - taxableInvDd;
        } else {
            taxableBal += (1 - taxableRate) * (taxableBal * taxableRetFull) - taxableInvDd;
        }
        
        [taxableBalA addObject:[NSNumber numberWithFloat:taxableBal]];

        //determine retirement drawdown
        if (age < earlyRetirement || taxableBal > 0) {
            retirementDd = 0;
        } else {
            retirementDd = requiredIncome - income;
        }
        
        [retirementDdA addObject:[NSNumber numberWithFloat:retirementDd]];
        
        //determine savings value
        if (age < earlyRetirement) {
            savingsBal += savingsBal * savingsRet + savingsCon;
        } else {
            savingsBal += savingsBal * savingsRet;
        }
        
        [savingsBalA addObject:[NSNumber numberWithFloat:savingsBal]];
        
        //determine SEP value
        if (age < earlyRetirement) {
            sepBal += sepBal * sepRetPre + sepCon;
        } else if (age < fullRetirement) {
            sepBal += sepBal * sepRetSemi - retirementDd;
        } else {
            sepBal += sepBal *sepRetFull - retirementDd;
        }
        
        [sepBalA addObject:[NSNumber numberWithFloat:sepBal]];
        
        //determine 401k value
        if (age < earlyRetirement) {
            fourKBal += fourKBal * fourKRet + fourKCon;
        } else {
            fourKBal += fourKBal * fourKRet;
        }
        
        [fourKBalA addObject:[NSNumber numberWithFloat:fourKBal]];
        
        //determine if retired
        if (age < earlyRetirement) {
            retired = @"NO";
        } else if (age < fullRetirement) {
            retired = @"SEMI";
        } else {
            retired = @"YES";
        }
        
        [retiredA addObject: retired];

        //determine total assets
        float total = savingsBal + sepBal + fourKBal + taxableBal;
        
        [totalAssetsA addObject: [NSNumber numberWithFloat: total]];
        
        //determine net worth delta
        if (i > 0) {
            float ta = [[totalAssetsA objectAtIndex: i] floatValue];
            float pta = [[totalAssetsA objectAtIndex: (i-1)] floatValue];
            [nwDeltaA addObject: [NSNumber numberWithFloat:(ta - pta)]];
            
            float nwd = ta - pta;
            [nwPercA addObject: [NSNumber numberWithFloat:(nwd / pta)]];
            
        }
        
    }
    //add code to put values back into NSMutablArray results
    //could make this into a for loop if field names were added to an enum
    NSMutableArray *r = [outputDetails objectAtIndex: 0];

    [r replaceObjectAtIndex:1 withObject:requiredIncomeA];
    [r replaceObjectAtIndex:2 withObject:incomeA];
    [r replaceObjectAtIndex:3 withObject:savingsBalA];
    [r replaceObjectAtIndex:4 withObject:sepBalA];
    [r replaceObjectAtIndex:5 withObject:fourKBalA];
    [r replaceObjectAtIndex:6 withObject:taxableBalA];
    
    [r replaceObjectAtIndex:7 withObject: retiredA];
    [r replaceObjectAtIndex:8 withObject:taxableInvDdA];
    [r replaceObjectAtIndex:9 withObject:retirementDdA];

    [r replaceObjectAtIndex:10 withObject:totalAssetsA];
    [r replaceObjectAtIndex:11 withObject:nwDeltaA];
    [r replaceObjectAtIndex:12 withObject:nwPercA];


    NSLog(@"Array Size: %d",r.count);
    [outputDetails replaceObjectAtIndex:0 withObject: r];
}

- (NSArray *) outputDetailValuesToPlot{
    return [outputDetails objectAtIndex: 0];
}

@end
