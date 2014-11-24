//
//  EEEETweet.m
//  ReactiveTwitterSearch
//
//  Created by Yoshiki Kudo on 2014/11/24.
//  Copyright (c) 2014年 Yoshiki Kudo. All rights reserved.
//

#import "EEEETweet.h"

@interface EEEETweet ()
@property (nonatomic) NSString *screenName;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *profileImageUrl;
@property (nonatomic) NSString *text;

@end

@implementation EEEETweet

+ (instancetype)tweetWithStatus:(NSDictionary *)status {
    
    NSDictionary *user = status[@"user"];
    
    EEEETweet *tweet;
    tweet                   = [EEEETweet new];
    tweet.text              = status[@"text"];
    tweet.profileImageUrl   = user[@"profile_image_url"];
    tweet.screenName        = user[@"screen_name"];
    tweet.name              = user[@"name"];
    
    return tweet;
}
@end
