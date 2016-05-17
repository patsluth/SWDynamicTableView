//
//  SWDynamicTableView.m
//  SWDynamicTableView
//
//  Created by Pat Sluth on 2016-01-10.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import "SWDynamicTableView.h"

#import "SWDTableViewCell.h"





@interface SWDynamicTableView()
{
}

@property (weak, nonatomic) id<SWDynamicTableViewDelegate> delegate;

@property (strong, nonatomic) UIPanGestureRecognizer *pan;
@property (strong, nonatomic) UITapGestureRecognizer *tap;

@end


@interface SWDTableViewCell(SWDynamicTableView)
{
}

- (void)onPan:(UIGestureRecognizer *)pan;

@end


@interface SWDTableViewRowAction(SWDynamicTableView)
{
}

- (void)invokeHandlerWithIndexPath:(NSIndexPath *)indexPath;

@end





@implementation SWDynamicTableView

@dynamic delegate;

#pragma mark - Init

- (id)init
{
	if (self = [super init]) {
		
		[self initialize];
		
	}
	
	return self;
}

- (void)awakeFromNib
{
	[super awakeFromNib];
	
	[self initialize];
}

- (void)initialize
{
	self.allowsMultipleEditing = YES;
}

- (void)didMoveToSuperview
{
	[super didMoveToSuperview];
	
	[self.pan removeTarget:nil action:nil]; // Remove all targets
	self.pan = [[UIPanGestureRecognizer alloc] init];
//	[self.pan addTarget:self action:@selector(onPan:)];
	self.pan.delegate = self;
	[self addGestureRecognizer:self.pan];
	
	self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
	self.tap.delegate = self;
	[self addGestureRecognizer:self.tap];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
	if (gestureRecognizer == self.tap) {
		
		CGPoint touchLocation = [touch locationInView:self];
		NSIndexPath *indexPath = [self indexPathForRowAtPoint:touchLocation];
		SWDTableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
		
		touchLocation = [self convertPoint:touchLocation toView:cell.contentView];
		
		// Touch is not on the content view, therefore it must be on an the edit action button
		return ![cell.contentView pointInside:touchLocation withEvent:nil];
		
	}
	
	return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
	if (gestureRecognizer == self.pan) {
		
		CGPoint panVelocity = [self.pan velocityInView:self.pan.view];
		
		if (ABS(panVelocity.x) > ABS(panVelocity.y)) { // Only accept horizontal pans
			
			CGPoint touchLocation = [gestureRecognizer locationInView:self];
			NSIndexPath *indexPath = [self indexPathForRowAtPoint:touchLocation];
			SWDTableViewCell *cell = nil;
			
			if (indexPath && [self.dataSource tableView:self canEditRowAtIndexPath:indexPath]) {
				
				cell = [self cellForRowAtIndexPath:indexPath];
				
				// Update cell's edit actions
				if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:editActionsLeftForRowAtIndexPath:)]) {
					cell.leftEditActions = [self.delegate tableView:self editActionsLeftForRowAtIndexPath:indexPath];
				}
				if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:editActionsRightForRowAtIndexPath:)]) {
					cell.rightEditActions = [self.delegate tableView:self editActionsRightForRowAtIndexPath:indexPath];
				}
				
				[self.pan addTarget:cell action:@selector(onPan:)];
				
			}
			
			if (!self.allowsMultipleEditing) {
				
				for (SWDTableViewCell *_cell in [self visibleCells]) {
					if (_cell != cell) {
						[_cell setEditing:NO animated:YES];
					}
				}
				
			}
			
			return YES;
		
		}
		
		return NO;
		
	}
	
	return [super gestureRecognizerShouldBegin:gestureRecognizer];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
	if ((gestureRecognizer == self.pan && otherGestureRecognizer == self.panGestureRecognizer) ||
		(gestureRecognizer == self.panGestureRecognizer && otherGestureRecognizer == self.pan)) {
		return NO;
	}
	
	return YES;
}

#pragma mark - UIGestureRecognizer

- (void)onTap:(UITapGestureRecognizer *)tap
{
	CGPoint touchLocation = [tap locationInView:self];
	NSIndexPath *indexPath = [self indexPathForRowAtPoint:touchLocation];
	SWDTableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
	
	touchLocation = [self convertPoint:touchLocation toView:cell.contentView];
	
	// Touch is not on the content view, therefore it must be on an the edit action button
	if (![cell.contentView pointInside:touchLocation withEvent:nil]) {
		[cell.currentEditAction invokeHandlerWithIndexPath:indexPath];
	}
}

//- (void)onPan:(UIPanGestureRecognizer *)pan
//{
//	if (pan.state == UIGestureRecognizerStateEnded) {
//		
//		for (SWDTableViewCell *cell in [self visibleCells]) {
//			
//			if (cell.isEditing) {
//				[cell.currentEditAction invokeHandlerWithIndexPath:[self indexPathForCell:cell]];
//				[cell setEditing:NO animated:YES];
//			}
//			
//		}
//		
//	}
//}

@end




