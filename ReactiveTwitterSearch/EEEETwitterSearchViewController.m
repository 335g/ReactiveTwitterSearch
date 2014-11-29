//
//  EEEETwitterSearchViewController.m
//  ReactiveTwitterSearch
//
//  Created by Yoshiki Kudo on 2014/11/24.
//  Copyright (c) 2014年 Yoshiki Kudo. All rights reserved.
//

#import "EEEETwitterSearchViewController.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "RACEXTScope.h"

#import "EEEETwitterSearchViewModel.h"

#import "EEEETwitterSearchResultViewController.h"
#import "EEEETwitterSearchResultViewModel.h"
#import "EEEETwitterIconImageView.h"

@import Accounts;

@interface EEEETwitterSearchViewController ()
<
UISearchBarDelegate
>

@property (nonatomic) EEEETwitterSearchViewModel *viewModel;
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;

- (void)search;
@end

@implementation EEEETwitterSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // ************
    // View Model
    // ************
    if (!self.viewModel) {
        self.viewModel = [[EEEETwitterSearchViewModel alloc] init];
    }
    
    // ************
    // Binding
    // ************
    
    // self.viewModel.searchText == self.searchBar.text
    RAC(self.viewModel, searchText) = [[self rac_signalForSelector:@selector(searchBar:textDidChange:)
                                                      fromProtocol:@protocol(UISearchBarDelegate)]
                                        map:^id (RACTuple *tuple){
                                            UISearchBar *searchBar = tuple.first;
                                            return searchBar.text;
                                        }];
    
    // appDelegate.networkActivityIndicatorVisible == self.viewModel.searching
    RAC([UIApplication sharedApplication], networkActivityIndicatorVisible) = RACObserve(self.viewModel, searching);
    
    // self.searchBar.userInteractionEnabled == !self.viewModel.searching
    RAC(self.searchBar, userInteractionEnabled) = [RACObserve(self.viewModel, searching) not];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private
- (void)search {
    
    @weakify(self);
    
    // search
    [[[self.viewModel search]
      deliverOn:[RACScheduler mainThreadScheduler]]
      subscribeNext:^(NSDictionary *responseData){
         
         // 検索完了
         @strongify(self);
         
         EEEETwitterSearchResultViewModel *viewModel;
         viewModel = [[EEEETwitterSearchResultViewModel alloc] initWithSearchResultData:responseData];
         
         NSString *className = NSStringFromClass([EEEETwitterSearchResultViewController class]);
         UIStoryboard *storyboard = [UIStoryboard storyboardWithName:className bundle:nil];
         
         EEEETwitterSearchResultViewController *vc;
         vc              = [storyboard instantiateInitialViewController];
         vc.title        = self.viewModel.searchText;
         vc.viewModel    = viewModel;
         
         [self.navigationController pushViewController:vc animated:YES];
         
      } error:^(NSError *err){
         // アクティブアカウント無い or レスポンスエラー
         if (err.code == EEEETwitterSearchViewModelSearchErrorNoActiveAccount) {
             // アクティブアカウント無い
             
         }else if (err.code == EEEETwitterSearchViewModelSearchErrorInvalidResponse) {
             // レスポンスエラー
             
         }
         NSLog(@"error:%@", err);
      }];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
    
    @weakify(self);
    
    if (!self.viewModel.activeAccount) {
        [[self.viewModel twitterAccountRequested]
          subscribeNext:^(NSArray *accounts){
              
              UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Twitter Accounts"
                                                                                       message:@"検索に使用するアカウントを選んでください"
                                                                                preferredStyle:UIAlertControllerStyleActionSheet];
              for (ACAccount *account in accounts) {
                  [alertController addAction:[UIAlertAction actionWithTitle:account.username
                                                                      style:UIAlertActionStyleDefault
                                                                    handler:^(UIAlertAction *action){
                                                                        @strongify(self);
                                                                        [[self.viewModel activateActiveAccount:account]
                                                                          subscribeCompleted:^{
                                                                              NSLog(@"activated account:%@", account);
                                                                              [self search];
                                                                          }];
                                                                    }]];
              }
              
              [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                                  style:UIAlertActionStyleCancel
                                                                handler:^(UIAlertAction *action){
                                                                    
                                                                }]];
              
              [self presentViewController:alertController
                                 animated:YES
                               completion:nil];
              
          } error:^(NSError *err){
              
              // 承認得られず or アカウント無い
              NSLog(@"%@", err);
              
              if (err.code == EEEETwitterSearchViewModelSearchErrorAccessDenied) {
                  // 承認得られず
                  
              }else if (err.code == EEEETwitterSearchViewModelSearchErrorNoTwitterAccounts) {
                  // アカウント無い
                  
              }
              
          }];
    
    } else {
        [self search];
    }
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

@end
