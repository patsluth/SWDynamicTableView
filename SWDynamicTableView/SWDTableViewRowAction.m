//
//  SWDTableViewRowAction.m
//  SWDynamicTableView
//
//  Created by Pat Sluth on 2016-01-07.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import "SWDTableViewRowAction.h"

#import "SWDTableViewCell.h"





@interface SWDTableViewRowAction()
{
}

@property (strong, nonatomic) SWDDynamicTableViewCellHandler handler;

@end





@implementation SWDTableViewRowAction

#pragma mark - Init

+ (instancetype)rowActionWithTitle:(NSString *)title
				   backgroundColor:(UIColor *)backgroundColor
							 image:(UIImage *)image
						   handler:(SWDDynamicTableViewCellHandler)handler
{
    SWDTableViewRowAction *action = [[SWDTableViewRowAction alloc] init];
    
    action.title = title;
    action.backgroundColor = backgroundColor;
    action.image = image;
    action.handler = handler;
    
    return action;
}

#pragma mark - SWDTableViewRowAction

- (void)invokeHandlerWithIndexPath:(NSIndexPath *)indexPath
{
	if (self.handler) {
		self.handler(self, indexPath);
	}
}

@end




