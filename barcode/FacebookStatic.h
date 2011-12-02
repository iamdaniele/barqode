//
//  FacebookStatic.h
//  barcode
//
//  Created by Daniele Bernardi on 12/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBConnect.h"

@interface FacebookStatic : NSObject <UIApplicationDelegate, FBSessionDelegate, FBDialogDelegate> {
    Facebook *facebook;
}

@property (nonatomic, retain) Facebook *facebook;

@end
