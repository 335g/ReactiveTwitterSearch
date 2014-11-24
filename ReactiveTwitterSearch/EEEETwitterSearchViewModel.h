//
//  EEEETwitterSearchViewModel.h
//  ReactiveTwitterSearch
//
//  Created by Yoshiki Kudo on 2014/11/24.
//  Copyright (c) 2014年 Yoshiki Kudo. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RACSignal;
@class ACAccount;

@interface EEEETwitterSearchViewModel : NSObject
@property (nonatomic, readonly) NSString *searchText;
@property (nonatomic, readonly) BOOL searching;

- (RACSignal *)requestTwitterAccount;
- (RACSignal *)search;


@end
