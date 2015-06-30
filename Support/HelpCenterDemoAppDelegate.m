//
//  AppDelegate.m
//  HelpCenterDemo
//
//  Created by Sun Jin on 15/1/9.
//  Copyright (c) 2015年 ilegendsoft. All rights reserved.
//

#import "HelpCenterDemoAppDelegate.h"
#import "LASHelpCenter.h"
#import <ILSLog/ILSLogger.h>

@interface HelpCenterDemoAppDelegate ()

@end

@implementation HelpCenterDemoAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[ILSLogger sharedLogger]configureWithLogLevel:ILSLogLevelInfo domainWhiteList:nil bonjourName:LOGGER_TARGET];
    
    NSString *env = nil;
    NSDictionary *appConfig = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"ilsAppConfig"];
    if ([appConfig isKindOfClass:[NSDictionary class]]) {
        env = [appConfig valueForKeyPath:@"appInfo.ILSConnectEnvironment"];
    }
    BOOL isProd = !([env isEqualToString:@"dev"] || [env isEqualToString:@"uat"]);
    if (isProd) {
        [LAS setApplicationId:@"551110f460b208c7c0ce0e0e" clientKey:@"VREQ9GCynXBFTtrGAg"];
    } else {
        [LAS setApplicationId:@"5511103d91b02798823b88e8" clientKey:@"VREQPZGwXQ-VJfOaAg"];
    }
    [LASHelpCenter install];
    [LASHelpCenter alertNewMessage:YES];
    
//    [self printPreferredLanguages];
//    [self printAllAvailableLanguageIdentifiers];
    
    return YES;
}

- (void)printPreferredLanguages {
    
    NSArray *langs = [NSLocale preferredLanguages];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (int index = 0; index < langs.count; index ++) {
        NSString *langCode = langs[index];
        NSString *langName = [[NSLocale currentLocale] displayNameForKey:NSLocaleIdentifier value:langCode];;
        dict[langCode] = langName?:[NSNull null];
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:NULL];
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@ \njson: %@, \n ", dict, json);
}

- (void)printAllAvailableLanguageIdentifiers {
    
    NSMutableArray *availableLangIds = [[NSLocale availableLocaleIdentifiers] mutableCopy];
    
    NSDate *date = [NSDate date];
    
    for (int i = 0; i < availableLangIds.count; i ++) {
        
        for (int j = i +1; j < availableLangIds.count; j ++) {
            
            if ([availableLangIds[i] compare:availableLangIds[j] options:NSCaseInsensitiveSearch] != NSOrderedAscending) {
                [availableLangIds exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }
    
    NSLog(@"spend %f millisecond to sort language id list", - [date timeIntervalSinceNow] * 1000);
    
    NSMutableDictionary *allLangIdsMap = [NSMutableDictionary dictionary];
    for (int index = 0; index < availableLangIds.count; index ++) {
        NSString *langCode = availableLangIds[index];
        NSString *langName = [[NSLocale currentLocale] displayNameForKey:NSLocaleIdentifier value:langCode];;
        allLangIdsMap[langCode] = langName?:[NSNull null];
    }
    NSMutableString *allLangIdsJson = [NSMutableString stringWithString:@"{"];
    for (NSString *key in availableLangIds) {
        [allLangIdsJson appendFormat:@"\"%@\":\"%@\",", key, allLangIdsMap[key]];
    }
    [allLangIdsJson deleteCharactersInRange:NSMakeRange(allLangIdsJson.length -1, 1)];
    [allLangIdsJson appendString:@"}"];
    
    NSLog(@"available languages: %@ count = %lu, \njson: %@", allLangIdsMap, (unsigned long)availableLangIds.count, allLangIdsJson);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
