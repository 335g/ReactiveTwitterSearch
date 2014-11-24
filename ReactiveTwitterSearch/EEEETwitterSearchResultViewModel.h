//
//  EEEETwitterSearchResultViewModel.h
//  ReactiveTwitterSearch
//
//  Created by Yoshiki Kudo on 2014/11/24.
//  Copyright (c) 2014年 Yoshiki Kudo. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RACSignal;

@interface EEEETwitterSearchResultViewModel : NSObject
@property (nonatomic, readonly) NSArray *tweets;

- (instancetype)initWithSearchResultData:(NSDictionary *)data;
- (RACSignal *)loadImageSignal:(NSString *)profileImageUrl;

@end
