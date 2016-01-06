//
//  Teacher+CoreDataProperties.h
//  CoreDataExample
//
//  Created by 吴珂 on 15/12/26.
//  Copyright © 2015年 MyCompany. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Teacher.h"

NS_ASSUME_NONNULL_BEGIN

@interface Teacher (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *indetity;
@property (nullable, nonatomic, retain) NSNumber *age;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSSet<Course *> *courses;

@end

@interface Teacher (CoreDataGeneratedAccessors)

- (void)addCoursesObject:(Course *)value;
- (void)removeCoursesObject:(Course *)value;
- (void)addCourses:(NSSet<Course *> *)values;
- (void)removeCourses:(NSSet<Course *> *)values;

@end

NS_ASSUME_NONNULL_END
