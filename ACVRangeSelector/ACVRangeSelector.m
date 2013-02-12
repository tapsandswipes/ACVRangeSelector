//
//  RangeSelectControl.m
//  FunBox
//
//  Created by Antonio Cabezuelo Vivo on 28/11/12.
//
//

#import "ACVRangeSelector.h"

#if !__has_feature(objc_arc)
#error ACVRangeSelector must be built with ARC.
// You can turn on ARC for only ACVRangeSelector files by adding -fobjc-arc to the build phase for each of its files.
#endif

#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_5_0
#error ACVRangeSelector needs a deployment target of 5.0+
#endif

static NSString * const kLeftThumbImage = @"leftThumbImage";
static NSString * const kRightThumbImage = @"rightThumbImage";
static NSString * const kMiddleThumbImage = @"middleThumbImage";
static NSString * const kConnectionImage = @"connectionImage";



@interface ACVRangeSelector ()
@property (assign, readonly, nonatomic) CGFloat distance;
@property (strong, nonatomic) NSMutableDictionary* statesData;
@property (weak, nonatomic) UIImageView *leftThumbImageView;
@property (weak, nonatomic) UIImageView *rightThumbImageView;
@property (weak, nonatomic) UIImageView *middleThumbImageView;
@property (weak, nonatomic) UIImageView *leftConnectionImageView;
@property (weak, nonatomic) UIImageView *rightConnectionImageView;
@end


@implementation ACVRangeSelector {
    CGFloat _startTrackingValue;
    CGPoint _startLocation;
}

#pragma mark - Initialization

- (void)commonSetup {
    UIImageView *iV;
    
    self.backgroundColor = [UIColor clearColor];
    _minimumValue = 0;
    _maximumValue = 100;
    _leftValue = 0;
    _rightValue = 100;
    _scaleMiddleThumb = YES;
    
    self.statesData = [[NSMutableDictionary alloc] init];
    
    iV = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:iV];
    self.leftConnectionImageView = iV;
    
    iV = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:iV];
    self.rightConnectionImageView = iV;

    iV = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:iV];
    self.leftThumbImageView = iV;
    
    iV = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:iV];
    self.rightThumbImageView = iV;

    iV = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:iV];
    self.middleThumbImageView = iV;

    NSBundle *selectorBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"ACVRangeSelector" ofType:@"bundle"]];
    
    if (selectorBundle) {
        _leftPointerOffset = 11;
        _rightPointerOffset = 11;
        _connectionOffset = 2;
        
        _trackImage = [[UIImage imageNamed:@"ACVRangeSelector.bundle/Images/track.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 3, 0, 3)];
        
        NSMutableDictionary *data = [self dataForState:UIControlStateNormal create:YES];
        data[kLeftThumbImage] = [UIImage imageNamed:@"ACVRangeSelector.bundle/Images/pointer-handle.png"];
        data[kRightThumbImage] = [UIImage imageNamed:@"ACVRangeSelector.bundle/Images/pointer-handle.png"];
        data[kMiddleThumbImage] = [UIImage imageNamed:@"ACVRangeSelector.bundle/Images/handle.png"];
        data[kConnectionImage] = [[UIImage imageNamed:@"ACVRangeSelector.bundle/Images/connector.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonSetup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
	self = [super initWithCoder: decoder];
	if (self != nil) {
        [self commonSetup];

        if ([decoder containsValueForKey:@"leftValue"])
            self.leftValue = [decoder decodeFloatForKey:@"leftValue"];
        if ([decoder containsValueForKey:@"rightValue"])
            self.rightValue = [decoder decodeFloatForKey:@"rightValue"];
        if ([decoder containsValueForKey:@"middleValue"])
            self.middleValue = [decoder decodeFloatForKey:@"middleValue"];
        if ([decoder containsValueForKey:@"minimumValue"])
            self.minimumValue = [decoder decodeFloatForKey:@"minimumValue"];
        if ([decoder containsValueForKey:@"maximumValue"])
            self.maximumValue = [decoder decodeFloatForKey:@"maximumValue"];
        if ([decoder containsValueForKey:@"leftPointerOffset"])
            self.leftPointerOffset = [decoder decodeFloatForKey:@"leftPointerOffset"];
        if ([decoder containsValueForKey:@"rightPointerOffset"])
            self.rightPointerOffset = [decoder decodeFloatForKey:@"rightPointerOffset"];
        if ([decoder containsValueForKey:@"connectionOffset"])
            self.rightPointerOffset = [decoder decodeFloatForKey:@"connectionOffset"];

	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [super encodeWithCoder:encoder];
    [encoder encodeFloat:self.leftValue forKey:@"leftValue"];
    [encoder encodeFloat:self.rightValue forKey:@"rightValue"];
    [encoder encodeFloat:self.middleValue forKey:@"middleValue"];
    [encoder encodeFloat:self.minimumValue forKey:@"minimumValue"];
    [encoder encodeFloat:self.maximumValue forKey:@"maximumValue"];
    [encoder encodeInteger:self.leftPointerOffset forKey:@"leftPointerOffset"];
    [encoder encodeInteger:self.rightPointerOffset forKey:@"rightPointerOffset"];
    [encoder encodeInteger:self.connectionOffset forKey:@"connectionOffset"];
}

#pragma mark -

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    [self updateUI];
}

- (void)setSelected:(BOOL)selected {
    if (selected != self.isSelected) {
        [super setSelected:selected];
        [self updateUI];
    }
}


- (void)setHighlighted:(BOOL)highlighted {
    if (highlighted != self.isHighlighted) {
        [super setHighlighted:highlighted];
        [self updateUI];
    }
}

#pragma mark - 

- (void)setLeftThumbImage:(UIImage*)image forState:(UIControlState)state {
    NSMutableDictionary *data = [self dataForState:state create:YES];
    if (image) {
        data[kLeftThumbImage] = image;
    } else {
        [data removeObjectForKey:kLeftThumbImage];
    }
        
    [self updateUI];
}

- (void)setRightThumbImage:(UIImage*)image forState:(UIControlState)state {
    NSMutableDictionary *data = [self dataForState:state create:YES];
    if (image) {
        data[kRightThumbImage] = image;
    } else {
        [data removeObjectForKey:kRightThumbImage];
    }
    [self updateUI];
}

- (void)setMiddleThumbImage:(UIImage*)image forState:(UIControlState)state {
    NSMutableDictionary *data = [self dataForState:state create:YES];
    if (image) {
        data[kMiddleThumbImage] = image;
    } else {
        [data removeObjectForKey:kMiddleThumbImage];
    }
    [self updateUI];
}

- (void)setConnectionImage:(UIImage*)image forState:(UIControlState)state {
    NSMutableDictionary *data = [self dataForState:state create:YES];
    if (image) {
        data[kConnectionImage] = image;
    } else {
        [data removeObjectForKey:kConnectionImage];
    }
    [self updateUI];
}

- (UIImage*)leftThumbImageForState:(UIControlState)state {
    UIControlState lookupState = state != UIControlStateHighlighted || (state == UIControlStateHighlighted && self.trackingThumb == TrackingLeftThumb) ? state : UIControlStateNormal;
    return [self dataForState:lookupState][kLeftThumbImage];
}

- (UIImage*)rightThumbImageForState:(UIControlState)state {
    UIControlState lookupState = state != UIControlStateHighlighted || (state == UIControlStateHighlighted && self.trackingThumb == TrackingRightThumb) ? state : UIControlStateNormal;
    return [self dataForState:lookupState][kRightThumbImage];
}

- (UIImage*)middleThumbImageForState:(UIControlState)state {
    UIControlState lookupState = state != UIControlStateHighlighted || (state == UIControlStateHighlighted && self.trackingThumb == TrackingMiddleThumb) ? state : UIControlStateNormal;
    return [self dataForState:lookupState][kMiddleThumbImage];
}

- (UIImage*)connectionImageForState:(UIControlState)state {
    UIControlState lookupState = state != UIControlStateHighlighted ? state : UIControlStateNormal;
    return [self dataForState:lookupState][kConnectionImage];
}


- (void)setLeftValue:(CGFloat)value {
    if (value != self.leftValue) {
        if (value < self.minimumValue)
            value = self.minimumValue;
        
        if (value > self.rightValue)
            value = self.rightValue;
        
        _leftValue = value;
        
        [self setNeedsLayout];
    }
}

- (void)setRightValue:(CGFloat)value {
    if (value != self.rightValue) {
        if (value > self.maximumValue)
            value = self.maximumValue;
        
        if (value < self.leftValue)
            value = self.leftValue;
        
        _rightValue = value;

        [self setNeedsLayout];
    }
}

- (CGFloat)distance {
    return self.rightValue - self.leftValue;
}

- (CGFloat)middleValue {
    return self.leftValue + self.distance/2.0f;
}

- (void)setMiddleValue:(CGFloat)value {
    float offset = self.distance/2.0f;

    value = MAX(MIN(value, self.maximumValue - offset), self.minimumValue + offset);
    
    self.leftValue = value - offset;
    self.rightValue = value + offset;
}


- (void)setMinimumValue:(CGFloat)value {
    _minimumValue = value;
    if (self.leftValue < value) {
        self.leftValue = value;
    }
}

- (void)setMaximumValue:(CGFloat)value {
    _maximumValue = value;
    if (self.rightValue > value) {
        self.rightValue = value;
    }
}

#pragma mark - 

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    [self updateUI];
}

- (NSMutableDictionary*)dataForState:(UIControlState)state {
    return [self dataForState:state create:NO];
}

- (NSMutableDictionary*)dataForState:(UIControlState)state create:(BOOL)create {
    NSMutableDictionary* data = self.statesData[@(state)];
    if (!data && create) {
        data = [[NSMutableDictionary alloc] init];
        self.statesData[@(state)] = data;
    }

    return data;
}


- (NSMutableDictionary*)currentDataForState:(UIControlState)state {
    NSMutableDictionary* data = self.statesData[@(state)];
    if (!data)
        data = self.statesData[@(UIControlStateNormal)];
    
    return data;
}

- (void)updateUI {
    
    NSDictionary *stateData = [self currentDataForState:self.state];
    
    if ( stateData[kLeftThumbImage] != nil && (self.state != UIControlStateHighlighted || (self.state == UIControlStateHighlighted && self.trackingThumb == TrackingLeftThumb))) {
        self.leftThumbImageView.image = stateData[kLeftThumbImage];
    }
    
    if (stateData[kMiddleThumbImage] && (self.state != UIControlStateHighlighted || (self.state == UIControlStateHighlighted && self.trackingThumb == TrackingMiddleThumb))) {
        self.middleThumbImageView.image = stateData[kMiddleThumbImage];
    }
    
    if (stateData[kRightThumbImage] && (self.state != UIControlStateHighlighted || (self.state == UIControlStateHighlighted && self.trackingThumb == TrackingRightThumb))) {
        self.rightThumbImageView.image = stateData[kRightThumbImage];
    }

    if (stateData[kConnectionImage] && self.state != UIControlStateHighlighted) {
        self.leftConnectionImageView.image = stateData[kConnectionImage];
        self.rightConnectionImageView.image = stateData[kConnectionImage];
    }
}


- (float)valueForLocation:(CGPoint)location {
    CGRect r = [self tracRect];
    
    CGFloat newValue = [self minimumValue]+(([self maximumValue]-[self minimumValue])*((location.x - CGRectGetMinX(r)) / CGRectGetWidth(r)));
    
    if (newValue < self.minimumValue)
		newValue = self.minimumValue;
	
	if (newValue > self.maximumValue)
		newValue = self.maximumValue;
    
    return newValue;
}

- (float)locationForValue:(float)value {
    CGRect r = [self tracRect];
    return CGRectGetMinX(r) + (CGRectGetWidth(r) * (value-self.minimumValue) / (self.maximumValue-self.minimumValue));
}


- (CGRect)tracRect {
    return CGRectMake(self.leftPointerOffset, floorf((CGRectGetHeight(self.bounds)-self.trackImage.size.height)/2.0), CGRectGetWidth(self.bounds)-self.leftPointerOffset-self.rightPointerOffset, self.trackImage.size.height);
}


#pragma mark -

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    _startLocation = [touch locationInView:self];
    
    float distanceFromLeft = fabsf(CGRectGetMidX(self.leftThumbImageView.frame)-_startLocation.x);
    float distanceFromRight = fabsf(CGRectGetMidX(self.rightThumbImageView.frame)-_startLocation.x);
    float distanceFromMiddle = fabsf(CGRectGetMidX(self.middleThumbImageView.frame)-_startLocation.x);
    
    if (distanceFromLeft < distanceFromMiddle) {
        if (CGRectContainsPoint(CGRectInset(self.leftThumbImageView.frame, -10, -10), _startLocation)) {
            self.trackingThumb = TrackingLeftThumb;
            _startTrackingValue = self.leftValue;
            return YES;
        }
    } else if (distanceFromRight < distanceFromMiddle) {
        if (CGRectContainsPoint(CGRectInset(self.rightThumbImageView.frame, -10, -10), _startLocation)) {
            self.trackingThumb = TrackingRightThumb;
            _startTrackingValue = self.rightValue;
            return YES;
        }
    } else {
        if (CGRectContainsPoint(CGRectInset(self.middleThumbImageView.frame, -10, -10), _startLocation)) {
            self.trackingThumb = TrackingMiddleThumb;
            _startTrackingValue = self.middleValue;
            return YES;
        }
    }

    self.trackingThumb = TrackingNone;
    return  [super beginTrackingWithTouch:touch withEvent:event];
    
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [touch locationInView:self];

    if (self.trackingThumb == TrackingLeftThumb) {
        self.leftValue = _startTrackingValue + [self valueForLocation:location] - [self valueForLocation:_startLocation];
        [self sendActionsForControlEvents: UIControlEventValueChanged];
        return YES;
    }

    if (self.trackingThumb == TrackingRightThumb) {
        self.rightValue = _startTrackingValue + [self valueForLocation:location] - [self valueForLocation:_startLocation];
        [self sendActionsForControlEvents: UIControlEventValueChanged];
        return YES;
    }
    
    if (self.trackingThumb == TrackingMiddleThumb) {
        self.middleValue = _startTrackingValue + [self valueForLocation:location] - [self valueForLocation:_startLocation];
        [self sendActionsForControlEvents: UIControlEventValueChanged];
        return YES;
    }

    self.trackingThumb = TrackingNone;
    return [super continueTrackingWithTouch:touch withEvent:event];
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    self.trackingThumb = TrackingNone;
    [super endTrackingWithTouch:touch withEvent:event];

}

- (void)cancelTrackingWithEvent:(UIEvent *)event {
    self.trackingThumb = TrackingNone;
    [super cancelTrackingWithEvent:event];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect f = self.leftThumbImageView.frame;
    f.size = self.leftThumbImageView.image.size;
    f.origin.x = floorf([self locationForValue:self.leftValue]-self.leftPointerOffset);
    f.origin.y = floorf((CGRectGetHeight(self.bounds)-CGRectGetHeight(f))/2.0f);
    self.leftThumbImageView.frame = f;
    
    f = self.rightThumbImageView.frame;
    f.size = self.rightThumbImageView.image.size;
    f.origin.x = floorf([self locationForValue:self.rightValue]-(CGRectGetWidth(f)-self.leftPointerOffset));
    f.origin.y = floorf((CGRectGetHeight(self.bounds)-CGRectGetHeight(f))/2.0f);
    self.rightThumbImageView.frame = f;
    
    self.middleThumbImageView.transform = CGAffineTransformIdentity;
    f = self.middleThumbImageView.frame;
    f.size = self.middleThumbImageView.image.size;
    f.origin.x = floorf([self locationForValue:self.middleValue]-CGRectGetWidth(f)/2.0f);
    f.origin.y = floorf((CGRectGetHeight(self.bounds)-CGRectGetHeight(f))/2.0f);
    self.middleThumbImageView.frame = f;
    
    if (self.scaleMiddleThumb) {
        // Scales the middle handle if the left and right handles are too close
        float middleScale = MIN(CGRectGetWidth(f), CGRectGetMinX(self.rightThumbImageView.frame)-CGRectGetMaxX(self.leftThumbImageView.frame))/CGRectGetWidth(f);
        self.middleThumbImageView.transform = CGAffineTransformMakeScale(middleScale, middleScale);
    
        // Hide the middle handle if overlap left handle
        self.middleThumbImageView.hidden = middleScale<0.4f;
    } else {
        // Hides middle handle if overlap with left and right handles
        self.middleThumbImageView.hidden = CGRectGetMaxX(self.leftThumbImageView.frame) > CGRectGetMinX(self.middleThumbImageView.frame) || CGRectGetMinX(self.rightThumbImageView.frame) < CGRectGetMaxX(self.middleThumbImageView.frame);
    }
    
    f = self.leftConnectionImageView.frame;
    f.size = self.leftConnectionImageView.image.size;
    f.origin.x = CGRectGetMaxX(self.leftThumbImageView.frame)-self.connectionOffset;
    f.origin.y = floorf((CGRectGetHeight(self.bounds)-CGRectGetHeight(f))/2.0f);
    if (self.middleThumbImageView.isHidden) {
        f.size.width = CGRectGetMinX(self.rightThumbImageView.frame)-CGRectGetMaxX(self.leftThumbImageView.frame)+self.connectionOffset*2;
    } else {
        f.size.width = CGRectGetMinX(self.middleThumbImageView.frame)-CGRectGetMaxX(self.leftThumbImageView.frame)+self.connectionOffset*2;
    }
    self.leftConnectionImageView.frame = f;
    
    // Hide left connection if the left and the right handles overlap
    self.leftConnectionImageView.hidden = (CGRectGetMinX(self.rightThumbImageView.frame)+self.connectionOffset*2 < CGRectGetMaxX(self.leftThumbImageView.frame));
    
    self.rightConnectionImageView.hidden = self.middleThumbImageView.isHidden;

    if (!self.rightConnectionImageView.isHidden) {
        f = self.rightConnectionImageView.frame;
        f.size = self.rightConnectionImageView.image.size;
        f.origin.x = CGRectGetMaxX(self.middleThumbImageView.frame)-self.connectionOffset;
        f.origin.y = floorf((CGRectGetHeight(self.bounds)-CGRectGetHeight(f))/2.0f);
        f.size.width = CGRectGetMinX(self.rightThumbImageView.frame)-CGRectGetMaxX(self.middleThumbImageView.frame)+self.connectionOffset*2;
        self.rightConnectionImageView.frame = f;
    }
    
}

- (void)drawRect:(CGRect)rect {
    if (self.trackImage) {
        [self.trackImage drawInRect:CGRectInset([self tracRect], -self.trackImage.capInsets.left, 0)];
    }
}

@end
