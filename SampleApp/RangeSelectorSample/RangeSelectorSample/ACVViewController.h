//
//  ACVViewController.h
//  RangeSelectorSample
//
//  Created by Antonio Cabezuelo Vivo on 26/01/13.
//  Copyright (c) 2013 Antonio Cabezuelo Vivo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACVRangeSelector.h"

@interface ACVViewController : UIViewController
@property (weak, nonatomic) IBOutlet ACVRangeSelector *rangeSelector;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UILabel *centerLabel;

- (IBAction)rangeChanged:(ACVRangeSelector *)sender;
@end
