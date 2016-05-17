//
//  SWDTableViewCellRowActionButtonContentView.m
//  SWDynamicTableView
//
//  Created by Pat Sluth on 2016-01-10.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import "SWDTableViewCellRowActionButtonContentView.h"




@interface SWDTableViewCellRowActionButtonContentView()
{
}

@property (strong, nonatomic, readwrite) UIImageView *imageView;
@property (strong, nonatomic, readwrite) UILabel *label;

@end





@implementation SWDTableViewCellRowActionButtonContentView

#pragma mark Init

- (id)init
{
    if (self = [super init]) {
        
        self.userInteractionEnabled = NO;
        self.clipsToBounds = YES;
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 1.0;
        
        [self initialize];
        
    }
    
    return self;
}

- (void)initialize
{
    // Create icon
    self.imageView = [[UIImageView alloc] init];
	self.imageView.backgroundColor = [UIColor clearColor];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.imageView];
    
    // Create label
    self.label = [[UILabel alloc] init];
    self.label.translatesAutoresizingMaskIntoConstraints = NO;
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.backgroundColor = [UIColor clearColor];
    self.label.textColor = [UIColor whiteColor];
    self.label.adjustsFontSizeToFitWidth = YES;
    self.label.text = @" "; // so we can get the initial height
    [self.label sizeToFit];
    [self addSubview:self.label];
    
    
    // Add icon constraints
    [self.imageView.widthAnchor constraintEqualToAnchor:self.widthAnchor multiplier:0.25].active = YES;
    [self.imageView.heightAnchor constraintEqualToAnchor:self.heightAnchor multiplier:0.25].active = YES;
    [self.imageView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
    [self.imageView.bottomAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    
    // Add label constraints
    [self.label.widthAnchor constraintEqualToAnchor:self.widthAnchor].active = YES;
    [self.label.heightAnchor constraintEqualToConstant:CGRectGetHeight(self.label.bounds)].active = YES;
    [self.label.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
    
    // Centre the label if there is no icon
    if (!self.imageView.image) {
        [self.label.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    } else {
        [self.label.topAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    }
}

#pragma mark SWDTableViewCellRowActionButtonContentView

@end




