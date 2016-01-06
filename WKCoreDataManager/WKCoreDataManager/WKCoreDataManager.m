//
//  WKCoreDataManager.m
//  CoreDataExample
//
//  Created by 吴珂 on 15/12/23.
//  Copyright © 2015年 MyCompany. All rights reserved.
//

#import "WKCoreDataManager.h"
#import <objc/runtime.h>


@implementation WKCoreDataManager
{
    NSManagedObjectContext *_mainThreadContext;
}

+ (instancetype)sharedDataManager
{
    static WKCoreDataManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[WKCoreDataManager alloc] init];
        
    });
    
    return manager;
}



- (instancetype)initWithManagedObjectModelName:(NSString *)managedObjectModel dataBaseName:(NSString *)dataBaseName
{
    
    NSManagedObjectContext *mainThreadContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    //...省略创建持久化协调器
    NSManagedObjectContext *privateThreadContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    privateThreadContext.parentContext = mainThreadContext;
    
    
    if (self = [super init]) {
        _managedObjectModel = managedObjectModel;
        _dataBaseName = dataBaseName;
    }
    return self;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    
    
    
    NSString *momPath = [[NSBundle mainBundle] pathForResource:self.managedObjectModel ofType:@"momd"];
    
    NSURL *momUrl = [NSURL URLWithString:momPath];
    
    NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:momUrl];
    
    if (mom == nil) {
        return nil;
    }
    
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    
    NSString *applicationSupportPath = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) firstObject];
    
    
    
    NSString *storePath = [applicationSupportPath stringByAppendingPathComponent:self.managedObjectModel];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if (![fm fileExistsAtPath:storePath]) {
        [fm createDirectoryAtPath:storePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    
    NSURL *storeUrl = [NSURL fileURLWithPath:[storePath stringByAppendingPathComponent:self.dataBaseName]];
    
    NSError *error = nil;
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption : @(YES),
                              NSInferMappingModelAutomaticallyOption : @(YES)
                              };
    
    [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
        return nil;
    }
    NSLog(@"%@", storePath);
    _persistentStoreCoordinator = coordinator;
    return coordinator;
}

- (NSString *)managedObjectModel
{
    if (!_managedObjectModel) {
        _managedObjectModel = @"School";
    }
    return _managedObjectModel;
}

- (NSString *)dataBaseName
{
    if (!_dataBaseName) {
        _dataBaseName  = @"School.sqlite";
    }
    return _dataBaseName;
}

- (NSManagedObjectContext *)mainThreadContext
{
    if (_mainThreadContext) {
        return _mainThreadContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    
    _mainThreadContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    
    _mainThreadContext.persistentStoreCoordinator = coordinator;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(managedObjectContextDidSave:) name:NSManagedObjectContextDidSaveNotification object:nil];
    
    return _mainThreadContext;
}

- (void)managedObjectContextDidSave:(NSNotification *)noti
{
    NSManagedObjectContext *sender = noti.object;
    if (sender != _mainThreadContext && (sender.persistentStoreCoordinator == _mainThreadContext.persistentStoreCoordinator)) {
        dispatch_async(dispatch_get_main_queue(), ^{
            for (NSManagedObject *object  in noti.userInfo[NSUpdatedObjectsKey]) {
                [[_mainThreadContext objectWithID:object.objectID] willAccessValueForKey:nil];
            }
            [_mainThreadContext mergeChangesFromContextDidSaveNotification:noti];
        });
    }
}


- (NSManagedObjectContext *)createPrivateThreadContext
{
    NSManagedObjectContext *privateThreadContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    
    privateThreadContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    
    return  privateThreadContext;
}

//- (void)excute
//{
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Teacher"];
//    
//    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"_pk" ascending:YES selector:@selector(compare:)];
//    fetchRequest.sortDescriptors = @[sortDescriptor];
//    
//    NSError *error;
//    NSArray *results = [self.mainThreadContext executeFetchRequest:fetchRequest error:&error];
//    NSLog(@"%@", results);
//    if (error) {
//        NSLog(@"%@", error);
//    }
//}

- (void)save
{
    

    if ([_mainThreadContext hasChanges]) {
        [_mainThreadContext performBlock:^{
            NSError *error;
            [_mainThreadContext save:&error];
            
            if (error) {
                NSLog(@"保存失败");
            }else{
                NSLog(@"保存成功");
            }
        }];
    }
    
}

@end
