//
//  EEEETwitterSearchViewModel.m
//  ReactiveTwitterSearch
//
//  Created by Yoshiki Kudo on 2014/11/24.
//  Copyright (c) 2014年 Yoshiki Kudo. All rights reserved.
//

#import "EEEETwitterSearchViewModel.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "RACEXTScope.h"

@import Accounts;
@import Social;

static NSString *kEEEETwitterSearchViewModelSearchInstantDomain = @"kEEEETwitterSearchViewModelSearchInstantDomain";

@interface EEEETwitterSearchViewModel ()
@property (nonatomic) NSString *searchText;
@property (nonatomic) BOOL searching;

@property (nonatomic) ACAccountStore *accountStore;
@property (nonatomic) ACAccountType *accountType;
@property (nonatomic) ACAccount *activeAccount;

@property (nonatomic) RACSignal *twitterAccountRequested;

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
    
    self.accountStore   = [[ACAccountStore alloc] init];
    self.accountType    = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    @weakify(self);
    self.twitterAccountRequested = [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber){
        
        @strongify(self);
        [self.accountStore requestAccessToAccountsWithType:self.accountType
                                                   options:nil
                                                completion:^(BOOL granted, NSError *error){
                                                    
                                                    if (granted) {
                                                        
                                                        @strongify(self);
                                                        NSArray *accounts = [self.accountStore accountsWithAccountType:self.accountType];
                                                        if (accounts.count == 0) {
                                                            
                                                            NSError *noAccountErr = [NSError errorWithDomain:kEEEETwitterSearchViewModelSearchInstantDomain
                                                                                                        code:EEEETwitterSearchViewModelSearchErrorNoTwitterAccounts
                                                                                                    userInfo:nil];
                                                            
                                                            [subscriber sendError:noAccountErr];
                                                            
                                                        }else {
                                                            [subscriber sendNext:accounts];
                                                            [subscriber sendCompleted];
                                                        }
                                                        
                                                    }else {
                                                        
                                                        NSError *accessError = [NSError errorWithDomain:kEEEETwitterSearchViewModelSearchInstantDomain
                                                                                                   code:EEEETwitterSearchViewModelSearchErrorAccessDenied
                                                                                               userInfo:nil];
                                                        
                                                        [subscriber sendError:accessError];
                                                    }
                                                }];
        return nil;
    }];
}

#pragma mark - Public
- (RACSignal *)activateActiveAccount:(ACAccount *)account {
    
    return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber){
        
        if ([account isKindOfClass:[ACAccount class]]) {
            self.activeAccount = account;
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        }else {
            [subscriber sendError:nil];
        }
        
        return nil;
    }];
}

- (RACSignal *)search {
    
    self.searching = YES;
    
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber){
        @strongify(self);
        
        if (!self.activeAccount) {
            NSError *noActiveAccountErr = [NSError errorWithDomain:kEEEETwitterSearchViewModelSearchInstantDomain
                                                              code:EEEETwitterSearchViewModelSearchErrorNoActiveAccount
                                                          userInfo:nil];
            
            self.searching = NO;
            [subscriber sendError:noActiveAccountErr];
        }
        
        NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/search/tweets.json"];
        NSDictionary *params = @{@"q": self.searchText};
        
        SLRequest *request =  [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                 requestMethod:SLRequestMethodGET
                                                           URL:url
                                                    parameters:params];
        [request setAccount:self.activeAccount];
        [request performRequestWithHandler: ^(NSData *responseData,
                                              NSHTTPURLResponse *urlResponse,
                                              NSError *error) {
            
            if (urlResponse.statusCode == 200) {
                
                NSDictionary *timelineData =
                [NSJSONSerialization JSONObjectWithData:responseData
                                                options:NSJSONReadingAllowFragments
                                                  error:nil];
                
                @strongify(self);
                self.searching = NO;
                [subscriber sendNext:timelineData];
                [subscriber sendCompleted];
            }
            else {
                
                NSError *invalidResponseErr = [NSError errorWithDomain:kEEEETwitterSearchViewModelSearchInstantDomain
                                                                  code:EEEETwitterSearchViewModelSearchErrorInvalidResponse
                                                              userInfo:nil];
                
                @strongify(self);
                self.searching = NO;
                [subscriber sendError:invalidResponseErr];
            }
        }];
        
        return nil;
    }];
}

@end
