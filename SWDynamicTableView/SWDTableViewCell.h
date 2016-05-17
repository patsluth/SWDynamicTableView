//
//  SWDTableViewCell.h
//  SWDynamicTableView
//
//  Created by Pat Sluth on 2016-01-07.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SWDTableViewRowAction.h"





@interface SWDTableViewCell : UITableViewCell <UIDynamicAnimatorDelegate>
{
}

@property (weak, nonatomic) id<UITableViewDelegate> delegate;

@property (strong, nonatomic) NSArray<SWDTableViewRowAction *> *leftEditActions;
@property (strong, nonatomic) NSArray<SWDTableViewRowAction *> *rightEditActions;

@property (weak, nonatomic, readonly) SWDTableViewRowAction *currentEditAction;

/**
 *  The color of the SWDTableViewRowActionButton when offset is less than threshold
 *	Defaults to [UIColor lightGrayColor]
 */
@property (strong, nonatomic) UIColor *defaultEditButtonColor;

@end




