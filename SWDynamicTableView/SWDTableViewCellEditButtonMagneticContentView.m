//
//  SWDTableViewCellEditButtonMagneticContentView.m
//  test
//
//  Created by Pat Sluth on 2016-01-10.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import "SWDTableViewCellEditButtonMagneticContentView.h"




@interface SWDTableViewCellEditButtonMagneticContentView()
{
}

@property (strong, nonatomic, readwrite) UIImageView *iconView;
@property (strong, nonatomic, readwrite) UILabel *label;

@end





@implementation SWDTableViewCellEditButtonMagneticContentView

- (id)init
{
    self = [super init];
    
    if (self) {
        
        self.userInteractionEnabled = NO;
        self.clipsToBounds = YES;
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 1.0;
        
        [self initialize];
        
    }
    
    return self;
}

- (void)setIcon:(UIImage *)icon
{
    _icon = icon;
    
    [self initialize];
}

- (void)initialize
{
    // Create icon
    self.iconView = [[UIImageView alloc] initWithImage:self.icon];
    self.iconView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.iconView];
    
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
    
    
    // Create layout guide with a center Y value equal to a quarter of this views height
    // so we can easily distribute the icon and label vertically
    UILayoutGuide *verticalDitributiveGuide = [[UILayoutGuide alloc] init];
    [self addLayoutGuide:verticalDitributiveGuide];
    [verticalDitributiveGuide.heightAnchor constraintEqualToAnchor:self.heightAnchor multiplier:0.5].active = YES;
    [verticalDitributiveGuide.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    
    
    // Add icon constraints
    [self.iconView.widthAnchor constraintEqualToAnchor:self.widthAnchor multiplier:0.25].active = YES;
    [self.iconView.heightAnchor constraintEqualToAnchor:self.heightAnchor multiplier:0.25].active = YES;
    [self.iconView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
    [self.iconView.centerYAnchor constraintEqualToAnchor:verticalDitributiveGuide.topAnchor].active = YES;
    
    //Add label constraints
    [self.label.widthAnchor constraintEqualToAnchor:self.widthAnchor].active = YES;
    [self.label.heightAnchor constraintEqualToConstant:CGRectGetHeight(self.label.bounds)].active = YES;
    [self.label.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
    
    // Centre the label if there is no icon
    if (self.icon) {
        [self.label.centerYAnchor constraintEqualToAnchor:verticalDitributiveGuide.bottomAnchor].active = YES;
    } else {
        [self.label.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    }
}

@end




