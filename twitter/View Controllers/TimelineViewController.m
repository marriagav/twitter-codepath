//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "DetailsViewController.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "ComposeViewController.h"

@interface TimelineViewController () <ComposeViewControllerDelegate, DetailsViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *_tableView;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self._tableView.dataSource=self;
    self._tableView.delegate=self;
    
    // Get timeline
    [self _getTimeline];
    
    // Initialize a UIRefreshControl
    [self _initializeRefreshControl];
}

- (void)_getTimeline{
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            self.tweetsArray = (NSMutableArray *)tweets;
            [self._tableView reloadData];
        } else {
            NSLog(@"Error getting home timeline: %@", error.localizedDescription);
        }
    }];
}

- (void)_initializeRefreshControl{
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self._tableView insertSubview:refreshControl atIndex:0];
}

- (IBAction)didTapLogout:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    [[APIManager shared] logout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
    (NSInteger)section{
//    return amount of movies in the movieArray
        return self.tweetsArray.count;
    }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
    (NSIndexPath *)indexPath{
//    initialize cell (MovieCell) to a reusable cell using the MovieCell identifier
    TweetCell *cell = [tableView
    dequeueReusableCellWithIdentifier: @"TweetCell"];
    
//    get the movie and assign title and overview to cell accordingly
    Tweet *tweet = self.tweetsArray[indexPath.row];
    cell.tweet=tweet;
    
    return cell;
}

// Hides the RefreshControl
- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            self.tweetsArray = (NSMutableArray *)tweets;
            [self._tableView reloadData];
        } else {
            NSLog(@"Error getting home timeline: %@", error.localizedDescription);
        }
        [refreshControl endRefreshing];
    }];
}

- (void)didTweet:(Tweet *)tweet{
    [self.tweetsArray insertObject:tweet atIndex:0];
    [self._tableView reloadData];
}

- (void)didLike:(Tweet *)tweet{
    [self._tableView reloadData];
    
}

- (void)didRetweet:(Tweet *)tweet{
    [self._tableView reloadData];
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual:@"compTweet"]){
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
    }
    else if ([segue.identifier isEqual:@"detailView"]){
        NSIndexPath *myIndexPath=self._tableView.indexPathForSelectedRow;
        Tweet *tweetToPass = self.tweetsArray[myIndexPath.row];
        UINavigationController *navigationController = [segue destinationViewController];
        DetailsViewController *detailVC = (DetailsViewController*)navigationController.topViewController;
        detailVC.delegate = self;
        detailVC.tweet = tweetToPass;
    }

}


@end
