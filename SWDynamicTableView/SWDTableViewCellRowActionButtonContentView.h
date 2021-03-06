//
//  SWDTableViewCellRowActionButtonContentView.h
//  SWDynamicTableView
//
//  Created by Pat Sluth on 2016-01-10.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import <UIKit/UIKit.h>





@interface SWDTableViewCellRowActionButtonContentView : UIView
{
}

@property (strong, nonatomic) UISnapBehavior *bSnap;
@property (strong, nonatomic) UIAttachmentBehavior *bAttachment;
@property (strong, nonatomic) UIDynamicItemBehavior *bDynamic;

@property (strong, nonatomic, readonly) UIImageView *imageView;
@property (strong, nonatomic, readonly) UILabel *label;

@end




