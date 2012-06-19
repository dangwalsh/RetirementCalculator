//
//  ViewController.m
//  Ebb
//
//  Created by Daniel Walsh on 5/28/12.
//  Copyright (c) 2012 Walsh walsh Studio. All rights reserved.
//

#import "ViewController.h"
#import "View.h"
#import "Model.h"

@implementation ViewController

- (id)initWithNibName: (NSString *)nibNameOrNil 
               bundle: (NSBundle *)nibBundleOrNil 
                model: (Model *)m
                title: (NSString *) title
                image: (UIImage *) image
                badge: (NSString *) badge
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        model = m;
        
        self.title = title;
        self.tabBarItem.image = image;
        self.tabBarItem.badgeValue = badge;
        
        //notification center init and observer should be moved to app delegate
        
        NSNotificationCenter *center =
        [NSNotificationCenter defaultCenter];
		
		[center
         addObserver: self
         selector: @selector(deviceOrientationDidChange:)
         name: UIDeviceOrientationDidChangeNotification
         object: nil
         ];
        
        device = [UIDevice currentDevice];
		[device beginGeneratingDeviceOrientationNotifications];
    }
    return self;
}

- (void) loadView {
    CGRect frame = [UIScreen mainScreen].applicationFrame;
    self.view = [[View alloc] 
                 initWithFrame: frame 
                 controller: self 
                 model: model
                 ]; //might not need the model in the view
}

- (void) deviceOrientationDidChange: (NSNotification *) n {
	[self.view setNeedsDisplay];
}

- (UIDeviceOrientation) deviceOrientation {
	return device.orientation;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (void) viewWillAppear: (BOOL) animated
{
	[super viewWillAppear: animated];
    [model calculateOutputDetails];
    [self.view setNeedsDisplay];
}

- (void) viewDidAppear: (BOOL) animated
{
	[super viewDidAppear: animated];
}

- (void) viewWillDisappear: (BOOL) animated
{
	[super viewWillDisappear: animated];
}

- (void) viewDidDisappear: (BOOL) animated
{
	[super viewDidDisappear: animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
