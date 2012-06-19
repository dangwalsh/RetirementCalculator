//
//  View.h
//  Ebb
//
//  Created by Daniel Walsh on 5/28/12.
//  Copyright (c) 2012 Walsh walsh Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;
@class Model;

@interface View : UIView {
    ViewController *viewController;
    Model *model;
    
    NSArray *arrays;
    NSMutableArray *plot;
    CGPoint p;
    CGPoint e1;
    CGPoint e2;
    
    BOOL isTouching;
    
    float minVal;
    float maxVal;
}
- (id)initWithFrame:(CGRect) frame
         controller: (ViewController *) c
              model: (Model *) m;
@end
