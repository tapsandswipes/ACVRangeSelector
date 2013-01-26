//
//  ACVViewController.m
//  RangeSelectorSample
//
//  Created by Antonio Cabezuelo Vivo on 26/01/13.
//  Copyright (c) 2013 Antonio Cabezuelo Vivo. All rights reserved.
//

#import "ACVViewController.h"

@interface ACVViewController ()

@end

@implementation ACVViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    ACVRangeSelector *rs = [[ACVRangeSelector alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.rangeSelector.frame), CGRectGetMaxY(self.rightLabel.frame)+50, CGRectGetWidth(self.rangeSelector.frame), 40)];
    [rs setLeftThumbImage:[UIImage imageNamed:@"left-handle"] forState:UIControlStateNormal];
    [rs setRightThumbImage:[UIImage imageNamed:@"right-handle"] forState:UIControlStateNormal];
    [rs setMiddleThumbImage:[UIImage imageNamed:@"middle-handle"] forState:UIControlStateNormal];
    [rs setConnectionImage:[UIImage imageNamed:@"connector"] forState:UIControlStateNormal];
    rs.scaleMiddleThumb = NO;
    rs.leftPointerOffset = 17;
    rs.rightPointerOffset = 17;
    rs.connectionOffset = 0;
    [self.view addSubview:rs];
}


- (IBAction)rangeChanged:(ACVRangeSelector *)sender {
    self.leftLabel.text = [NSString stringWithFormat:@"Left: %.2f", sender.leftValue];
    self.rightLabel.text = [NSString stringWithFormat:@"Right: %.2f", sender.rightValue];
    self.centerLabel.text = [NSString stringWithFormat:@"Middle: %.2f", sender.middleValue];
}
@end
