//
//  EEEETweet.h
//  ReactiveTwitterSearch
//
//  Created by Yoshiki Kudo on 2014/11/24.
//  Copyright (c) 2014年 Yoshiki Kudo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EEEETweet : NSObject

@property (nonatomic, readonly) NSString *screenName;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *profileImageUrl;
@property (nonatomic, readonly) NSString *text;

+ (instancetype)tweetWithStatus:(NSDictionary *)status;

@end
