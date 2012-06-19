//
//  TableViewController.m
//  Ebb
//
//  Created by Daniel Walsh on 5/19/12.
//  Copyright (c) 2012 Walsh walsh Studio. All rights reserved.
//

#import "TableViewController.h"
#import "Model.h"
#import "TableViewControllerParams.h"

@interface TableViewController ()

@end

@implementation TableViewController

- (id)initWithStyle: (UITableViewStyle)style 
              model: (Model *) m 
          indexPath: (NSIndexPath *) p 
              title: (NSString *) title
              image: (UIImage *) image
              badge: (NSString *) badge
{
    self = [super initWithStyle: style];
    if (self) {
        // Custom initialization
        
        model = m;
        
        self.title = title;
        self.tabBarItem.image = image;
        self.tabBarItem.badgeValue = badge;
        self.navigationItem.backBarButtonItem.title = self.title;
        /*
         self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
         initWithTitle: @"Results"
         style: UIBarButtonItemStylePlain
         target: [UIApplication sharedApplication].delegate
         action: @selector(getResults)
         ];
         */
        self.navigationItem.title = @"Retirement Calculator";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewWillAppear: (BOOL) animated
{
	[super viewWillAppear: animated];
    [model calculateOutputDetails];
    [self.tableView reloadData];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    
    return [model numberOfInputSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    return [model numberOfInputRowsPerSection: section];
}

- (UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
    static NSString *CellIdentifier = @"Tree";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 
                                      reuseIdentifier:CellIdentifier];
	}
    
    // Configure the cell...
    
    // Initialize number formatters
    NSNumberFormatter *formatCur = [[NSNumberFormatter alloc] init];
    [formatCur setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSNumberFormatter *formatPer = [[NSNumberFormatter alloc] init];
    [formatPer setNumberStyle:NSNumberFormatterPercentStyle];
    
    NSArray *propGroup = [model inputLabelNames:indexPath];
    cell.textLabel.text = [propGroup objectAtIndex: indexPath.row];
    
    NSArray *paramGroup = [model inputDetailValues:indexPath];
    float f = [[paramGroup objectAtIndex: indexPath.row] floatValue];
    
    if (f < 1.0 && f > 0.0) {
        cell.detailTextLabel.text = [formatPer stringFromNumber:[NSNumber numberWithFloat: f]];
    } else if (f < 100) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%g", 
                                     [[paramGroup objectAtIndex: indexPath.row] floatValue]];
    } else {
        cell.detailTextLabel.text = [formatCur stringFromNumber:[NSNumber numberWithFloat: f]];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (NSString *) tableView: (UITableView *) tableView titleForHeaderInSection: (NSInteger) section {
	return [model inputHeaderNames: section];
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
    TableViewControllerParams *tableViewControllerParams = [[TableViewControllerParams alloc]
                                                            initWithStyle: UITableViewStyleGrouped
                                                            model: model
                                                            indexPath: indexPath
                                                            ];
    
    [self.navigationController pushViewController: tableViewControllerParams animated: YES];
    //[model calculateResults];
}

@end
