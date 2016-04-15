//
//  SWDTableViewCellEditButtonMagneticContentView.h
//  SWDynamicTableView
//
//  Created by Pat Sluth on 2016-01-10.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import <UIKit/UIKit.h>





@interface SWDTableViewCellEditButtonMagneticContentView : UIView

@property (strong, nonatomic) UISnapBehavior *snapBehaviour;
@property (strong, nonatomic) UIAttachmentBehavior *verticalLockAttachmentBehaviour;
@property (strong, nonatomic) UIDynamicItemBehavior *dynamicBehaviour;

@property (strong, nonatomic) UIImage *icon;
@property (strong, nonatomic, readonly) UILabel *label;

@end




