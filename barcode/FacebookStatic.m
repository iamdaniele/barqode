//
//  FacebookStatic.m
//  barcode
//
//  Created by Daniele Bernardi on 12/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "FacebookStatic.h"

@implementation FacebookStatic
static Facebook *facebook;
@synthesize facebook;

+ (Facebook *)initWithAppId:(NSString *)appId andDelegate:(id<FBSessionDelegate>)delegate
{
    
    if(!facebook) {
        facebook = [[Facebook alloc] initWithAppId:appId andDelegate:delegate];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults objectForKey:@"FBAccessTokenKey"] 
            && [defaults objectForKey:@"FBExpirationDateKey"]) {
            facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
            facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
        }
        
        if (![facebook isSessionValid]) {
            [facebook authorize:nil];
        }    
    }
    
    return facebook;
}

+ (Facebook *)instance {
    return facebook;
}

@end
