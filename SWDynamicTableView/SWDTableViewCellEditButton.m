//
//  SWDTableViewCellEditButton.m
//  test
//
//  Created by Pat Sluth on 2016-01-10.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import "SWDTableViewCellEditButton.h"





@implementation SWDTableViewCellEditButton

- (id)init
{
    self = [super init];
    
    if (self) {
        
        self.clipsToBounds = YES;
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor lightGrayColor];
        
        self.contentView = [[SWDTableViewCellEditButtonMagneticContentView alloc] init];
        [self addSubview:self.contentView];
        // contentView constraints
        [self.contentView.heightAnchor constraintEqualToAnchor:self.heightAnchor multiplier:1.0].active = YES;
        [self.contentView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
        
    }
    
    return self;
}

- (NSArray *)dynamicBehaviours
{
    return @[self.contentView.snapBehaviour,
             self.contentView.verticalLockAttachmentBehaviour,
             self.contentView.dynamicBehaviour];
}

- (void)refreshUIDynamicsWithSnapPoint:(CGPoint)snapPoint
{
    // Conect the magnetic content view to the content view
    self.contentView.snapBehaviour = [[UISnapBehavior alloc] initWithItem:self.contentView snapToPoint:snapPoint];
    self.contentView.snapBehaviour.damping = 0.8;
    
    // Lock the contentview vertically so it only snaps horizontally (axisOfTranslation is backwards for some reason?)
    self.contentView.verticalLockAttachmentBehaviour = [UIAttachmentBehavior slidingAttachmentWithItem:self.contentView
                                                                                          attachmentAnchor:snapPoint
                                                                                         axisOfTranslation:CGVectorMake(1.0, 0.0)];
    
    // Remove collision and friction from the magnetic view so it slides smoothly
    self.contentView.dynamicBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[self.contentView]];
    self.contentView.dynamicBehaviour.elasticity = 0.0;
    self.contentView.dynamicBehaviour.friction = 10.0;
    self.contentView.dynamicBehaviour.density = 10.0;
    self.contentView.dynamicBehaviour.resistance = 10.0;
    self.contentView.dynamicBehaviour.allowsRotation = NO;
}

@end




