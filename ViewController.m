//
//  ViewController.m
//  SWDynamicTableView
//
//  Created by Pat Sluth on 2016-01-10.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import "ViewController.h"

#import "SWDTableViewCell.h"





@interface ViewController ()

@end





@implementation ViewController

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	SWDTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SWDTableViewCell"];
	
	if (!cell) {
		cell = [[SWDTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SWDTableViewCell"];
	}
	
	cell.delegate = self;
	cell.indentationWidth = [self tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
	
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	SWDTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
	[cell setEditing:NO animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellEditingStyleNone;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return nil;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

#pragma mark - SWDynamicTableViewDelegate

- (NSArray<SWDTableViewRowAction *> *)tableView:(SWDynamicTableView *)tableView
			   editActionsLeftForRowAtIndexPath:(NSIndexPath *)indexPath
{
	SWDTableViewRowAction *action1 = [SWDTableViewRowAction
									  rowActionWithTitle:@"Action1"
									  backgroundColor:[UIColor orangeColor]
									  image:nil
									  handler:^(SWDTableViewRowAction *action, NSIndexPath *indexPath) {
										  [[tableView cellForRowAtIndexPath:indexPath] setEditing:NO animated:YES];
										  NSLog(@"%@", action.title);
									  }];
	
	SWDTableViewRowAction *action2 = [SWDTableViewRowAction
									  rowActionWithTitle:@"Action2"
									  backgroundColor:[UIColor cyanColor]
									  image:nil
									  handler:^(SWDTableViewRowAction *action, NSIndexPath *indexPath) {
										  [[tableView cellForRowAtIndexPath:indexPath] setEditing:NO animated:YES];
										  NSLog(@"%@", action.title);
									  }];
	
	SWDTableViewRowAction *action3 = [SWDTableViewRowAction
									  rowActionWithTitle:@"Action3"
									  backgroundColor:[UIColor redColor]
									  image:nil
									  handler:^(SWDTableViewRowAction *action, NSIndexPath *indexPath) {
										  [[tableView cellForRowAtIndexPath:indexPath] setEditing:NO animated:YES];
										  NSLog(@"%@", action.title);
									  }];
	
	return @[action3, action2, action1];
}

- (NSArray<SWDTableViewRowAction *> *)tableView:(SWDynamicTableView *)tableView
			  editActionsRightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	SWDTableViewRowAction *action1 = [SWDTableViewRowAction
									  rowActionWithTitle:@"Action1"
									  backgroundColor:[UIColor orangeColor]
									  image:nil
									  handler:^(SWDTableViewRowAction *action, NSIndexPath *indexPath) {
										  [[tableView cellForRowAtIndexPath:indexPath] setEditing:NO animated:YES];
										  NSLog(@"%@", action.title);
									  }];
	
	SWDTableViewRowAction *action2 = [SWDTableViewRowAction
									  rowActionWithTitle:@"Action2"
									  backgroundColor:[UIColor cyanColor]
									  image:nil
									  handler:^(SWDTableViewRowAction *action, NSIndexPath *indexPath) {
										  [[tableView cellForRowAtIndexPath:indexPath] setEditing:NO animated:YES];
										  NSLog(@"%@", action.title);
									  }];
	
	SWDTableViewRowAction *action3 = [SWDTableViewRowAction
									  rowActionWithTitle:@"Action3"
									  backgroundColor:[UIColor redColor]
									  image:nil
									  handler:^(SWDTableViewRowAction *action, NSIndexPath *indexPath) {
										  [[tableView cellForRowAtIndexPath:indexPath] setEditing:NO animated:YES];
										  NSLog(@"%@", action.title);
									  }];
	
	return @[action1, action2, action3];
}

@end




