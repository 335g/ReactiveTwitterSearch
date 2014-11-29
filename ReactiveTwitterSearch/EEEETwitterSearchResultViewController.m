//
//  EEEETwitterSearchResultViewController.m
//  ReactiveTwitterSearch
//
//  Created by Yoshiki Kudo on 2014/11/24.
//  Copyright (c) 2014年 Yoshiki Kudo. All rights reserved.
//

#import "EEEETwitterSearchResultViewController.h"
#import "EEEETwitterSearchResultViewModel.h"

#import "EEEETwitterSearchResultTableViewCell.h"
#import "EEEETwitterIconImageView.h"
#import "EEEETweet.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "RACEXTScope.h"

@interface EEEETwitterSearchResultViewController ()
<
UITableViewDataSource
>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end

@implementation EEEETwitterSearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EEEETwitterSearchResultTableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"TwitterSearchResult"];
    
    EEEETweet *tweet = self.viewModel.tweets[indexPath.row];
    
    cell.icon.image = nil;
    cell.screenName.text = [NSString stringWithFormat:@"@%@", tweet.screenName];
    cell.name.text = tweet.name;
    cell.tweet.text = tweet.text;
    
    @weakify(cell);
    [[[self.viewModel loadImageSignal:tweet.profileImageUrl]
      deliverOn:[RACScheduler mainThreadScheduler]]
      subscribeNext:^(UIImage *image){
          @strongify(cell);
          cell.icon.image = image;
      }];
    
    return cell;
}

@end
