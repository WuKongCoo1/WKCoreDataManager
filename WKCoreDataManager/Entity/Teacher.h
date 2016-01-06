//
//  Teacher.h
//  CoreDataExample
//
//  Created by 吴珂 on 15/12/26.
//  Copyright © 2015年 MyCompany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Course;

NS_ASSUME_NONNULL_BEGIN

@interface Teacher : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
+ (NSString *)entityName;

+ (instancetype)insertNewObjectIntoContext:(NSManagedObjectContext *)context;
@end

NS_ASSUME_NONNULL_END

#import "Teacher+CoreDataProperties.h"
