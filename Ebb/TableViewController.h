//
//  TableViewController.h
//  Ebb
//
//  Created by Daniel Walsh on 5/19/12.
//  Copyright (c) 2012 Walsh walsh Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Model;
@class TableViewControllerParams;

@interface TableViewController : UITableViewController {
    Model *model;
}

- (id) initWithStyle:(UITableViewStyle) style
               model: (Model *) m
           indexPath: (NSIndexPath *) p
               title: (NSString *) title
               image: (UIImage *) image
               badge: (NSString *) badge;
@end
