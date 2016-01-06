//
//  Course.m
//  CoreDataExample
//
//  Created by 吴珂 on 15/12/26.
//  Copyright © 2015年 MyCompany. All rights reserved.
//

#import "Course.h"
#import "Teacher.h"

@implementation Course

// Insert code here to add functionality to your managed object subclass
+ (NSString *)entityName
{
    return @"Course";
}

+ (instancetype)insertNewObjectIntoContext:(NSManagedObjectContext *)context
{
    return [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:context];
    
}
- (NSString *)description
{
    return self.name;
}

@end
