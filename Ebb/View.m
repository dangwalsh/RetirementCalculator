//
//  View.m
//  Ebb
//
//  Created by Daniel Walsh on 5/28/12.
//  Copyright (c) 2012 Walsh walsh Studio. All rights reserved.
//

#import "View.h"
#import "ViewController.h"
#import "Model.h"


/*
 Each cell of the graph paper has two lines at a right angle:
 
 |
 |
 |
 +-------------
 */

//Dimensions of each cell.  The cell will be scaled (magnified) by the
//same factor as the main drawing, so we have to make the lines very thin.

const CGFloat hSize = 1;//M_PI / 4; //horizontal: 1/2 the length of 1 hump of sine curve
const CGFloat vSize = 1;        //vertical: height of hump

static void drawCell(void *p, CGContextRef c)
{
	CGFloat scale = *(CGFloat *)p;
	CGContextSetLineWidth(c, 1 / scale);
	CGContextBeginPath(c);
    
	CGContextMoveToPoint(c, 0, 0);	//origin at lower left of cell
	CGContextAddLineToPoint(c, hSize, 0);	//horizontal line
    
	CGContextMoveToPoint(c, 0, 0);
	CGContextAddLineToPoint(c, 0, vSize);	//vertical line
    
	CGContextStrokePath(c);
}

@implementation View

/*
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
*/

- (id)initWithFrame:(CGRect) frame
         controller: (ViewController *) c
              model: (Model *) m 
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        model = m;
    }
    return self;    
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGSize s = self.bounds.size;
    
    arrays = [model outputDetailValuesToPlot];
    NSArray *sepBalA = [arrays objectAtIndex:10];
    
    float labelSize = 12.0;
    float titleSize = 32.0;
    float maxVal = 0.0;
    float minVal = 999999.0;
    float year = 0.0;
    
    UIFont *fontLabel = [UIFont systemFontOfSize:labelSize];
    UIFont *fontTitle = [UIFont systemFontOfSize:titleSize];
    
    NSNumberFormatter *formatCur = [[NSNumberFormatter alloc] init];
    [formatCur setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    for (NSNumber *val in sepBalA) {
        if ([val floatValue] > maxVal) {
            maxVal = [val floatValue];
        }
        if ( [val floatValue] < minVal) {
            minVal = [val floatValue];            
        }
    }
    
    float m = 150;
    float tickSize = 5;
    float numGrid = 10;
    CGRect g = CGRectMake(
                          0, 
                          0, 
                          s.width-(2*m), 
                          s.height-(2*m)
                          );


    //yaxis calcs
    float ySpace = (s.height - (2 * m));
    float yDomain = maxVal - minVal;
    float yGrid = ySpace / numGrid;
    float yLabel = minVal;
    
    //xaxis calcs
    float xSpace = (s.width - (2 * m));
    float xDomain = (model.lifeExpectancy - model.currentAge); 
    float xGrid = xSpace / numGrid;   
    float xPoint = xSpace / xDomain;
    //float xValInc = xDomain / (numGrid);
    int xLabel = model.currentAge;
    
    
    //CGFloat width = xGrid;//4 * M_PI;
    CGFloat scale = xGrid;//s.width / width;
    CGFloat ratio = yGrid / xGrid;
    CGFloat yScale = scale * ratio;
    CGAffineTransform translate = 
        CGAffineTransformMakeTranslation(
                                         s.width / 2,
                                         s.height / 2
                                         );

    CGContextTranslateCTM(
                          c, 
                          s.width - (s.width - m), 
                          s.height - m
                          );
    CGContextScaleCTM(c, 1, -1);
   
        
    //y axis
    CGContextBeginPath(c);
    CGContextMoveToPoint(c, 0, 0);    
    CGContextAddLineToPoint(c, 0, ySpace);
    static const CGFloat colorAxis[] = {0, 0, 0, 0.75};	//rgb alpha
    CGContextSetStrokeColor(c, colorAxis);
    CGContextStrokePath(c);
    
    
    //y axis label
    float inc = 0.0;
    for (int i = 0; i < numGrid; ++i) {
        
        CGContextBeginPath(c);
        CGContextMoveToPoint(c, 0, inc);        
        CGContextAddLineToPoint(c, -tickSize, inc);        
        CGContextStrokePath(c);        
        
        NSString *string = [formatCur stringFromNumber:[NSNumber numberWithFloat:yLabel]];
        CGPoint point = CGPointMake(- (m - m * .2), - inc - labelSize);
        
        CGContextScaleCTM(c, 1, -1);
        [string drawAtPoint:point withFont:fontLabel];
        CGContextScaleCTM(c, 1, -1);
        
        yLabel = yLabel + (yDomain / numGrid);
        inc = inc + yGrid;
    }
    
    //x axis
    CGContextBeginPath(c);
    CGContextMoveToPoint(c, 0, 0);    
    CGContextAddLineToPoint(c, xSpace, 0);
    CGContextSetStrokeColor(c, colorAxis);
    CGContextStrokePath(c);
    
    //x axis label
    inc = 0.0;
    for (int i = 0; i < numGrid; ++i) {
        
        CGContextBeginPath(c);
        CGContextMoveToPoint(c, inc, 0);        
        CGContextAddLineToPoint(c, inc, -tickSize);        
        CGContextStrokePath(c);  
        
        NSString *string = [[NSNumber numberWithInt:xLabel] stringValue];
        CGPoint point = CGPointMake(inc, (m - m * .8));
        
        CGContextScaleCTM(c, 1, -1);
        [string drawAtPoint:point withFont:fontLabel];
        CGContextScaleCTM(c, 1, -1);
        
        xLabel = xLabel + (xDomain / numGrid);
        inc = inc + xGrid;
    }
    
    //plot
    CGContextBeginPath(c);
    CGContextMoveToPoint(c, 0, 0);
    
    for (int i = 0; i < xDomain; ++i) {
        float value = [[sepBalA objectAtIndex:i] floatValue];    
        
        if (minVal < 0) {
            value = fabsf(minVal) + value;
            maxVal = fabsf(minVal) + maxVal;
        }

        float yPoint = value/maxVal * ySpace;
        CGContextAddLineToPoint(c, year, yPoint);
        year = year + xPoint;
    }
    
    CGSize size = CGSizeMake(1,1);
    CGContextSetStrokeColorWithColor(c, [UIColor redColor].CGColor);
    CGContextSetLineWidth(c, 3);
    CGContextSetShadow(c, size, 5);
    CGContextStrokePath(c);
    
     
     //Pattern cell origin in lower left corner, Y axis points up.
     CGAffineTransform patternScale = CGAffineTransformMakeScale(scale,  yScale);
     
     CGAffineTransform patternTransform =
     CGAffineTransformConcat(patternScale, translate);
     
     //Graph paper, faint blue in background.
     
     //Tell it that our colors are RGB, not CYMK or grayscale.
     CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
     CGColorSpaceRef patternSpace = CGColorSpaceCreatePattern(baseSpace);
     CGContextSetFillColorSpace(c, patternSpace);
     CGColorSpaceRelease(patternSpace);
     CGColorSpaceRelease(baseSpace);
     
     static const CGPatternCallbacks callbacks = {0, drawCell, NULL};
     
     CGPatternRef pattern = CGPatternCreate(
     &scale,		//argument passed to drawCell
     CGRectMake(0, 0, hSize, vSize),
     patternTransform,
     hSize, vSize,	//distance between cells: none at all
     kCGPatternTilingConstantSpacing,
     false,	//Graph paper is monochromatic (a "stencil" pattern).
     &callbacks
     );
     
     static const CGFloat colorGrid[] = {0, 0, 0, 0.15};	//rgb alpha
     CGContextSetFillPattern(c, pattern, colorGrid);
     CGPatternRelease(pattern);
     CGContextFillRect(c, g);
     
}


@end
