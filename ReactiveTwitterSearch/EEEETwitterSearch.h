//
//  EEEETwitterSearch.h
//  ReactiveTwitterSearch
//
//  Created by Yoshiki Kudo on 2014/11/24.
//  Copyright (c) 2014年 Yoshiki Kudo. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RACSignal;
@class NSString;

typedef NS_ENUM(NSInteger, EEEETwitterSearchError) {
    EEEETwitterSearchErrorAccessDenied          = 0,
    EEEETwitterSearchErrorNoTwitterAccounts     = 1,
    EEEETwitterSearchErrorInvalidResponse       = 2
};

@protocol EEEETwitterSearch <NSObject>
- (RACSignal *)requestAccessToTwitterSignal;
- (RACSignal *)searchSignalWithText:(NSString *)text;

@end
