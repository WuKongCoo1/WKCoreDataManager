//
//  WKCoreDataManager.h
//  CoreDataExample
//
//  Created by 吴珂 on 15/12/23.
//  Copyright © 2015年 MyCompany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface WKCoreDataManager : NSObject
{
    @private
    NSPersistentStoreCoordinator *_persistentStoreCoordinator;
    NSString *_managedObjectModel;
    NSString *_dataBaseName;
}

@property (strong, nonatomic, readonly) NSManagedObjectContext *mainThreadContext;

@property (strong, nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic, readonly) NSString *managedObjectModel;

@property (strong, nonatomic, readonly) NSString *dataBaseName;

+ (instancetype)sharedDataManager;

- (instancetype)initWithManagedObjectModelName:(NSString *)managedObjectModel dataBaseName:(NSString *)dataBaseName;

- (NSManagedObjectContext *)createPrivateThreadContext;

- (void)save;

@end
