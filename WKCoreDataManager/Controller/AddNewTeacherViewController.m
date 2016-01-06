//
//  AddNewTeacherViewController.m
//  CoreDataExample
//
//  Created by 吴珂 on 15/12/28.
//  Copyright © 2015年 MyCompany. All rights reserved.
//

#import "AddNewTeacherViewController.h"
#import "Teacher.h"
#import "UIAlertView+AutoDismiss.h"
#import "WKCoreDataManager.h"

@interface AddNewTeacherViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTF;

@property (strong, nonatomic) NSManagedObjectContext *privateContext;

@end

@implementation AddNewTeacherViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
    
    [self setupCoreData];
    
    
}

- (void)setupUI
{
    UIBarButtonItem *finishItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveTeacher)];
    self.navigationItem.rightBarButtonItem = finishItem;
    
}

- (void)setupCoreData
{
    _privateContext = [[WKCoreDataManager sharedDataManager] createPrivateThreadContext];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];

}

- (void)saveTeacher
{
    if (_nameTF.text.length == 0) {
        [UIAlertView alertViewAutoDismissWithMessage:@"姓名不能为空"];
        return;
    }
    
    Teacher *teacher = [Teacher insertNewObjectIntoContext:_privateContext];
    teacher.name = _nameTF.text;
    
    [_privateContext performBlock:^{
        NSError *error = nil;
        [_privateContext save:&error];
            if (error) {
            NSLog(@"添加教师失败%@", [error localizedDescription]);
            }else{
                NSLog(@"添加成功");
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIAlertView alertViewAutoDismissWithMessage:@"添加成功"];
                    [self.navigationController popViewControllerAnimated:YES];
                });
                
                
            }
    }];
    
}

@end
