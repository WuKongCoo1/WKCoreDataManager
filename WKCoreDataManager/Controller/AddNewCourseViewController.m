//
//  AddNewCourseViewController.m
//  CoreDataExample
//
//  Created by 吴珂 on 15/12/28.
//  Copyright © 2015年 MyCompany. All rights reserved.
//

#import "AddNewCourseViewController.h"
#import "Teacher.h"
#import "WKCoreDataManager.h"
#import "UIAlertView+block.h"
#import "UIAlertView+AutoDismiss.h"
#import "Course.h"



@interface AddNewCourseViewController ()

@property (nonatomic, strong) NSManagedObjectContext *privateManagedContext;

@property (nonatomic, strong) Teacher *editTeacher;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *identityTF;

@property (nonatomic, strong) Course *editCourse;


@end

@implementation AddNewCourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupCoreData];
    
    [self setupUI];
}

- (void)setupUI
{
    UIBarButtonItem *finishItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveCourse)];
    self.navigationItem.rightBarButtonItem = finishItem;
    
}


- (void)setupCoreData
{
    _privateManagedContext  = [[WKCoreDataManager sharedDataManager] createPrivateThreadContext];
    
    switch (self.type) {
        case ShowTypeEdit: {
            _editCourse = [_privateManagedContext objectWithID:_courseID];
            _nameTF.text = _editCourse.name;
            
            break;
        }
        case ShowTypeAdd: {
            
            break;
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveCourse
{
    
    if (_nameTF.text.length == 0) {
        [UIAlertView alertViewAutoDismissWithMessage:@"课程名不能为空"];
        return;
    }
    
    switch (_type) {
        case ShowTypeEdit: {
            [self editCourse];
            break;
        }
        case ShowTypeAdd: {
            [self addCourse];
            break;
        }
    }
    
    
    
}

- (void)editCourse
{
    __block NSError *error = nil;
    [_privateManagedContext performBlock:^{
        _editCourse.name = _nameTF.text;
        [_privateManagedContext save:&error];
        if (error) {
            NSLog(@"修改失败");
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIAlertView alertViewAutoDismissWithMessage:@"修改成功"];
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }];
    
}

- (void)addCourse
{
    
    
    Teacher *editTeacher = [_privateManagedContext objectWithID:_teacherID];
    
    Course *newCourse = [Course insertNewObjectIntoContext:_privateManagedContext];
    newCourse.name = _nameTF.text;
    
    [editTeacher addCoursesObject:newCourse];
    
    __block NSError *error = nil;
    
    [_privateManagedContext performBlock:^{
        [_privateManagedContext save:&error];
        if (error) {
            NSLog(@"添加课程出错%@", [error localizedDescription]);
        }else{
            NSLog(@"保存成功");
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIAlertView alertViewAutoDismissWithMessage:@"提成添加成功"];
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }];
}

@end
