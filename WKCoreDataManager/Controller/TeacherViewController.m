//
//  TeacherViewController.m
//  CoreDataExample
//
//  Created by 吴珂 on 15/12/23.
//  Copyright © 2015年 MyCompany. All rights reserved.
//

#import "TeacherViewController.h"
#import "WKCoreDataManager.h"
#import "CourseViewController.h"
#import "AddNewTeacherViewController.h"

@interface TeacherViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
NSFetchedResultsControllerDelegate
>
@property (weak, nonatomic) IBOutlet UITableView *tableVeiw;

@property (nonatomic, strong) NSFetchedResultsController *fetchController;

@end

@implementation TeacherViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
    
    [self setupFetchController];
    
//    [[WKCoreDataManager sharedDataManager] saveTeacherWithName:@"悟空"];
//    [[WKCoreDataManager sharedDataManager]  excute];
}

- (void)setupUI
{
    self.navigationItem.title = @"教师列表";
    
    
    UIBarButtonItem *tItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTeacher:)];
    
    self.navigationItem.rightBarButtonItem = tItem;
}

- (void)setupFetchController
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[Teacher entityName]];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(compare:)];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    
    _fetchController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[WKCoreDataManager sharedDataManager].mainThreadContext sectionNameKeyPath:nil cacheName:nil];
    
    _fetchController.delegate = self;
    
    NSError *error;
    BOOL suc= [_fetchController performFetch:&error];
    
    if (suc) {
//        _fetchController
        [self.tableVeiw reloadData];
    }
    
    if (error) {
        NSLog(@"%@", error);
    }
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_fetchController sections].count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> sectionInfo = [_fetchController.sections objectAtIndex:section];
    
    return [sectionInfo numberOfObjects];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    Teacher *teacher = [_fetchController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"教师：%@", teacher.name];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
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
            [[WKCoreDataManager sharedDataManager].mainThreadContext deleteObject:[_fetchController objectAtIndexPath:indexPath]];
            
            [[WKCoreDataManager sharedDataManager] save];
            
            
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

     [self performSegueWithIdentifier:@"gotoTeacherDetail" sender:indexPath];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    id vc = segue.destinationViewController;
    
    if ([vc isKindOfClass:[CourseViewController class]]) {
        CourseViewController *tdvc = segue.destinationViewController;
        Teacher *editTeacher =  [_fetchController objectAtIndexPath:sender];
        tdvc.teacherID = editTeacher.objectID;
    }
}

#pragma mark - NSFetchedResultsController
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(nullable NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(nullable NSIndexPath *)newIndexPath
{
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            [self.tableVeiw insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
            break;
        }
        case NSFetchedResultsChangeDelete: {
            [self.tableVeiw deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
            break;
        }
        case NSFetchedResultsChangeMove: {
            [self.tableVeiw deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableVeiw insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeUpdate: {
            [self.tableVeiw reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
    }
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableVeiw beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableVeiw endUpdates];
}


- (void)addTeacher:(id)sender
{
    [self performSegueWithIdentifier:@"addTeacher" sender:nil];
}

@end
