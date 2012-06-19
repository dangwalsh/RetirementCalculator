//
//  TableViewControllerParams.m
//  Ebb
//
//  Created by Daniel Walsh on 5/20/12.
//  Copyright (c) 2012 Walsh walsh Studio. All rights reserved.
//

#import "TableViewControllerParams.h"
#import "TableViewController.h"
#import "Model.h"

@implementation TableViewControllerParams

- (id) initWithStyle:(UITableViewStyle) style model: (Model *) m indexPath: (NSIndexPath *) p;
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        model = m;
        indexPath = [p copy];
        
        self.title = [[model inputLabelNames: p] objectAtIndex:p.row];;
        self.navigationItem.backBarButtonItem.title = self.title;
    }
    return self;
}

- (void) didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
    
	// Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)p
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 
                                      reuseIdentifier:CellIdentifier];
	}
    // Configure the cell...
    NSArray *paramGroup = [model inputDetailValues: indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%g", 
                           [[paramGroup objectAtIndex: indexPath.row] floatValue]];
    
    return cell;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)p
{
    
    if (selected) {
		//Arrive here if user was already editing one cell and then touched another.
		//Stop editing the first cell before we begin to edit the second one.
		[self textFieldShouldReturn: textField];
		[self textFieldDidEndEditing: textField];
	}
    
	//Add a UITextField to the selected cell.
	//The initial text of the text field must coincide with the text of the textLabel.
	selected = [tableView cellForRowAtIndexPath: p];
	UIFont *font = selected.textLabel.font;
	CGFloat dy = (selected.contentView.bounds.size.height - font.lineHeight) / 2;
    
	CGRect frame = CGRectMake(
                              selected.textLabel.frame.origin.x,
                              selected.textLabel.frame.origin.y,
                              selected.contentView.bounds.size.width,
                              selected.contentView.bounds.size.height - dy
                              );
    
	textField = [[UITextField alloc] initWithFrame: frame];
	textField.delegate = self;
	textField.backgroundColor = selected.textLabel.backgroundColor;
	textField.textColor = selected.textLabel.textColor;
	textField.text = selected.textLabel.text;
	selected.textLabel.hidden = YES;
	textField.font = font;
	[selected.contentView addSubview: textField];
	[textField becomeFirstResponder];   //show the keyboard
	[tableView deselectRowAtIndexPath: p animated: YES];
}

#pragma mark -
#pragma mark protocol UITextFieldDelegate

//Called when return key is pressed, or when user starts editing a different cell.
//Decide if the app should accept this input and hide the keyboard.

- (BOOL) textFieldShouldReturn: (UITextField *) t
{
	[t resignFirstResponder];//Hide keyboard.
	return YES;	//The text field should do its default behavior.
}

//Called when keyboard is hidden.
//Process the text that was input.

- (void) textFieldDidEndEditing: (UITextField *) t
{
    CGFloat newFloat = [textField.text floatValue];
    NSMutableArray *paramGroup = [model updateDetailValues: indexPath];
    [paramGroup replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithFloat:newFloat]];
	selected.textLabel.text = textField.text;
    selected.textLabel.hidden = NO;
    [t removeFromSuperview];
	selected = nil;
	textField = nil;
    
}

@end
