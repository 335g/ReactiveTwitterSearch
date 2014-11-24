//
//  EEEETwitterSearchResultTableViewCell.h
//  ReactiveTwitterSearch
//
//  Created by Yoshiki Kudo on 2014/11/24.
//  Copyright (c) 2014年 Yoshiki Kudo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EEEETwitterSearchResultTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIImageView *icon;
@property (nonatomic, weak) IBOutlet UILabel *screenName;
@property (nonatomic, weak) IBOutlet UILabel *name;
@property (nonatomic, weak) IBOutlet UILabel *tweet;
@end
