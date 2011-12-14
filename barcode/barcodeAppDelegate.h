//
//  barcodeAppDelegate.h
//  barcode
//
//  Created by Daniele Bernardi on 12/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"

@class barcodeViewController;

@interface barcodeAppDelegate : NSObject 
<UIApplicationDelegate, 
ZBarReaderDelegate, 
FBRequestDelegate,
FBSessionDelegate,
FBDialogDelegate> {
    Facebook *facebook;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet barcodeViewController *viewController;
@property (nonatomic, retain) Facebook *facebook;
@end
