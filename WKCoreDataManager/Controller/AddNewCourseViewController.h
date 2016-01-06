//
//  AddNewCourseViewController.h
//  CoreDataExample
//
//  Created by 吴珂 on 15/12/28.
//  Copyright © 2015年 MyCompany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

typedef NS_ENUM(NSInteger, ShowType) {
    ShowTypeEdit,
    ShowTypeAdd
};

@interface AddNewCourseViewController : UIViewController

@property (strong, nonatomic) NSManagedObjectID *teacherID;

@property (strong, nonatomic) NSManagedObjectID *courseID;

@property (assign, nonatomic) ShowType type;
@end
