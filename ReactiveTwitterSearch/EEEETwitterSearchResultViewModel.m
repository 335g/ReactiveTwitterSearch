//
//  EEEETwitterSearchResultViewModel.m
//  ReactiveTwitterSearch
//
//  Created by Yoshiki Kudo on 2014/11/24.
//  Copyright (c) 2014年 Yoshiki Kudo. All rights reserved.
//

#import "EEEETwitterSearchResultViewModel.h"
#import "EEEETweet.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface EEEETwitterSearchResultViewModel ()
@property (nonatomic) NSArray *tweets;
- (void)initialize;
@end


@implementation EEEETwitterSearchResultViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithSearchResultData:(NSDictionary *)data {
    self = [super init];
    if (self) {
        
        NSArray *statuses = data[@"statuses"];
        
        NSMutableArray *tweets = [NSMutableArray array];
        for (NSDictionary *status in statuses) {
            [tweets addObject:[EEEETweet tweetWithStatus:status]];
        }
        self.tweets = [NSArray arrayWithArray:tweets];
    }
    return self;
}

- (void)initialize {
    self.tweets = @[];
}

#pragma mark - Public
- (RACSignal *)loadImageSignal:(NSString *)profileImageUrl {
    
    RACScheduler *bgScheduler = [RACScheduler schedulerWithPriority:RACSchedulerPriorityBackground];
    
    return [[RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber){
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:profileImageUrl]];
        UIImage *image = [UIImage imageWithData:data];
        
        [subscriber sendNext:image];
        [subscriber sendCompleted];
        
        return nil;
    }] deliverOn:bgScheduler];
}

@end
