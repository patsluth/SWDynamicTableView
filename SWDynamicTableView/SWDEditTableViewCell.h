//
//  SWDEditTableViewCell.h
//  test
//
//  Created by Pat Sluth on 2016-01-07.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SWDTableViewRowAction;





@interface SWDEditTableViewCell : UITableViewCell <UIGestureRecognizerDelegate, UIDynamicAnimatorDelegate>
{
}

@property (weak, nonatomic) id<UITableViewDelegate> delegate;

@property (strong, nonatomic) NSArray<SWDTableViewRowAction *> *leftEditActions;
@property (strong, nonatomic) NSArray<SWDTableViewRowAction *> *rightEditActions;

- (void)onPan:(UIGestureRecognizer *)pan;
- (SWDTableViewRowAction *)currentEditAction;

@end




