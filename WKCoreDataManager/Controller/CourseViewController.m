//
//  CourseViewController.m
//  CoreDataExample
//
//  Created by 吴珂 on 15/12/26.
//  Copyright © 2015年 MyCompany. All rights reserved.
//

#import "CourseViewController.h"
#import "WKCoreDataManager.h"
#import "AddNewCourseViewController.h"
#import "Course.h"


@interface CourseViewController ()

<
UITableViewDelegate,
UITableViewDataSource
>
@property (weak, nonatomic) IBOutlet UITableView *tableVeiw;

@property (nonatomic, strong) NSFetchedResultsController *fetchController;

@property (nonatomic, strong) NSManagedObjectContext *privateManagedContext;

@property (nonatomic, strong) Teacher *editTeacher;

@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation CourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [self setupUI];

    [self setupFetchController];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupCoreData];
    
}

- (void)setupCoreData
{
    _privateManagedContext = [[WKCoreDataManager sharedDataManager] createPrivateThreadContext];
    
    _editTeacher = [_privateManagedContext objectWithID:_teacherID];
    
    _dataSource = [NSArray arrayWithArray:_editTeacher.courses.allObjects];
    
    [self.tableVeiw reloadData];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@的课程", _editTeacher.name];
}

- (void)setupUI
{
//    self.navigationItem.title = [NSString stringWithFormat:@"%@的课程", _editTeacher.name];
    
    UIBarButtonItem *tItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCourse:)];
    
    self.navigationItem.rightBarButtonItem = tItem;
}

- (void)setupFetchController
{

}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    Course *tCourse = _dataSource[indexPath.row];
    
    cell.textLabel.text = tCourse.name;
    
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (editingStyle) {
        case UITableViewCellEditingStyleNone: {
            
            break;
        }
        case UITableViewCellEditingStyleDelete: {
            
            [_privateManagedContext performBlock:^{
                NSError *error = nil;
                [_privateManagedContext deleteObject:_dataSource[indexPath.row]];
                [_privateManagedContext save:&error];
                
                if (error) {
                    NSLog(@"删除失败%@", [error localizedDescription]);
                }else{
                    NSLog(@"删除成功");
                    _dataSource = [NSArray arrayWithArray:_editTeacher.courses.allObjects];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableVeiw reloadData];
                    });
                }
            }];
            
            break;
        }
        case UITableViewCellEditingStyleInsert: {
            
            break;
        }
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self performSegueWithIdentifier:@"addCourse" sender:indexPath];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    AddNewCourseViewController *addVC = segue.destinationViewController;
    if (sender) {
        NSIndexPath *indexPath = sender;
        Course *editCourse = _dataSource[indexPath.row];
        addVC.courseID = editCourse.objectID;
//        addVC.course = ;
    }else{
        addVC.type = ShowTypeAdd;
    }
    addVC.teacherID = _teacherID;
}


- (void)addCourse:(id)sender
{
    [self performSegueWithIdentifier:@"addCourse" sender:nil];
    
    
}

@end
