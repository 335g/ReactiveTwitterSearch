//
//  EEEETwitterSearchViewModel.m
//  ReactiveTwitterSearch
//
//  Created by Yoshiki Kudo on 2014/11/24.
//  Copyright (c) 2014年 Yoshiki Kudo. All rights reserved.
//

#import "EEEETwitterSearchViewModel.h"
#import "EEEETwitterSearchServices.h"
#import "EEEETwitterSearch.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "RACEXTScope.h"

@interface EEEETwitterSearchViewModel ()
@property (nonatomic) EEEETwitterSearchServices *services;
@property (nonatomic) NSString *searchText;
@property (nonatomic) BOOL searching;

- (void)initialize;
@end

@implementation EEEETwitterSearchViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.services = [[EEEETwitterSearchServices alloc] init];
}

#pragma mark - Public
- (RACSignal *)requestTwitterAccount {
    
    id <EEEETwitterSearch> service = [self.services twitterSearchService];
    return [service requestAccessToTwitterSignal];
}

- (RACSignal *)search {
    
    self.searching = YES;
    
    @weakify(self);
    id <EEEETwitterSearch> service = [self.services twitterSearchService];
    return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber){
        
        [[service searchSignalWithText:self.searchText]
         subscribeNext:^(NSDictionary *responseData){
             @strongify(self);
             self.searching = NO;
             [subscriber sendNext:responseData];
             
         } error:^(NSError *err){
             @strongify(self);
             self.searching = NO;
             [subscriber sendError:err];
             
         }];
        
        return nil;
    }];
}

@end
