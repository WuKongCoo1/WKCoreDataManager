//
//  Course+CoreDataProperties.h
//  CoreDataExample
//
//  Created by 吴珂 on 15/12/26.
//  Copyright © 2015年 MyCompany. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Course.h"

NS_ASSUME_NONNULL_BEGIN

@interface Course (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *indetity;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) Teacher *teacher;

@end

NS_ASSUME_NONNULL_END
