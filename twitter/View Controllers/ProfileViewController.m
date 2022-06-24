//
//  ProfileViewController.m
//  twitter
//
//  Created by Miguel Arriaga Velasco on 6/23/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"
#import "tweetCell.h"

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *_tableView;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//  Initiallize delegate and datasource of the tableview to self
    self._tableView.dataSource=self;
    self._tableView.delegate=self;
    [self _setOutlets];
    [self _getUserTimeline];
}

- (void)_setOutlets {
    self.profileName.text = self.user.name;
    self.profileUsername.text = [NSString stringWithFormat:@"%@%@", @"@", self.user.screenName];
    self.bio.text = self.user.bioDescription;
    NSString* followersString = [NSString stringWithFormat:@"%i", self.user.amountOfFollowers];
    NSString* followingString = [NSString stringWithFormat:@"%i", self.user.amountOfFollowing];
    self.followersAmount.text = followersString;
    self.followingAmount.text = followingString;
//  Set the profile picture
    self.profilePicture.image = nil;
        if (self.user.profilePicture != nil) {
        NSString *URLString = self.user.profilePicture;
        NSURL *url = [NSURL URLWithString:URLString];
        [self.profilePicture setImageWithURL:url];
        }
//    Format the profile picture
    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.height/2;
    self.profilePicture.layer.borderWidth = 0;
    self.profilePicture.clipsToBounds=YES;
}

- (IBAction)closeTab:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)_getUserTimeline{
//    Retrieves tweets from the api
    [[APIManager shared] getUserTimeline:self.user completion:^(NSArray *tweets, NSError *error){
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
    return cell;
}

@end
