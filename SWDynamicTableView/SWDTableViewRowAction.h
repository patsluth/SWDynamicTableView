//
//  SWDTableViewRowAction.h
//  test
//
//  Created by Pat Sluth on 2016-01-07.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SWDEditTableViewCell;





@interface SWDTableViewRowAction : NSObject
{
}

NS_ASSUME_NONNULL_BEGIN

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) UIColor *backgroundColor;
@property (strong, nonatomic) UIImage *iconImage;

+ (_Nonnull instancetype)rowActionWithTitle:(NSString *)title
                            backgroundColor:(UIColor *)backgroundColor
                                  iconImage:(nullable UIImage *)iconImage
                                    handler:(void (^)(SWDTableViewRowAction *action, SWDEditTableViewCell *cell))handler;

- (void)invokeHandlerWithCell:(SWDEditTableViewCell *)cell;

NS_ASSUME_NONNULL_END

@end




