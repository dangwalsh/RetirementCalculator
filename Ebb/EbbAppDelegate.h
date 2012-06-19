//
//  EbbAppDelegate.h
//  Ebb
//
//  Created by Daniel Walsh on 5/19/12.
//  Copyright (c) 2012 Walsh walsh Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TableViewController;
@class TableViewControllerResults;
@class Model;

@interface EbbAppDelegate : UIResponder <UIApplicationDelegate, UISplitViewControllerDelegate>{
    Model *model;
}

@property (strong, nonatomic) UIWindow *window;

//- (void) getResults;

@end
