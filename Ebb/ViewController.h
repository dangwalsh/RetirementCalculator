//
//  ViewController.h
//  Ebb
//
//  Created by Daniel Walsh on 5/28/12.
//  Copyright (c) 2012 Walsh walsh Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Model;


@interface ViewController : UIViewController {
    Model *model;

}

- (id)initWithNibName:(NSString *)nibNameOrNil 
               bundle:(NSBundle *)nibBundleOrNil 
                model: (Model *) m
title: (NSString *) title
image: (UIImage *) image
badge: (NSString *) badge;
@end
