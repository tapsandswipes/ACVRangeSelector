//
//  RangeSelectControl.h
//  FunBox
//
//  Created by Antonio Cabezuelo Vivo on 28/11/12.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TrackingThumb) {
    TrackingNone,
    TrackingLeftThumb,
    TrackingRightThumb,
    TrackingMiddleThumb,
};


@interface ACVRangeSelector : UIControl

@property (assign, nonatomic) CGFloat minimumValue;  // Defaults to 0
@property (assign, nonatomic) CGFloat maximumValue;  // Defaults to 100

@property (assign, nonatomic) CGFloat leftValue;
@property (assign, nonatomic) CGFloat rightValue;
@property (assign, nonatomic) CGFloat middleValue;

@property (assign, nonatomic) NSInteger leftPointerOffset;  // Distance from the left border to the left ponter 
@property (assign, nonatomic) NSInteger rightPointerOffset; // Distance from the right border to the right pointer
@property (assign, nonatomic) NSInteger connectionOffset;   // Number of points that the connections overlap with handles. Connections are always positioned below the handles.

@property (assign, nonatomic) TrackingThumb trackingThumb;  // The thumb currently being tracked

@property (assign, nonatomic) BOOL scaleMiddleThumb; // If the left and right thumbs overlap middle thumb, this is scaled. Default to YES

@property (strong, nonatomic) UIImage *trackImage UI_APPEARANCE_SELECTOR; // Image to be used for the track background. Should be horizontally resizable

- (void)setLeftThumbImage:(UIImage*)image forState:(UIControlState)state UI_APPEARANCE_SELECTOR;
- (void)setRightThumbImage:(UIImage*)image forState:(UIControlState)state UI_APPEARANCE_SELECTOR;
- (void)setMiddleThumbImage:(UIImage*)image forState:(UIControlState)state UI_APPEARANCE_SELECTOR;
- (void)setConnectionImage:(UIImage*)image forState:(UIControlState)state UI_APPEARANCE_SELECTOR;

- (UIImage*)leftThumbImageForState:(UIControlState)state;
- (UIImage*)rightThumbImageForState:(UIControlState)state;
- (UIImage*)middleThumbImageForState:(UIControlState)state;
- (UIImage*)connectionImageForState:(UIControlState)state;


@end
