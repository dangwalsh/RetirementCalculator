//
//  TableViewControllerResults.h
//  Ebb
//
//  Created by Daniel Walsh on 5/20/12.
//  Copyright (c) 2012 Walsh walsh Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Model;

@interface TableViewControllerResults : UITableViewController {
    Model *model;
    UISlider *slider;
    NSString *val;
    int n;
}

- (id) initWithStyle:(UITableViewStyle) style
               model: (Model *) m
           indexPath: (NSIndexPath *) p
title: (NSString *) title
image: (UIImage *) image
badge: (NSString *) badge;
- (void) sliderValueChanged:(id) sender; 

@end
