//
//  UIAlertView+block.h
//  Category
//
//  Created by 吴珂 on 15/11/13.
//  Copyright © 2015年 MyCompany. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^UIAlertViewCallBackBlock)(NSInteger buttonIndex);

@interface UIAlertView (block)<UIAlertViewDelegate>

@property (copy, nonatomic) UIAlertViewCallBackBlock alertViewCallBackBlock;

+ (void)alertViewWithCallBackBlock:(UIAlertViewCallBackBlock)callBackBlock title:(NSString *)title message:(NSString *)message cancleButtonName:(NSString *)cancleButtonName otherButtonNames:(NSString *)otherButtonNames,...NS_REQUIRES_NIL_TERMINATION;

@end
