//
//  PulsingLayer.h
//  StartAnimation
//
//  Created by Littlebox on 14-7-16.
//  Copyright (c) 2014年 Littlebox. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface PulsingLayer : CALayer

@property (nonatomic, assign) CGFloat radius;                   // default: 60pt
@property (nonatomic, assign) CGFloat fromValueForRadius;       // default: 0.0
@property (nonatomic, assign) CGFloat fromValueForAlpha;        // default: 0.45
@property (nonatomic, assign) CGFloat keyTimeForHalfOpacity;    // default: 0.2 (range: 0 < keyTime < 1)
@property (nonatomic, assign) NSTimeInterval animationDuration; // default: 3s
@property (nonatomic, assign) NSTimeInterval pulseInterval;     // default: 0s
@property (nonatomic, assign) float repeatCount;                // default: INFINITY
@property (nonatomic, assign) BOOL useTimingFunction;           // default: YES should use timingFunction for animation

- (id)initWithRepeatCount:(float)repeatCount;

@end
