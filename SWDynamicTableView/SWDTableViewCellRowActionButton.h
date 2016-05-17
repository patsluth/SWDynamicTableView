//
//  SWDTableViewCellRowActionButton.h
//  SWDynamicTableView
//
//  Created by Pat Sluth on 2016-01-10.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SWDTableViewCellRowActionButtonContentView.h"





@interface SWDTableViewCellRowActionButton : UIView
{
}

@property (strong, nonatomic, readonly) SWDTableViewCellRowActionButtonContentView *contentView;

/**
 *  Array of this buttons UIDynamicBehaviors
 */
@property (readonly) NSArray<UIDynamicBehavior *> *bDynamicBehaviours;

/**
 *  Refresh all dynamic items to the updated snap point on the content view
 *
 *  @param snapPoint CGPoint
 */
- (void)snapToPoint:(CGPoint)snapPoint;

@end




