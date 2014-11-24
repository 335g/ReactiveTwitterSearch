//
//  EEEETwitterSearchServices.m
//  ReactiveTwitterSearch
//
//  Created by Yoshiki Kudo on 2014/11/24.
//  Copyright (c) 2014年 Yoshiki Kudo. All rights reserved.
//

#import "EEEETwitterSearchServices.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "RACEXTScope.h"

@import Accounts;
@import Social;

static NSString *kEEEETwitterSearchServicesInstantDomain = @"kEEEETwitterSearchServicesInstantDomain";

#pragma mark - •Interface (EEEETwitterSearchObject)
@interface EEEETwitterSearchObject : NSObject <EEEETwitterSearch>
@property (nonatomic) ACAccountStore *accountStore;
@property (nonatomic) ACAccountType *accountType;
@property (nonatomic) ACAccount *activeAccount;
@end

#pragma mark - •Implementation (EEEETwitterSearchObject)
@implementation EEEETwitterSearchObject
- (RACSignal *)requestAccessToTwitterSignal {
    
    if (!self.accountStore) {
        self.accountStore = [[ACAccountStore alloc] init];
    }
    
    if (!self.accountType) {
        self.accountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    }
    
    NSError *accessError = [NSError errorWithDomain:kEEEETwitterSearchServicesInstantDomain
                                               code:EEEETwitterSearchErrorAccessDenied
                                           userInfo:nil];
    
    @weakify(self);
    RACSignal *requestSignal = [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber){
        @strongify(self);
        
        [self.accountStore requestAccessToAccountsWithType:self.accountType
                                                   options:nil
                                                completion:^(BOOL granted, NSError *error){
                                                    
                                                    if (granted) {
                                                        
                                                        NSError *noAccountErr = [NSError errorWithDomain:kEEEETwitterSearchServicesInstantDomain
                                                                                                    code:EEEETwitterSearchErrorNoTwitterAccounts
                                                                                                userInfo:nil];
                                                        
                                                        NSArray *accounts = [self.accountStore accountsWithAccountType:self.accountType];
                                                        if (accounts.count == 0) {
                                                            [subscriber sendError:noAccountErr];
                                                        
                                                        }else {
                                                            self.activeAccount = [accounts firstObject];
                                                            [subscriber sendNext:nil];
                                                            [subscriber sendCompleted];
                                                        }
                                                        
                                                    }else {
                                                        [subscriber sendError:accessError];
                                                    }
                                                }];
        return nil;
    }];
    
    return requestSignal;
}

- (RACSignal *)searchSignalWithText:(NSString *)text {
    
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber){
        @strongify(self);
        
        NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/search/tweets.json"];
        NSDictionary *params = @{@"q": text};
        
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
                [subscriber sendNext:timelineData];
                [subscriber sendCompleted];
            }
            else {
                
                NSError *invalidResponseErr = [NSError errorWithDomain:kEEEETwitterSearchServicesInstantDomain
                                                                  code:EEEETwitterSearchErrorInvalidResponse
                                                              userInfo:nil];
                
                [subscriber sendError:invalidResponseErr];
            }
        }];
        
        return nil;
    }];
}
@end

#pragma mark - •Class Ext (EEEETwitterSearchServices)
@interface EEEETwitterSearchServices ()
@property (nonatomic) EEEETwitterSearchObject *twitterSearchObj;
@end

#pragma mark - •Implementation (EEEETwitterSearchServices)
@implementation EEEETwitterSearchServices

- (instancetype)init {
    self = [super init];
    if (self) {
        self.twitterSearchObj = [EEEETwitterSearchObject new];
    }
    return self;
}

- (id<EEEETwitterSearch>)twitterSearchService {
    return self.twitterSearchObj;
}
@end
