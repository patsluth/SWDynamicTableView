//
//  SWDEditTableViewCell.m
//  test ***********
//
//  Created by Pat Sluth on 2016-01-07.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import "SWDEditTableViewCell.h"

#import "SWDTableViewCellEditButton.h"
#import "SWDTableViewCellEditButtonMagneticContentView.h"
#import "SWDTableViewRowAction.h"





@interface SWDEditTableViewCell()
{
}

@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIAttachmentBehavior *attachmentBehaviour;

@property (strong, nonatomic) SWDTableViewCellEditButton *leftEditButton;
@property (strong, nonatomic) SWDTableViewCellEditButton *rightEditButton;

// Keeps track of which edit item we are panning on are so we can snap to it on release
@property (readwrite, nonatomic) NSInteger currentEditActionIndex;

@end






@implementation SWDEditTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.contentView.clipsToBounds = NO;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
        
        self.leftEditButton = [[SWDTableViewCellEditButton alloc] init];
        [self.contentView addSubview:self.leftEditButton];
        // Anchor left button content view to the top right corner
        self.leftEditButton.contentView.layer.anchorPoint = CGPointMake(1.0, 0.5);
        // leftEditButton constraints
        [self.leftEditButton.widthAnchor constraintEqualToAnchor:self.contentView.widthAnchor multiplier:10].active = YES;
        [self.leftEditButton.heightAnchor constraintEqualToAnchor:self.contentView.heightAnchor multiplier:1.0].active = YES;
        [self.leftEditButton.rightAnchor constraintEqualToAnchor:self.contentView.leftAnchor].active = YES;
        [self.leftEditButton.topAnchor constraintEqualToAnchor:self.contentView.topAnchor].active = YES;
        
        self.rightEditButton = [[SWDTableViewCellEditButton alloc] init];
        // Anchor right button content view to the top left corner
        self.rightEditButton.contentView.layer.anchorPoint = CGPointMake(0.0, 0.5);
        [self.contentView addSubview:self.rightEditButton];
        // leftEditButton constraints
        [self.rightEditButton.widthAnchor constraintEqualToAnchor:self.contentView.widthAnchor multiplier:10].active = YES;
        [self.rightEditButton.heightAnchor constraintEqualToAnchor:self.contentView.heightAnchor multiplier:1.0].active = YES;
        [self.rightEditButton.leftAnchor constraintEqualToAnchor:self.contentView.rightAnchor].active = YES;
        [self.rightEditButton.topAnchor constraintEqualToAnchor:self.contentView.topAnchor].active = YES;
    
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        
        CGPoint touchLocation = [touch locationInView:self.contentView];
        
        if (touchLocation.x < 0.0 || touchLocation.x > CGRectGetWidth(self.contentView.bounds)) { // edit buttons
            return YES;
        }
        
    }
    
    return NO;
}

- (void)onTap:(UITapGestureRecognizer *)tap
{
    if (self.currentEditActionIndex == 0) { // Just in case
        return;
    }
    
    NSInteger index = ABS(self.currentEditActionIndex) - 1;
    NSArray<SWDTableViewRowAction *> *editActions = [self editActionsArrayForItemIndex:self.currentEditActionIndex];
    SWDTableViewRowAction *action = [editActions objectAtIndex:index];
    [action invokeHandlerWithCell:self];    
}

- (CGPoint)snapPointForEditActionIndex:(NSInteger)index
{
    CGPoint snapPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    if (index != 0) { // valid edit action item
        
        index = ABS(index) - 1;
        
        CGFloat offset = [self contentViewHorizontalOffset];
        NSArray<SWDTableViewRowAction *> *editActions = [self editActionsArrayForHorizontalOffset:offset];
        
        if (editActions && editActions.count) {
            
            // The offset required to begin editing
            CGFloat inactiveHorizontalOffset = copysign(self.indentationWidth, offset);
            // The leftover width is used to distrubute the edit actions evenly
            CGFloat leftoverWidth = CGRectGetWidth(self.frame) - ABS(inactiveHorizontalOffset);
            
            CGFloat itemWidth = leftoverWidth / editActions.count;
            
            snapPoint.x += copysign((itemWidth * index), offset) + copysign(inactiveHorizontalOffset, offset);
            
        }
        
    }
    
    return snapPoint;
}

- (NSInteger)editItemIndexForCurrentOffset
{
    CGFloat offset = [self contentViewHorizontalOffset];
    NSArray<SWDTableViewRowAction *> *editActions = [self editActionsArrayForHorizontalOffset:offset];
    
    if (editActions && editActions.count != 0) {
        
        // The offset required to begin editing
        CGFloat inactiveHorizontalOffset = self.indentationWidth;
        // The leftover width is used to distrubute the edit actions evenly
        CGFloat leftoverWidth = CGRectGetWidth(self.frame) - inactiveHorizontalOffset;
        CGFloat itemWidth = leftoverWidth / editActions.count;
        
        if (fabs(offset) > inactiveHorizontalOffset) {
            
            // Don't start at 0 since we are using that as the middle value
            // Where the content offset is not far enough either direction to justify
            // An action
            for (NSUInteger index = 1; index < editActions.count + 1; index++) {
                
                if (fabs(offset) < (itemWidth * index) + inactiveHorizontalOffset) {
                    return index * copysign(1, offset);
                }
                
            }
            
            //we have scroll past the farthest value, so we will return the last edit item
            return copysign(editActions.count, offset);
            
        }
    }
    
    return 0;
}

- (void)onPan:(UIPanGestureRecognizer *)pan
{
    CGPoint panLocation = [pan locationInView:self];
    __block SWDEditTableViewCell *bself = self;
    
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        
        // Reset
        [self resetDynamicBehaviours];
        self.currentEditActionIndex = 0;
        
        
        // Attach the content view to our pan location
        self.attachmentBehaviour = [UIAttachmentBehavior slidingAttachmentWithItem:self.contentView
                                                         attachmentAnchor:panLocation
                                                                 axisOfTranslation:CGVectorMake(0.0, 1.0)];
        
        self.attachmentBehaviour.action = ^{
            [bself updateEditActionButtons];
            [bself updateEditMagneticContentView];
        };
        
        [self.animator addBehavior:self.attachmentBehaviour];
        
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        
        self.attachmentBehaviour.anchorPoint = panLocation;
        
    } else if (pan.state == UIGestureRecognizerStateEnded) {
        
        [self.animator removeBehavior:self.attachmentBehaviour];
        
        //velocity after dragging
        CGPoint velocity = [pan velocityInView:pan.view];
        
        UIDynamicItemBehavior *d = [[UIDynamicItemBehavior alloc] initWithItems:@[self.contentView]];
        d.allowsRotation = NO;
        d.resistance = 4.0;
        
        __block UIDynamicItemBehavior *bd = d;
        
        d.action = ^{
            
            [bself updateEditActionButtons];
            [bself updateEditMagneticContentView];
            
            CGFloat leftSide = CGRectGetMinX(bself.contentView.frame);
            CGFloat rightSide = CGRectGetMaxX(bself.contentView.frame);
            
            if (rightSide < 0) {
                bd.resistance = fabs(rightSide);
            } else if (leftSide > CGRectGetMaxX(bself.frame)) {
                bd.resistance = leftSide - CGRectGetMaxX(bself.frame);
            }
            
            
            CGFloat absoluteVelocity = fabs([bd linearVelocityForItem:bself.contentView].x);
            
            //snap to center if we are moving to slow
            if (absoluteVelocity < CGRectGetMidX(bself.bounds)) {
                [bself.animator removeBehavior:bd];
                [bself snapToCurrentEditActionIndex];
            }
            
        };
        
        [bself.animator addBehavior:d];
        [d addLinearVelocity:CGPointMake(velocity.x, 0.0) forItem:bself.contentView];
    }
}

- (void)resetDynamicBehaviours
{
    [self.animator removeAllBehaviors];
    
    [self.leftEditButton refreshUIDynamicsWithSnapPoint:[self anchorPointToLeftSideOfContentView]];
    [self.rightEditButton refreshUIDynamicsWithSnapPoint:[self anchorPointToRightSideOfContentView]];
    
    for (UIDynamicBehavior *behaviour in self.leftEditButton.dynamicBehaviours) {
        [self.animator addBehavior:behaviour];
    }
    for (UIDynamicBehavior *behaviour in self.rightEditButton.dynamicBehaviours) {
        [self.animator addBehavior:behaviour];
    }
    
    // Lock the contentview vertically so it only snaps horizontally (axisOfTranslation is backwards for some reason?)
    UIAttachmentBehavior *verticalLockAttachmentBehaviour = [UIAttachmentBehavior slidingAttachmentWithItem:self.contentView
                                                                                           attachmentAnchor:self.contentView.center
                                                                                          axisOfTranslation:CGVectorMake(1.0, 0.0)];
    [self.animator addBehavior:verticalLockAttachmentBehaviour];
}

- (void)snapToCurrentEditActionIndex
{
    [self resetDynamicBehaviours];
    
    CGPoint snapPoint = [self snapPointForEditActionIndex:self.currentEditActionIndex];
    
    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:self.contentView snapToPoint:snapPoint];
    snap.damping = 0.6;
    
    snap.action = ^{
        [self updateEditMagneticContentView];
    };
    
    // Remove collision and friction from the magnetic view so it slides smoothly
    UIDynamicItemBehavior *dynamic = [[UIDynamicItemBehavior alloc] initWithItems:@[self.contentView]];
    dynamic.elasticity = 0.0;
    dynamic.friction = 10.0;
    dynamic.density = 10.0;
    dynamic.resistance = 10.0;
    dynamic.allowsRotation = NO;
    
    [self.animator addBehavior:snap];
    [self.animator addBehavior:dynamic];
}

/**
 *  Updates state of edit buttons based on position of content view
 */
- (void)updateEditActionButtons
{
    NSInteger properEditItemIndex = [self editItemIndexForCurrentOffset];
    
    if (properEditItemIndex != self.currentEditActionIndex) { // we changed items (left <-> right)
        
        self.currentEditActionIndex = properEditItemIndex;
        
        [UIView animateWithDuration:0.25
                              delay:0.0
                            options:UIViewAnimationCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             
                             if (self.currentEditActionIndex == 0) { // nothing selected
                                 
                                 self.leftEditButton.contentView.alpha = 0.0;
                                 self.leftEditButton.backgroundColor = [UIColor lightGrayColor];
                                 self.rightEditButton.contentView.alpha = 0.0;
                                 self.rightEditButton.backgroundColor = [UIColor lightGrayColor];
                                 
                             } else {
                                 
                                 NSInteger index = ABS(self.currentEditActionIndex) - 1;
                                 
                                 NSArray<SWDTableViewRowAction *> *editActions = [self editActionsArrayForItemIndex:self.currentEditActionIndex];
                                 SWDTableViewRowAction *action = [editActions objectAtIndex:index];
                                 
                                 if (self.currentEditActionIndex > 0) {
                                     self.leftEditButton.contentView.alpha = 1.0;
                                     self.leftEditButton.contentView.label.text = action.title;
                                     self.leftEditButton.backgroundColor = action.backgroundColor;
                                 } else {
                                     self.rightEditButton.contentView.label.text = action.title;
                                     self.rightEditButton.contentView.alpha = 1.0;
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
    
    self.currentEditActionIndex = 0;
    self.contentView.center = [self snapPointForEditActionIndex:self.currentEditActionIndex];
}

- (BOOL)isEditing
{
    return ([self contentViewHorizontalOffset] != 0.0);
}

//- (void)setSelected:(BOOL)selected
//{
//    if ([self contentViewHorizontalOffset] == 0.0) {
//        [super setSelected:selected];
//    }
//}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    if (!editing) {
        
        self.currentEditActionIndex = 0;
        
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


/**
 *  Offset of the draggable (content) view from rest position
 *
 *  @return CGFloat
 */
- (CGFloat)contentViewHorizontalOffset
{
    return CGRectGetMinX(self.contentView.frame);
}

/**
 *  Updates the UIDynamicBehaviours of the edit content view
 */
- (void)updateEditMagneticContentView
{
    CGFloat offset = [self contentViewHorizontalOffset];
    
    if (offset > 0.0) {
        self.leftEditButton.contentView.snapBehaviour.snapPoint = [self anchorPointToLeftSideOfContentView];
    } else if (offset < 0.0) {
        self.rightEditButton.contentView.snapBehaviour.snapPoint = [self anchorPointToRightSideOfContentView];
    }
}

/**
 *  The left anchor point for items attaching to the content view
 *
 *  @return CGPoint
 */
- (CGPoint)anchorPointToLeftSideOfContentView
{
    return CGPointMake(CGRectGetMinX(self.contentView.frame), CGRectGetMidY(self.contentView.frame));
}

/**
 *  The right anchor point for items attaching to the content view
 *
 *  @return CGPoint
 */
- (CGPoint)anchorPointToRightSideOfContentView
{
    return CGPointMake(CGRectGetMaxX(self.contentView.frame), CGRectGetMidY(self.contentView.frame));
}

// Returns the left or right actions array based on offset
- (NSArray<SWDTableViewRowAction *> *)editActionsArrayForItemIndex:(NSInteger)index
{
    if (index > 0) {
        return self.leftEditActions;
    } else if (index < 0) {
        return self.rightEditActions;
    }
    return nil;
}

// Returns the left or right actions array based on offset
- (NSArray<SWDTableViewRowAction *> *)editActionsArrayForHorizontalOffset:(CGFloat)offset
{
    if (offset > 0.0) {
        return self.leftEditActions;
    } else if (offset < 0.0) {
        return self.rightEditActions;
    }
    return nil;
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
    if (self.currentEditActionIndex == 0) {
        return nil;
    }
    
    NSInteger index = ABS(self.currentEditActionIndex) - 1;
    
    NSArray<SWDTableViewRowAction *> *editActions = [self editActionsArrayForItemIndex:self.currentEditActionIndex];
    return [editActions objectAtIndex:index];
}

@end




