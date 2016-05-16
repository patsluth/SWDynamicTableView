//
//  SWDTableViewCellEditButton.h
//  SWDynamicTableView
//
//  Created by Pat Sluth on 2016-01-10.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SWDTableViewCellEditButtonContentView.h"





@interface SWDTableViewCellEditButton : UIView

@property (strong, nonatomic) SWDTableViewCellEditButtonContentView *contentView;

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




