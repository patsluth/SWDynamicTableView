//
//  ViewController.m
//  SWDynamicTableView
//
//  Created by Pat Sluth on 2016-01-10.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import "ViewController.h"
#import "SWDEditTableViewCell.h"
#import "SWDTableViewRowAction.h"





@interface ViewController ()

@property (strong, nonatomic) UIPanGestureRecognizer *pan;

@end





@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.pan = [[UIPanGestureRecognizer alloc] init];
    self.pan.delegate = self;
    [self.tableView addGestureRecognizer:self.pan];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (gestureRecognizer == self.pan) {
        
        // Remove all targets
        [self.pan removeTarget:nil action:nil];
        
        CGPoint touchLocation = [touch locationInView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:touchLocation];
        
        if (indexPath && [self tableView:self.tableView canEditRowAtIndexPath:indexPath]) {
            
            SWDEditTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            
            
            // Only allow one cell to be edited at a time
            // COMMENT OUT TO ALLOW MULTIPLE CELLS TO BE EDITED AT THE SAME TIME
            for (SWDEditTableViewCell *temp in [self.tableView visibleCells]) {
                if (temp != cell && temp.isEditing) {
                    [temp setEditing:NO animated:YES];
                }
            }
            
            
            [self.pan addTarget:cell action:@selector(onPan:)];
            return YES;
        }
        
    }
    
    return NO;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.pan) {
        
        CGPoint panVelocity = [self.pan velocityInView:self.pan.view];
        return (fabs(panVelocity.x) > fabs(panVelocity.y)); //only accept horizontal pans
        
    }
    
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SWDEditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[SWDEditTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.delegate = self;
    cell.indentationWidth = [self tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(SWDEditTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *leftActions = [@[] mutableCopy];
    NSMutableArray *rightActions = [@[] mutableCopy];
    
    SWDTableViewRowAction *action1 = [SWDTableViewRowAction rowActionWithTitle:@"Action1"
                                                               backgroundColor:[UIColor orangeColor]
                                                                     iconImage:nil
                                                                       handler:^(SWDTableViewRowAction *action, SWDEditTableViewCell *cell) {
                                                                           [cell setEditing:NO animated:YES];
                                                                           NSLog(@"%@", action.title);
                                                                       }];
    
    SWDTableViewRowAction *action2 = [SWDTableViewRowAction rowActionWithTitle:@"Action2"
                                                               backgroundColor:[UIColor cyanColor]
                                                                     iconImage:nil
                                                                       handler:^(SWDTableViewRowAction *action, SWDEditTableViewCell *cell) {
                                                                           [cell setEditing:NO animated:YES];
                                                                           NSLog(@"%@", action.title);
                                                                       }];
    
    SWDTableViewRowAction *action3 = [SWDTableViewRowAction rowActionWithTitle:@"Action3"
                                                               backgroundColor:[UIColor redColor]
                                                                     iconImage:nil
                                                                       handler:^(SWDTableViewRowAction *action, SWDEditTableViewCell *cell) {
                                                                           [cell setEditing:NO animated:YES];
                                                                           NSLog(@"%@", action.title);
                                                                       }];
    
    [leftActions addObject:action1];
    [leftActions addObject:action2];
    [leftActions addObject:action3];
    
    [rightActions addObject:action3];
    [rightActions addObject:action2];
    [rightActions addObject:action1];
    
    cell.leftEditActions = [leftActions copy];
    cell.rightEditActions = [rightActions copy];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SWDEditTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell setEditing:NO animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

@end




