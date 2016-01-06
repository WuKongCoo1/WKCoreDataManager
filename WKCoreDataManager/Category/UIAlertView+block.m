//
//  UIAlertView+block.m
//  Category
//
//  Created by 吴珂 on 15/11/13.
//  Copyright © 2015年 MyCompany. All rights reserved.
//

#import "UIAlertView+block.h"
#import <objc/runtime.h>

static char UIAlertViewKey;

@implementation UIAlertView (block)
/*
 下面是 <stdarg.h> 里面重要的几个宏定义如下：
 typedef char* va_list;
 void va_start ( va_list ap, prev_param ); // ANSI version
 type va_arg ( va_list ap, type );
 void va_end ( va_list ap );
 va_list 是一个字符指针，可以理解为指向当前参数的一个指针，取参必须通过这个指针进行。
 <Step 1> 在调用参数表之前，定义一个 va_list 类型的变量，(假设va_list 类型变量被定义为ap)；
 <Step 2> 然后应该对ap 进行初始化，让它指向可变参数表里面的第一个参数，这是通过 va_start 来实现的，第一个参数是 ap 本身，第二个参数是在变参表前面紧挨着的一个变量,即“...”之前的那个参数；
 <Step 3> 然后是获取参数，调用va_arg，它的第一个参数是ap，第二个参数是要获取的参数的指定类型，然后返回这个指定类型的值，并且把 ap 的位置指向变参表的下一个变量位置；
 <Step 4> 获取所有的参数之后，我们有必要将这个 ap 指针关掉，以免发生危险，方法是调用 va_end，他是输入的参数 ap 置为 NULL，应该养成获取完参数表之后关闭指针的习惯。说白了，就是让我们的程序具有健壮性。通常va_start和va_end是成对出现。
 */


+ (void)alertViewWithCallBackBlock:(UIAlertViewCallBackBlock)callBackBlock title:(NSString *)title message:(NSString *)message cancleButtonName:(NSString *)cancleButtonName otherButtonNames:(NSString *)otherButtonNames,...NS_REQUIRES_NIL_TERMINATION
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancleButtonName otherButtonTitles: nil];
    NSString *other = nil;
    va_list args;

    if (otherButtonNames) {
        [alert addButtonWithTitle:otherButtonNames];
        va_start(args, otherButtonNames);
        while ((other = va_arg(args, NSString*))) {
            [alert addButtonWithTitle:other];
        }
        va_end(args);
    }
    alert.delegate = alert;
    [alert show];
    alert.alertViewCallBackBlock = callBackBlock;
}

- (void)setAlertViewCallBackBlock:(UIAlertViewCallBackBlock)alertViewCallBackBlock
{
    [self willChangeValueForKey:@"UIAlertViewCallBackKey"];
    objc_setAssociatedObject(self, &UIAlertViewKey, alertViewCallBackBlock, OBJC_ASSOCIATION_COPY);
    [self didChangeValueForKey:@"UIAlertViewCallBackKey"];
}

- (UIAlertViewCallBackBlock)alertViewCallBackBlock
{
    return objc_getAssociatedObject(self, &UIAlertViewKey);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.alertViewCallBackBlock) {
        self.alertViewCallBackBlock(buttonIndex);
    }
}


@end
