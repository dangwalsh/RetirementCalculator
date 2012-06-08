//
//  TableViewControllerParams.h
//  Ebb
//
//  Created by Daniel Walsh on 5/20/12.
//  Copyright (c) 2012 Walsh walsh Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Model;

@interface TableViewControllerParams : UITableViewController  <UITextFieldDelegate> {
    Model *model;
    NSIndexPath *indexPath;
    //The currenly selected cell (or nil) and its text field.
	UITableViewCell *selected;
	UITextField *textField;
    
}

- (id) initWithStyle:(UITableViewStyle) style
               model: (Model *) m
           indexPath: (NSIndexPath *) p;

@end
