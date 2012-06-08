//
//  TableViewControllerResults.m
//  Ebb
//
//  Created by Daniel Walsh on 5/20/12.
//  Copyright (c) 2012 Walsh walsh Studio. All rights reserved.
//

#import "TableViewControllerResults.h"
#import "Model.h"

@interface TableViewControllerResults ()

@end

@implementation TableViewControllerResults

- (id) initWithStyle:(UITableViewStyle) style
               model: (Model *) m
           indexPath: (NSIndexPath *) p
               title: (NSString *) title
               image: (UIImage *) image
               badge: (NSString *) badge
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        model = m;
        //indexPath = p;
        self.title = title;
        self.tabBarItem.image = image;
        self.tabBarItem.badgeValue = badge;
        
        [self sliderValueChanged:slider];

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
    return [model numberOfOutputSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [model numberOfOutputRowsPerSection: section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 
                                      reuseIdentifier:CellIdentifier];
	}
    // Configure the cell...

    CGRect f = CGRectMake(
                          10, 
                          10, 
                          100, 
                          20
                          );
    slider = [[UISlider alloc] initWithFrame: f];
    slider.minimumValue = model.currentAge;
    slider.maximumValue = model.lifeExpectancy - 1;
    slider.value = n + model.currentAge;
    slider.continuous = YES;
    
    NSNumberFormatter *formatCur = [[NSNumberFormatter alloc] init];
    [formatCur setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSNumberFormatter *formatPer = [[NSNumberFormatter alloc] init];
    [formatPer setNumberStyle:NSNumberFormatterPercentStyle];
    NSNumberFormatter *numTest = [[NSNumberFormatter alloc] init];
    [numTest setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSArray *outGroup = [model outputLabelNames: indexPath];

    
    cell.textLabel.text = [outGroup objectAtIndex: indexPath.row];
    
    NSArray *resultsGroup = [model outputDetailValues: indexPath];
    
    NSArray *array = [resultsGroup objectAtIndex: indexPath.row];
    
    if (indexPath.row != 0) {
        val = [array objectAtIndex:n];
        NSLog (@"Value: %@", val );
    } else {
        cell.accessoryView = slider;
        [(UISlider *)cell.accessoryView 
            addTarget:self 
            action:@selector(sliderValueChanged:) 
            forControlEvents:UIControlEventValueChanged];
    }

    if (indexPath.row != 7 && indexPath.row != 0) {
        float f = [val floatValue];
        if (f < 1.0 && f > 0.0) {
            cell.detailTextLabel.text = [formatPer stringFromNumber:[NSNumber numberWithFloat: f]];
        } else {
            cell.detailTextLabel.text = [formatCur stringFromNumber:[NSNumber numberWithFloat: f]];
        }
    } else if (indexPath.row != 0){
        NSArray *textArray = [resultsGroup objectAtIndex: indexPath.row];
        cell.detailTextLabel.text = [textArray objectAtIndex:n];
    } else {
        int adj = n + model.currentAge;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%i",adj];
    }
 
    return cell;
}

- (void) sliderValueChanged: (id) sender {
    UISlider *s = sender;
    if (s.value - model.currentAge >= 0){
        n = s.value - model.currentAge;
    }
    
    [self.tableView reloadData];
    NSLog(@"Value: %d", n);
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
