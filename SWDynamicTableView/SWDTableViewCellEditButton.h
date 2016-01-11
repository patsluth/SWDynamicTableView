//
//  SWDTableViewCellEditButton.h
//  test
//
//  Created by Pat Sluth on 2016-01-10.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SWDTableViewCellEditButtonMagneticContentView.h"





@interface SWDTableViewCellEditButton : UIView

@property (strong, nonatomic) SWDTableViewCellEditButtonMagneticContentView *contentView;

- (NSArray *)dynamicBehaviours;
/**
 *  Refresh all dynamic items to the updated snap point on the content view
 *
 *  @param snapPoint CGPoint
 */
- (void)refreshUIDynamicsWithSnapPoint:(CGPoint)snapPoint;

@end




