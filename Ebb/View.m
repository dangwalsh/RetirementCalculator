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

const CGFloat hSize = 1;        //horizontal
const CGFloat vSize = 1;        //vertical

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
        
        isTouching = NO;
    }
    return self;    
}

- (void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event {
	p = [[touches anyObject] locationInView: self];
    isTouching = YES;
    [self setNeedsDisplay];
	//CGPathMoveToPoint(path, NULL, p.x, p.y);
}

- (void) touchesMoved: (NSSet *) touches withEvent: (UIEvent *) event {
	p = [[touches anyObject] locationInView: self];
	//CGPathAddLineToPoint(path, NULL, p.x, p.y);
	[self setNeedsDisplay];	//Trigger a call to drawRect:.
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    isTouching = NO;
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextRef c2 = UIGraphicsGetCurrentContext();
    CGSize s = self.bounds.size;
    
    arrays = [model outputDetailValuesToPlot];
    NSArray *sepBalA = [arrays objectAtIndex:10];
    
    float labelSize = s.width/75;
    float titleSize = s.width/35;
    maxVal = 0.0;
    minVal = 999999.0;
    float year = 0.0;
    CGFloat radius = .008 * s.width;	//in pixels
    
    
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
    
    float m = s.width / 7;
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
    int xLabel = model.currentAge;
    
    
    CGFloat scale = xGrid;
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
    
    //title
    NSString *graphTitle = @"SEP Balance";
    CGSize t = [graphTitle sizeWithFont:fontTitle];
    CGPoint point = CGPointMake(xSpace / 2 - t.width / 2, - ySpace - t.height - m /3);
    CGContextScaleCTM(c, 1, -1);
    [graphTitle drawAtPoint:point withFont:fontTitle];
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
    
    /*    
     //y border
     CGContextBeginPath(c);
     CGContextMoveToPoint(c, xSpace, 0);    
     CGContextAddLineToPoint(c, xSpace, ySpace);
     static const CGFloat colorBorder[] = {0, 0, 0, 0.15};	//rgb alpha
     CGContextSetStrokeColor(c, colorBorder);
     CGContextStrokePath(c);
     */  
    
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
    
    //plot line
    CGContextBeginPath(c);
    CGContextMoveToPoint(c, 0, 0);//can't start y at 0, need to pull value from array
    plot = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < xDomain; ++i) {
        //the conversion of the float value to a screen point should be a separate method so that it can be called in multiple locations
        float value = [[sepBalA objectAtIndex:i] floatValue];    
        
        if (minVal < 0) {
            value = fabsf(minVal) + value;
            maxVal = fabsf(minVal) + maxVal;
        }
        
        float yPoint = value/maxVal * ySpace;
        CGContextAddLineToPoint(c, year, yPoint);      
        [plot addObject:[NSValue valueWithCGPoint:CGPointMake(year,yPoint)]];
        year = year + xPoint;
    }
    
    CGSize size = CGSizeMake(1,1);
    CGContextSetStrokeColorWithColor(c, [UIColor redColor].CGColor);
    CGContextSetLineWidth(c, 2);
    CGContextSetShadow(c, size, 5);
    CGContextStrokePath(c);
    
    //plot points
    for (NSValue *val in plot) {
        CGPoint point = [val CGPointValue];
        CGRect r = CGRectMake(
                              point.x - radius / 2,
                              point.y - radius / 2,
                              2 * radius / 2,
                              2 * radius / 2
                              );
        CGContextBeginPath(c2); 
        CGContextAddEllipseInRect(c2, r);
        CGContextSetRGBFillColor(c2, 1.0, 0.0, 0.0, 1.0);	//red, opaque
        CGContextFillPath(c2);
    }
    
    if (isTouching) {
        
        /*
         //vertical line
         CGContextBeginPath(c);
         CGContextMoveToPoint(c, p.x - m, 0);    
         CGContextAddLineToPoint(c, p.x - m, ySpace);
         static const CGFloat colorLine[] = {1, 0, 0, 0.4};	//rgb alpha
         CGContextSetLineWidth(c, 1);
         CGContextSetStrokeColor(c, colorLine);
         CGContextStrokePath(c);
         */  
        
        //marker dot    
        for (int i = 1; i < plot.count; ++i) {
            e1 = [[plot objectAtIndex:i-1]CGPointValue];
            e2 = [[plot objectAtIndex:i]CGPointValue];
            if (e1.x < p.x - m && p.x - m < e2.x) {
                break;
            }
        }
        CGRect r = CGRectMake(
                              e1.x - radius,
                              e1.y - radius,
                              2 * radius,
                              2 * radius
                              );
        CGContextBeginPath(c); 
        CGContextAddEllipseInRect(c, r);
        CGContextSetLineWidth(c, 2);
        CGContextSetRGBStrokeColor(c, 0.75, 0.0, 0.0, 0.75);	//red, opaque
        CGContextStrokePath(c);
        
        //vertical line
        CGContextBeginPath(c);
        CGContextMoveToPoint(c, e1.x, 0);    
        CGContextAddLineToPoint(c, e1.x, ySpace);
        static const CGFloat colorLine[] = {0.75, 0.0, 0.0, 0.25};	//rgb alpha
        CGContextSetLineWidth(c, 1);
        CGContextSetStrokeColor(c, colorLine);
        CGContextStrokePath(c);
        
        //horizontal line
        CGContextBeginPath(c);
        CGContextMoveToPoint(c, 0, e1.y);    
        CGContextAddLineToPoint(c, xSpace, e1.y);
        CGContextSetLineWidth(c, 1);
        CGContextSetStrokeColor(c, colorLine);
        CGContextStrokePath(c);
        
    }
    
    //****************** Pattern should always come last ***************************** 
    
    
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

/*
 - (void) plotLine {
 CGContextRef c = UIGraphicsGetCurrentContext();
 CGContextBeginPath(c);
 CGContextMoveToPoint(c, 0, 0);//can't start y at 0, need to pull value from array
 plot = [[NSMutableArray alloc] init];
 
 for (int i = 0; i < xDomain; ++i) {
 //the conversion of the float value to a screen point should be a separate method so that it can be called in multiple locations
 float value = [[sepBalA objectAtIndex:i] floatValue];    
 
 if (minVal < 0) {
 value = fabsf(minVal) + value;
 maxVal = fabsf(minVal) + maxVal;
 }
 
 float yPoint = value/maxVal * ySpace;
 CGContextAddLineToPoint(c, year, yPoint);      
 [plot addObject:[NSValue valueWithCGPoint:CGPointMake(year,yPoint)]];
 year = year + xPoint;
 }
 
 CGSize size = CGSizeMake(1,1);
 CGContextSetStrokeColorWithColor(c, [UIColor redColor].CGColor);
 CGContextSetLineWidth(c, 2);
 CGContextSetShadow(c, size, 5);
 CGContextStrokePath(c);
 }

- (void) getMinMax {
    
}
*/
@end
