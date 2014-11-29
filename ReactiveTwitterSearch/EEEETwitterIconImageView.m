//
//  EEEETwitterIconImageView.m
//  ReactiveTwitterSearch
//
//  Created by Yoshiki Kudo on 2014/11/29.
//  Copyright (c) 2014年 Yoshiki Kudo. All rights reserved.
//

#import "EEEETwitterIconImageView.h"

@import QuartzCore;

@interface EEEETwitterIconBorderView ()

- (void)initialize;
@end

@implementation EEEETwitterIconBorderView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.cornerR = 0;
    self.lineWidth = 1;
    self.layer.cornerRadius = self.cornerR;
    self.clipsToBounds = YES;
    
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    CGFloat hLineWidth = self.lineWidth * 0.5;
    CGPathMoveToPoint(path, NULL, hLineWidth, hLineWidth + _cornerR);
    CGPathAddArcToPoint(path, NULL, hLineWidth, hLineWidth, hLineWidth + _cornerR, hLineWidth, _cornerR);
    CGPathAddLineToPoint(path, NULL, width - hLineWidth - _cornerR, hLineWidth);
    CGPathAddArcToPoint(path, NULL, width - hLineWidth, hLineWidth, width - hLineWidth, hLineWidth + _cornerR, _cornerR);
    CGPathAddLineToPoint(path, NULL, width - hLineWidth, height - hLineWidth - _cornerR);
    CGPathAddArcToPoint(path, NULL, width - hLineWidth, height - hLineWidth, width - hLineWidth - _cornerR, height - hLineWidth, _cornerR);
    CGPathAddLineToPoint(path, NULL, hLineWidth + _cornerR, height - hLineWidth);
    CGPathAddArcToPoint(path, NULL, hLineWidth, height - hLineWidth, hLineWidth, height - hLineWidth - _cornerR, _cornerR);
    CGPathCloseSubpath(path);
    
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.1 alpha:1.0].CGColor);
    CGContextAddPath(context, path);
    CGContextDrawPath(context, kCGPathStroke);
    CGContextRestoreGState(context);
    
    CGPathRelease(path);
}

@end
