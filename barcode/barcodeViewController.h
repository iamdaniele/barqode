//
//  barcodeViewController.h
//  barcode
//
//  Created by Daniele Bernardi on 12/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface barcodeViewController : UIViewController {
    UIImageView *resultImage;
    UITextView *resultText;
}

@property (nonatomic, retain) IBOutlet UIImageView *resultImage;
@property (nonatomic, retain) IBOutlet UITextView *resultText;
- (IBAction) scanButtonTapped;
@end
