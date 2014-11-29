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

typedef NS_ENUM(NSInteger, EEEETwitterSearchViewModelSearchError) {
    EEEETwitterSearchViewModelSearchErrorAccessDenied       = 0,
    EEEETwitterSearchViewModelSearchErrorNoTwitterAccounts  = 1,
    EEEETwitterSearchViewModelSearchErrorInvalidResponse    = 2,
    EEEETwitterSearchViewModelSearchErrorNoActiveAccount    = 3
};

@interface EEEETwitterSearchViewModel : NSObject
@property (nonatomic, readonly) NSString *searchText;
@property (nonatomic, readonly) BOOL searching;
@property (nonatomic, readonly) ACAccount *activeAccount;
@property (nonatomic, readonly) RACSignal *twitterAccountRequested;

- (RACSignal *)activateActiveAccount:(ACAccount *)account;
- (RACSignal *)search;
@end
