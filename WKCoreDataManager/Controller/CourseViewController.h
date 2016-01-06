//
//  CourseViewController.h
//  CoreDataExample
//
//  Created by 吴珂 on 15/12/26.
//  Copyright © 2015年 MyCompany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Teacher.h"



@interface CourseViewController : UIViewController

//@property (strong, nonatomic) Teacher  *teacher;

@property (strong, nonatomic) NSManagedObjectID *teacherID;



//@property (strong, nonatomic) NSManagedObjectContext *privateContext;

@end
