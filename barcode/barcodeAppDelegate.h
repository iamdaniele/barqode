//
//  barcodeAppDelegate.h
//  barcode
//
//  Created by Daniele Bernardi on 12/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class barcodeViewController;

@interface barcodeAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet barcodeViewController *viewController;

@end
