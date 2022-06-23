//
//  DetailsViewController.m
//  twitter
//
//  Created by Miguel Arriaga Velasco on 6/22/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"

@interface DetailsViewController ()

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    The tweet data is refreshed
    [self _refreshData];
}

- (void)_refreshData{
//    This method updates the tweet data on the outlets of the view
    self.nameOutlet.text = self.tweet.user.name;
    self.contentOutlet.text = self.tweet.text;
    self.usernameOutlet.text = [NSString stringWithFormat:@"%@%@", @"@", self.tweet.user.screenName];
    self.dateOutlet.text = self.tweet.createdAtString;
//  Set up the profile picture correctly
    self.profilePicture.image = nil;
        if (self.tweet.user.profilePicture != nil) {
        NSString *URLString = self.tweet.user.profilePicture;
        NSURL *url = [NSURL URLWithString:URLString];
        [self.profilePicture setImageWithURL:url];
        }
    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.height/2;
    self.profilePicture.layer.borderWidth = 0;
    self.profilePicture.clipsToBounds=YES;
//    Set up the amount of likes and retweets
    NSString* favString = [NSString stringWithFormat:@"%i", self.tweet.favoriteCount];
    self.numberOfLikes.text = favString;
    NSString* retweetString = [NSString stringWithFormat:@"%i", self.tweet.retweetCount];
    self.numberOfRetweets.text = retweetString;
//    If the tweet is favorited its icon needs to change
    if (self.tweet.favorited == NO){
        [self.likeButton setImage:[UIImage imageNamed:@"favor-icon.png"] forState:UIControlStateNormal];
    }
    else{
        [self.likeButton setImage:[UIImage imageNamed:@"favor-icon-red.png"] forState:UIControlStateNormal];
    };
    //    If the tweet is retweeted its icon needs to change
    if (self.tweet.retweeted == NO){
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon.png"] forState:UIControlStateNormal];
    }
    else{
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon-green.png"] forState:UIControlStateNormal];
    };
};

- (IBAction)closeDetail:(id)sender {
//    Close the detail view
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)didTapFavorite:(id)sender {
//    This method gets called when the tweet gets liked or unliked
    if (self.tweet.favorited == NO){
//        Case for likes
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
//        Data is refreshed to update the outlets
        [self _refreshData];
//        The tweet gets updated on the upper view (TimelineView) as well by calling the method on the delegate
        [self.delegate didLike:self.tweet];
//        The like endpoint gets called from the api manager
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
             }
             else{
                 NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
             }
         }];
    }
    else {
//        Case for unlikes
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        //Data is refreshed to update the outlets
        [self _refreshData];
        //The tweet gets updated on the upper view (TimelineView) as well by calling the method on the delegate
        [self.delegate didLike:self.tweet];
        //The unlike endpoint gets called from the api manager
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
                 if(error){
                      NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
                 }
                 else{
                     NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
                 }
            }];
        }
}
    
- (IBAction)didTapRetweet:(id)sender {
//    This method gets called when the tweet is retweeted or unretweeted
        if (self.tweet.retweeted == NO){
//            Case for retweets
            self.tweet.retweeted = YES;
            self.tweet.retweetCount += 1;
            //Data is refreshed to update the outlets
            [self _refreshData];
//            The tweet gets updated on the upper view (TimelineView) as well by calling the method on the delegate
            [self.delegate didRetweet:self.tweet];
            //The retweet endpoint gets called from the api manager
            [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
                 if(error){
                      NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
                 }
                 else{
                     NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
                 }
             }];
        }
        else {
            //Case for unretweets
            self.tweet.retweeted = NO;
            self.tweet.retweetCount -= 1;
            //Data is refreshed to update the outlets
            [self _refreshData];
            //The tweet gets updated on the upper view (TimelineView) as well by calling the method on the delegate
            [self.delegate didRetweet:self.tweet];
            //The unretweet endpoint gets called from the api manager
            [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
                 if(error){
                      NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
                 }
                 else{
                     NSLog(@"Successfully unretweeted the following Tweet: %@", tweet.text);
                 }
             }];
        }
}

@end
