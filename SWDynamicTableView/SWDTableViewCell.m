//
//  SWDTableViewCell.m
//  SWDynamicTableView
//
//  Created by Pat Sluth on 2016-01-07.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import "SWDTableViewCell.h"

#import "SWDTableViewCellRowActionButton.h"
#import "SWDTableViewCellRowActionButtonContentView.h"





@interface SWDTableViewCell()
{
}

@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIAttachmentBehavior *attachmentBehaviour;

@property (strong, nonatomic) SWDTableViewCellRowActionButton *leftEditButton;
@property (strong, nonatomic) SWDTableViewCellRowActionButton *rightEditButton;

/**
 *  Keeps track of which edit item we are panning on are so we can snap to it on release
 *
 *	< 0 means left edit actions
 *	  0 means none
 *	> 0 means left edit actions
 */
@property (readwrite, nonatomic) NSInteger editActionIndex;

@end






@implementation SWDTableViewCell

#pragma mark - Init

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
		self.editActionIndex = 0;
		self.contentView.clipsToBounds = NO;
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		self.defaultEditButtonColor = [UIColor lightGrayColor];
		

        self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
		
		
        self.leftEditButton = [[SWDTableViewCellRowActionButton alloc] init];
        [self.contentView addSubview:self.leftEditButton];
        // Anchor left button content view to the top right corner
        self.leftEditButton.contentView.layer.anchorPoint = CGPointMake(1.0, 0.5);
        // leftEditButton constraints
        [self.leftEditButton.widthAnchor constraintEqualToAnchor:self.contentView.widthAnchor multiplier:10].active = YES;
        [self.leftEditButton.heightAnchor constraintEqualToAnchor:self.contentView.heightAnchor multiplier:1.0].active = YES;
        [self.leftEditButton.rightAnchor constraintEqualToAnchor:self.contentView.leftAnchor].active = YES;
        [self.leftEditButton.topAnchor constraintEqualToAnchor:self.contentView.topAnchor].active = YES;
		
		
        self.rightEditButton = [[SWDTableViewCellRowActionButton alloc] init];
        // Anchor right button content view to the top left corner
        self.rightEditButton.contentView.layer.anchorPoint = CGPointMake(0.0, 0.5);
        [self.contentView addSubview:self.rightEditButton];
        // rightEditButton constraints
        [self.rightEditButton.widthAnchor constraintEqualToAnchor:self.contentView.widthAnchor multiplier:10].active = YES;
        [self.rightEditButton.heightAnchor constraintEqualToAnchor:self.contentView.heightAnchor multiplier:1.0].active = YES;
        [self.rightEditButton.leftAnchor constraintEqualToAnchor:self.contentView.rightAnchor].active = YES;
        [self.rightEditButton.topAnchor constraintEqualToAnchor:self.contentView.topAnchor].active = YES;
    }
    
    return self;
}

- (void)resetDynamicBehaviours
{
	[self.animator removeAllBehaviors];
	
	[self.leftEditButton snapToPoint:self.leftAnchorPoint];
	[self.rightEditButton snapToPoint:self.rightAnchorPoint];
	
	for (UIDynamicBehavior *behaviour in self.leftEditButton.bDynamicBehaviours) {
		[self.animator addBehavior:behaviour];
	}
	for (UIDynamicBehavior *behaviour in self.rightEditButton.bDynamicBehaviours) {
		[self.animator addBehavior:behaviour];
	}
	
	// Lock the contentview vertically so it only snaps horizontally (axisOfTranslation is backwards for some reason?)
	UIAttachmentBehavior *bAttachmentBehaviour = [UIAttachmentBehavior slidingAttachmentWithItem:self.contentView
																				attachmentAnchor:self.contentView.center
																			   axisOfTranslation:CGVectorMake(1.0, 0.0)];
	[self.animator addBehavior:bAttachmentBehaviour];
}

#pragma mark - UIGestureRecognizer

- (void)onPan:(UIPanGestureRecognizer *)pan
{
	__unsafe_unretained SWDTableViewCell *weakSelf = self;
	
	CGPoint panLocation = [pan locationInView:self];
	
	if (pan.state == UIGestureRecognizerStateBegan) {
		
		[self resetDynamicBehaviours];
		
		[self updateEditButtonWithEditItemIndex:self.editActionIndex animated:NO force:YES];
		
		// Attach the content view to our pan location
		self.attachmentBehaviour = [UIAttachmentBehavior slidingAttachmentWithItem:self.contentView
																  attachmentAnchor:panLocation
																 axisOfTranslation:CGVectorMake(0.0, 1.0)];
		
		self.attachmentBehaviour.action = ^{
			[weakSelf updateEditButtonWithEditItemIndex:[weakSelf editItemIndexForCurrentOffset] animated:YES force:NO];
			[weakSelf updateEditMagneticContentView];
		};
		
		[self.animator addBehavior:self.attachmentBehaviour];
		
	} else if (pan.state == UIGestureRecognizerStateChanged) {
		
		self.attachmentBehaviour.anchorPoint = panLocation;
		
	} else if (pan.state == UIGestureRecognizerStateEnded) {
		
		[pan removeTarget:self action:@selector(onPan:)];
		[self.animator removeBehavior:self.attachmentBehaviour];
		
		// velocity after dragging
		CGPoint velocity = [pan velocityInView:pan.view];
		
		UIDynamicItemBehavior *bDynamicItem = [[UIDynamicItemBehavior alloc] initWithItems:@[self.contentView]];
		bDynamicItem.allowsRotation = NO;
		bDynamicItem.resistance = 3.0;
		
		__unsafe_unretained UIDynamicItemBehavior *weakbDynamicItem = bDynamicItem;
		
		bDynamicItem.action = ^{
			
			[weakSelf updateEditButtonWithEditItemIndex:[weakSelf editItemIndexForCurrentOffset] animated:YES force:NO];
			[weakSelf updateEditMagneticContentView];
			
			CGFloat leftSide = CGRectGetMinX(weakSelf.contentView.frame);
			CGFloat rightSide = CGRectGetMaxX(weakSelf.contentView.frame);
			
			if (rightSide < 0) {
				weakbDynamicItem.resistance = ABS(rightSide);
			} else if (leftSide > CGRectGetMaxX(weakSelf.frame)) {
				weakbDynamicItem.resistance = leftSide - CGRectGetMaxX(weakSelf.frame);
			}
			
			
			CGFloat absoluteVelocity = ABS([weakbDynamicItem linearVelocityForItem:weakSelf.contentView].x);
			
			// snap to center if we are moving to slow
			if (absoluteVelocity < CGRectGetMidX(weakSelf.bounds)) {
				[weakSelf.animator removeBehavior:weakbDynamicItem];
				[weakSelf snapToCurrentEditActionIndex];
			}
			
		};
		
		[self.animator addBehavior:bDynamicItem];
		[bDynamicItem addLinearVelocity:CGPointMake(velocity.x, 0.0) forItem:self.contentView];
	}
}

#pragma mark - SWDTableViewCell

- (CGPoint)snapPointForEditActionIndex:(NSInteger)index
{
    CGPoint snapPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
	
    if (index != 0) { // valid edit action item
		
        index = ABS(index) - 1;
		
        NSArray<SWDTableViewRowAction *> *editActions = [self editActionsForContentOffset:self.contentOffset];
        
        if (editActions && editActions.count) {
            
            // The offset required to begin editing
            CGFloat contentOffsetThresholdX = copysign(self.indentationWidth, self.contentOffset.x);
            // The leftover width is used to distrubute the edit actions evenly
            CGFloat leftoverWidth = CGRectGetWidth(self.frame) - ABS(contentOffsetThresholdX);
            
            CGFloat itemWidth = leftoverWidth / editActions.count;
            
			snapPoint.x += copysign((itemWidth * index), self.contentOffset.x);
			snapPoint.x += copysign(contentOffsetThresholdX, self.contentOffset.x);
            
        }
        
    }
    
    return snapPoint;
}

- (NSInteger)editItemIndexForCurrentOffset
{
    NSArray<SWDTableViewRowAction *> *editActions = [self editActionsForContentOffset:self.contentOffset];
	
    if (editActions && editActions.count != 0) {
        
        // The offset required to begin editing
        CGFloat contentOffsetThresholdX = self.indentationWidth;
        // The leftover width is used to distrubute the edit actions evenly
        CGFloat leftoverWidth = CGRectGetWidth(self.frame) - contentOffsetThresholdX;
        CGFloat itemWidth = leftoverWidth / editActions.count;
        
        if (ABS(self.contentOffset.x) > contentOffsetThresholdX) {
            
            // Don't start at 0 since we are using that as the middle value
            // Where the content offset is not far enough either direction to justify
            // An action
            for (NSUInteger index = 1; index < editActions.count + 1; index++) {
                
                if (ABS(self.contentOffset.x) < (itemWidth * index) + contentOffsetThresholdX) {
                    return index * copysign(1, self.contentOffset.x);
                }
                
            }
            
            // we have scroll past the farthest value, so we will return the last edit item
            return copysign(editActions.count, self.contentOffset.x);
            
        }
    }
    
    return 0;
}

- (void)snapToCurrentEditActionIndex
{
    [self resetDynamicBehaviours];
	
	__unsafe_unretained SWDTableViewCell *weakSelf = self;
    CGPoint snapPoint = [self snapPointForEditActionIndex:self.editActionIndex];
    
    UISnapBehavior *bSnap = [[UISnapBehavior alloc] initWithItem:self.contentView snapToPoint:snapPoint];
    bSnap.damping = 0.6;
    
	bSnap.action = ^{
        [weakSelf updateEditMagneticContentView];
    };
     
    // Remove collision and friction from the magnetic view so it slides smoothly
    UIDynamicItemBehavior *bDynamicItem = [[UIDynamicItemBehavior alloc] initWithItems:@[self.contentView]];
    bDynamicItem.elasticity = 0.0;
    bDynamicItem.density = 70.0;
	bDynamicItem.resistance = 5.0;
	bDynamicItem.allowsRotation = NO;
	bDynamicItem.angularResistance = CGFLOAT_MAX;
	bDynamicItem.friction = 1.0;
	
    [self.animator addBehavior:bSnap];
    [self.animator addBehavior:bDynamicItem];
}

/**
 *  Updates state of edit buttons
 */
- (void)updateEditButtonWithEditItemIndex:(NSInteger)editItemIndex animated:(BOOL)animated force:(BOOL)force
{
    if (force || self.editActionIndex != editItemIndex) { // Did changed items
        
        self.editActionIndex = editItemIndex;
        
		[UIView animateWithDuration:animated ? 0.25 : 0.0
                              delay:0.0
                            options:UIViewAnimationCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             
                             if (self.editActionIndex == 0) { // nothing selected
                                 
								 self.leftEditButton.contentView.alpha = 0.0;
                                 self.leftEditButton.backgroundColor = self.defaultEditButtonColor;
                                 self.rightEditButton.contentView.alpha = 0.0;
                                 self.rightEditButton.backgroundColor = self.defaultEditButtonColor;
                                 
                             } else {
                                 
                                 NSInteger index = ABS(self.editActionIndex) - 1;
                                 
                                 NSArray<SWDTableViewRowAction *> *editActions = [self editActionsForEditItemIndex:self.editActionIndex];
                                 SWDTableViewRowAction *action = [editActions objectAtIndex:index];
                                 
                                 if (self.editActionIndex > 0) {
                                     self.leftEditButton.contentView.alpha = 1.0;
                                     self.leftEditButton.contentView.label.text = action.title;
                                     self.leftEditButton.backgroundColor = action.backgroundColor;
								 } else {
									 self.rightEditButton.contentView.alpha = 1.0;
                                     self.rightEditButton.contentView.label.text = action.title;
                                     self.rightEditButton.backgroundColor = action.backgroundColor;
                                 }
                                 
                             }
                             
                             
                         }
                         completion:nil];
        
    }
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    [self.animator removeAllBehaviors];
	
	self.leftEditActions = nil;
	self.rightEditActions = nil;
    self.editActionIndex = 0;
    self.contentView.center = [self snapPointForEditActionIndex:self.editActionIndex];
}

- (BOOL)isEditing
{
	return self.editActionIndex != 0;
//    return (self.contentOffset.x != 0.0);
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    if (!editing) {
        
        self.editActionIndex = 0;
        
        if (animated) {
            [self snapToCurrentEditActionIndex];
        } else {
            [self prepareForReuse];
        }
        
    }
}

- (void)setIndentationWidth:(CGFloat)indentationWidth
{
    [super setIndentationWidth:indentationWidth];
    
    [self.leftEditButton.contentView.widthAnchor constraintEqualToConstant:indentationWidth].active = YES;
    [self.rightEditButton.contentView.widthAnchor constraintEqualToConstant:indentationWidth].active = YES;
}

- (CGPoint)contentOffset
{
	return CGPointMake(CGRectGetMinX(self.contentView.frame), 0.0);
}

/**
 *  Updates the UIDynamicBehaviours of the edit content view
 */
- (void)updateEditMagneticContentView
{
    if (self.contentOffset.x >= 0.0) {
        self.leftEditButton.contentView.bSnap.snapPoint = self.leftAnchorPoint;
	} else {
        self.rightEditButton.contentView.bSnap.snapPoint = self.rightAnchorPoint;
    }
}

// Returns the left or right actions array based on offset
- (NSArray<SWDTableViewRowAction *> *)editActionsForEditItemIndex:(NSInteger)index
{
    if (index > 0) {
        return self.leftEditActions;
    } else if (index < 0) {
        return self.rightEditActions;
    }
	
    return nil;
}

// Returns the left or right actions array based on offset
- (NSArray<SWDTableViewRowAction *> *)editActionsForContentOffset:(CGPoint)offset
{
    if (offset.x > 0.0) {
        return self.leftEditActions;
    } else if (offset.x < 0.0) {
        return self.rightEditActions;
    }
	
    return nil;
}

- (CGPoint)leftAnchorPoint
{
	return CGPointMake(CGRectGetMinX(self.contentView.frame), CGRectGetMidY(self.contentView.bounds));
}

- (CGPoint)rightAnchorPoint
{
	return CGPointMake(CGRectGetMaxX(self.contentView.frame), CGRectGetMidY(self.contentView.bounds));
}

- (NSArray<SWDTableViewRowAction *> *)leftEditActions
{
    if (!_leftEditActions) {
        _leftEditActions = @[];
    }
    return _leftEditActions;
}

- (NSArray<SWDTableViewRowAction *> *)rightEditActions
{
    if (!_rightEditActions) {
        _rightEditActions = @[];
    }
    return _rightEditActions;
}

- (SWDTableViewRowAction *)currentEditAction
{
    if (self.editActionIndex == 0) {
        return nil;
    }
    
    NSInteger index = ABS(self.editActionIndex) - 1;
    
    NSArray<SWDTableViewRowAction *> *editActions = [self editActionsForEditItemIndex:self.editActionIndex];
    return [editActions objectAtIndex:index];
}

@end




