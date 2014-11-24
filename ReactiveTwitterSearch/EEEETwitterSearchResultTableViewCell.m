//
//  EEEETwitterSearchResultTableViewCell.m
//  ReactiveTwitterSearch
//
//  Created by Yoshiki Kudo on 2014/11/24.
//  Copyright (c) 2014年 Yoshiki Kudo. All rights reserved.
//

#import "EEEETwitterSearchResultTableViewCell.h"

@implementation EEEETwitterSearchResultTableViewCell

- (void)layoutSubviews {
    
    [self.tweet setNeedsLayout];
    [self.tweet layoutIfNeeded];
    
    [super layoutSubviews];
}

@end
