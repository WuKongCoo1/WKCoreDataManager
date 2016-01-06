//
//  Teacher.m
//  CoreDataExample
//
//  Created by 吴珂 on 15/12/26.
//  Copyright © 2015年 MyCompany. All rights reserved.
//

#import "Teacher.h"
#import "Course.h"

@implementation Teacher

// Insert code here to add functionality to your managed object subclass
+ (NSString *)entityName
{
    return @"Teacher";
}

+ (instancetype)insertNewObjectIntoContext:(NSManagedObjectContext *)context
{
    return [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:context];

}

-(NSString *)description
{
    return self.name;
}

@end
