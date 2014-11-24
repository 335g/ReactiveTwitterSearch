//
//  EEEETwitterSearchServices.h
//  ReactiveTwitterSearch
//
//  Created by Yoshiki Kudo on 2014/11/24.
//  Copyright (c) 2014年 Yoshiki Kudo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EEEETwitterSearch.h"

@interface EEEETwitterSearchServices : NSObject

- (id <EEEETwitterSearch>)twitterSearchService;

@end
