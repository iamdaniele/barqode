//
//  barcodeViewController.m
//  barcode
//
//  Created by Daniele Bernardi on 12/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "barcodeViewController.h"

@implementation barcodeViewController

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/* protocol */
- (void)imagePickerController:(UIImagePickerController *)reader didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    id<NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    
    for (symbol in results) {
        // Just grab the first results
        break;
    }
    
    resultText.text = symbol.data;
    resultImage.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [reader dismissModalViewControllerAnimated:YES];

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   resultText.text, @"id",
                                   @"touch", @"display",
                                   nil];
    
    [[FacebookStatic instance] dialog:@"friends" andParams:params andDelegate:self];

}

@synthesize resultImage, resultText;

- (IBAction) scanButtonTapped
{
    // ADD: present a barcode reader that scans from the camera feed
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = reader.scanner;
    // TODO: (optional) additional reader configuration here
    
    // EXAMPLE: disable rarely used I2/5 to improve performance
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    // present and release the controller
    [self presentModalViewController: reader
                            animated: YES];
    [reader release];
}

- (void) dealloc
{
    self.resultImage = nil;
    self.resultText = nil;
    [super dealloc];
}

@end
