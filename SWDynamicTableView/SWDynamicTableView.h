//
//  SWDynamicTableView.h
//  SWDynamicTableView
//
//  Created by Pat Sluth on 2016-01-10.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SWDynamicTableView, SWDTableViewRowAction;





@protocol SWDynamicTableViewDelegate <UITableViewDelegate>

@optional

/**
 *  The edit actions to be displayed to the left of the cell's content view
 *
 *  @param tableView
 *  @param indexPath
 *
 *  @return NSArray
 */
- (NSArray<SWDTableViewRowAction *> *)tableView:(SWDynamicTableView *)tableView
			   editActionsLeftForRowAtIndexPath:(NSIndexPath *)indexPath;
/**
 *  The edit actions to be displayed to the right of the cell's content view
 *
 *  @param tableView
 *  @param indexPath
 *
 *  @return NSArray
 */
- (NSArray<SWDTableViewRowAction *> *)tableView:(SWDynamicTableView *)tableView
			  editActionsRightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end





@interface SWDynamicTableView : UITableView <UIGestureRecognizerDelegate>
{
}

/**
 *  Allow multiple cells to enter edit mode at once.
 *	Defaults to YES
 */
@property (nonatomic) BOOL allowsMultipleEditing;

@end




