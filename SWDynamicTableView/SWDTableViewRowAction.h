//
//  SWDTableViewRowAction.h
//  SWDynamicTableView
//
//  Created by Pat Sluth on 2016-01-07.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SWDTableViewCell, SWDTableViewRowAction;

typedef void (^SWDDynamicTableViewCellHandler) (SWDTableViewRowAction *action, NSIndexPath *indexPath);





@interface SWDTableViewRowAction : UITableViewRowAction
{
}

+ (instancetype)rowActionWithTitle:(NSString *)title
				   backgroundColor:(UIColor *)backgroundColor
							 image:(UIImage *)image
						   handler:(SWDDynamicTableViewCellHandler)handler;

@property (strong, nonatomic) UIImage *image;

- (void)invokeHandlerWithIndexPath:(NSIndexPath *)indexPath;

@end




