//
//  SWDTableViewCellEditButton.m
//  SWDynamicTableView
//
//  Created by Pat Sluth on 2016-01-10.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import "SWDTableViewCellEditButton.h"





@implementation SWDTableViewCellEditButton

#pragma mark - Init

- (id)init
{
	if (self = [super init]) {
		
		self.clipsToBounds = YES;
		self.translatesAutoresizingMaskIntoConstraints = NO;
		self.backgroundColor = [UIColor lightGrayColor];
		
		self.contentView = [[SWDTableViewCellEditButtonContentView alloc] init];
		[self addSubview:self.contentView];
		// contentView constraints
		[self.contentView.heightAnchor constraintEqualToAnchor:self.heightAnchor multiplier:1.0].active = YES;
		[self.contentView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
		
	}
	
	return self;
}

#pragma mark - SWDTableViewCellEditButton

- (NSArray<UIDynamicBehavior *> *)bDynamicBehaviours
{
	return @[self.contentView.bSnap,
			 self.contentView.bAttachment,
			 self.contentView.bDynamic];
}

- (void)snapToPoint:(CGPoint)snapPoint
{
	// Conect the magnetic content view to the content view
	self.contentView.bSnap = [[UISnapBehavior alloc] initWithItem:self.contentView snapToPoint:snapPoint];
	self.contentView.bSnap.damping = 0.3;
	
	// Lock the contentview vertically so it only snaps horizontally (axisOfTranslation is backwards for some reason?)
	self.contentView.bAttachment = [UIAttachmentBehavior slidingAttachmentWithItem:self.contentView
																  attachmentAnchor:snapPoint
																 axisOfTranslation:CGVectorMake(1.0, 0.0)];
	
	// Remove collision and friction from the magnetic view so it slides smoothly
	self.contentView.bDynamic = [[UIDynamicItemBehavior alloc] initWithItems:@[self.contentView]];
	self.contentView.bDynamic.density = 70.0;
	self.contentView.bDynamic.resistance = 5.0;
	self.contentView.bDynamic.allowsRotation = NO;
	self.contentView.bDynamic.angularResistance = CGFLOAT_MAX;
	self.contentView.bDynamic.friction = 1.0;
	self.contentView.bDynamic.elasticity = 0.0;
}

- (CGPoint)leftAnchorPoint
{
	return CGPointMake(CGRectGetMinX(self.contentView.frame), CGRectGetMidY(self.contentView.bounds));
}

- (CGPoint)rightAnchorPoint
{
	return CGPointMake(CGRectGetMaxX(self.contentView.frame), CGRectGetMidY(self.contentView.bounds));
}

@end









