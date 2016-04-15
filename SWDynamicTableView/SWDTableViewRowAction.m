//
//  SWDTableViewRowAction.m
//  SWDynamicTableView
//
//  Created by Pat Sluth on 2016-01-07.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import "SWDTableViewRowAction.h"

#import "SWDEditTableViewCell.h"





@interface SWDTableViewRowAction()
{
}

@property (weak, nonatomic) void (^handlerRef)(SWDTableViewRowAction *action, SWDEditTableViewCell *cell);

@end





@implementation SWDTableViewRowAction

+ (instancetype)rowActionWithTitle:(NSString *)title
                   backgroundColor:(UIColor *)backgroundColor
                         iconImage:(UIImage *)iconImage
                           handler:(void (^)(SWDTableViewRowAction *action, SWDEditTableViewCell *cell))handler
{
    SWDTableViewRowAction *action = [[SWDTableViewRowAction alloc] init];
    
    action.title = title;
    action.backgroundColor = backgroundColor;
    action.iconImage = iconImage;
    action.handlerRef = handler;
    
    return action;
}

- (void)invokeHandlerWithCell:(SWDEditTableViewCell *)cell
{
    if (self.handlerRef) {
        self.handlerRef(self, cell);
    }
}

@end




