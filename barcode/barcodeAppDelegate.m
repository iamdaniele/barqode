//
//  barcodeAppDelegate.m
//  barcode
//
//  Created by Daniele Bernardi on 12/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "barcodeAppDelegate.h"
#import "barcodeViewController.h"

@implementation barcodeAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize facebook;

NSString *backend_url = @"http://simple-ice-6778.herokuapp.com/action.php";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
     
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    facebook = [[Facebook alloc] initWithAppId:@"182118915212109" andDelegate:self];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    
    if (![facebook isSessionValid]) {
        NSArray *permissions = [[NSArray alloc] initWithObjects:
                                @"publish_actions", 
                                @"offline_access", nil];
        [facebook authorize:permissions];
        [permissions release];
    }
    else {
        NSLog(@"Session valid, logged in.");
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

// Pre 4.2 support
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [facebook handleOpenURL:url]; 
}

// For 4.2+ support
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [facebook handleOpenURL:url]; 
}

- (void)fbDidLogin {
    NSLog(@"Did login");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
}

#pragma mark ZBar
- (void)imagePickerController:(UIImagePickerController *)reader didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    id<NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    
    for (symbol in results) {
        // Just grab the first results
        break;
    }
    
    SBJSON *parser = [[SBJSON alloc] init];
    NSMutableDictionary *data = [parser objectWithString:symbol.data];
    
    
    [_viewController resultText].text = [NSString stringWithFormat:@"You spotted a %@ (%@)", 
                       [data objectForKey:@"type"], [data objectForKey:@"_id"]];
    NSLog([_viewController resultText].text);
    
    [_viewController resultImage].image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [parser release];
    [reader dismissModalViewControllerAnimated:YES];
    
    
    NSString *object_url = [NSString stringWithFormat:@"%@?id=%@",
                            backend_url, [data objectForKey:@"_id"]];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                   object_url, [data objectForKey:@"type"],
                                   nil];
    
    [facebook requestWithGraphPath:@"me/scanmefriendme:see" 
                         andParams:params
                     andHttpMethod:@"POST"
                       andDelegate:self];
        
    //    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
    //                                   resultText.text, @"id",
    //                                   @"touch", @"display",
    //                                   nil];
    //    
    //    [[FacebookStatic instance] dialog:@"friends" andParams:params andDelegate:self];
    
    
}

/**
 * Called when an error prevents the request from completing successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
    NSLog(error);
}

/**
 * Called when a request returns and its response has been parsed into
 * an object.
 *
 * The resulting object may be a dictionary, an array, a string, or a number,
 * depending on thee format of the API response.
 */
- (void)request:(FBRequest *)request didLoad:(id)result
{
    NSLog(result);
}

@end
