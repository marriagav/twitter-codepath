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
#import "ProfileViewController.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "ComposeViewController.h"
#import "InfiniteScrollActivityView.h"

@interface TimelineViewController () <ComposeViewControllerDelegate, DetailsViewControllerDelegate, TweetCellDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *_tableView;
@property (assign, nonatomic) BOOL _isMoreDataLoading;

@end

@implementation TimelineViewController

bool _isMoreDataLoading = false;
InfiniteScrollActivityView* _loadingMoreView;

- (void)viewDidLoad {
    [super viewDidLoad];
//  Initiallize delegate and datasource of the tableview to self
    self._tableView.dataSource=self;
    self._tableView.delegate=self;
    // Get timeline
    [self _getTimeline];
    // Initialize a UIRefreshControl
    [self _initializeRefreshControl];
    // Initialize a UIRefreshControlBottom
    [self _initializeRefreshControlB];
}

- (void)_getTimeline{
//    Retrieves tweets from the api
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
//            Tweets retrieves succesfully
            self.tweetsArray = (NSMutableArray *)tweets;
            [self._tableView reloadData];
        } else {
//            Error
            NSLog(@"Error getting home timeline: %@", error.localizedDescription);
        }
    }];
}

- (void)_initializeRefreshControl{
//    Initialices and inserts the refresh control
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self._tableView insertSubview:refreshControl atIndex:0];
}

- (void)_initializeRefreshControlB{
//    Initialices and inserts the refresh control
    // Set up Infinite Scroll loading indicator
    CGRect frame = CGRectMake(0, self._tableView.contentSize.height, self._tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
    _loadingMoreView = [[InfiniteScrollActivityView alloc] initWithFrame:frame];
    _loadingMoreView.hidden = true;
    [self._tableView addSubview:_loadingMoreView];
    
    UIEdgeInsets insets = self._tableView.contentInset;
    insets.bottom += InfiniteScrollActivityView.defaultHeight;
    self._tableView.contentInset = insets;
}

- (IBAction)didTapLogout:(id)sender {
//  Method gets called when the user presses logout button, logging the user out and returning to login screen
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    [[APIManager shared] logout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
    (NSInteger)section{
//    return amount of tweets in the tweetArray
        return self.tweetsArray.count;
    }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
    (NSIndexPath *)indexPath{
//    initialize cell (TweetCell) to a reusable cell using the TweetCell identifier
    TweetCell *cell = [tableView
    dequeueReusableCellWithIdentifier: @"TweetCell"];
//    get the tweet and assign it to the cell
    Tweet *tweet = self.tweetsArray[indexPath.row];
    cell.tweet=tweet;
    cell.delegate = self;
    return cell;
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
//    Gets called when the user refreshes the timeline, the API call is made and then the refreshControl ends its animation
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
//            successfull api call
            self.tweetsArray = (NSMutableArray *)tweets;
            [self._tableView reloadData];
        } else {
//            error
            NSLog(@"Error getting home timeline: %@", error.localizedDescription);
        }
        [refreshControl endRefreshing];
    }];
}

- (void)didTweet:(Tweet *)tweet{
//    Gets called when the user presses the "tweet" button on the "ComposeViewController" view, this controller functions as a delegate of the former
    [self.tweetsArray insertObject:tweet atIndex:0];
    [self._tableView reloadData];
}

- (void)didLike:(Tweet *)tweet{
    //    Gets called when the user presses the like button on the "DetailsViewController" view, this controller functions as a delegate of the former
    [self._tableView reloadData];
}

- (void)didRetweet:(Tweet *)tweet{
    //    Gets called when the user presses the retweet button on the "DetailsViewController" view, this controller functions as a delegate of the former
    [self._tableView reloadData];
}

- (void)tweetCell:(TweetCell *)tweetCell didTap:(User *)user{
    [self performSegueWithIdentifier:@"profileSegue" sender:user];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row + 1 == [self.tweetsArray count]){
        [self loadMoreData];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!_isMoreDataLoading){
            // Calculate the position of one screen length before the bottom of the results
            int scrollViewContentHeight = self._tableView.contentSize.height;
            int scrollOffsetThreshold = scrollViewContentHeight - self._tableView.bounds.size.height;
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && self._tableView.isDragging) {
                _isMoreDataLoading = true;
                
                // Update position of loadingMoreView, and start loading indicator
                CGRect frame = CGRectMake(0, self._tableView.contentSize.height, self._tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
                _loadingMoreView.frame = frame;
                [_loadingMoreView startAnimating];
                
                // Code to load more results
                [self loadMoreData];
            }
        }
}

- (void)loadMoreData{
    int tweetsToAdd = (int)[self.tweetsArray count] + 20;
    [[APIManager shared] getHomeTimelineXAmount:tweetsToAdd completion: ^(NSArray *tweets, NSError *error){
        if (tweets) {
//            successfull api call
            self._isMoreDataLoading = false;
            self.tweetsArray = (NSMutableArray *)tweets;
            [self._tableView reloadData];
        } else {
//            error
            NSLog(@"Error getting home timeline: %@", error.localizedDescription);
        }
        [_loadingMoreView stopAnimating];
    }];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    Prepares for the segue accordingly depending on its identifier
    if ([segue.identifier isEqual:@"compTweet"]){
//        Case when the segue is to the ComposeViewController (post tweet button is pressed)
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        //        Assign delegate of the destination vc
        composeController.delegate = self;
    }
    else if ([segue.identifier isEqual:@"detailView"]){
//        Case when the segue is to the DetailsViewController (tweet cell is pressed)
        NSIndexPath *myIndexPath=self._tableView.indexPathForSelectedRow;
//        The tweet will be passed through the segue
        Tweet *tweetToPass = self.tweetsArray[myIndexPath.row];
        UINavigationController *navigationController = [segue destinationViewController];
        DetailsViewController *detailVC = (DetailsViewController*)navigationController.topViewController;
//        Assign delegate and tweet of the destination vc
        detailVC.delegate = self;
        detailVC.tweet = tweetToPass;
    }
    else if ([segue.identifier isEqual:@"profileSegue"]){
//        Case when the segue is to the profile view (profile picture is pressed)
        UINavigationController *navigationController = [segue destinationViewController];
        ProfileViewController *profileVC = (ProfileViewController*)navigationController.topViewController;
        User *userToPass = sender;
        profileVC.user = userToPass;
        
    }
}

@end
