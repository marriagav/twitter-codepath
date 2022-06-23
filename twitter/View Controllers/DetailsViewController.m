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
    [self _refreshData];
    // Do any additional setup after loading the view.
}

- (void)_refreshData{
    self.nameOutlet.text = self.tweet.user.name;
    self.contentOutlet.text = self.tweet.text;
    self.usernameOutlet.text = [NSString stringWithFormat:@"%@%@", @"@", self.tweet.user.screenName];
    self.dateOutlet.text = self.tweet.createdAtString;

    self.profilePicture.image = nil;
        if (self.tweet.user.profilePicture != nil) {
        NSString *URLString = self.tweet.user.profilePicture;
        NSURL *url = [NSURL URLWithString:URLString];
        [self.profilePicture setImageWithURL:url];
        }
    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.height/2;
    self.profilePicture.layer.borderWidth = 0;
    self.profilePicture.clipsToBounds=YES;
    
    NSString* favString = [NSString stringWithFormat:@"%i", self.tweet.favoriteCount];
    self.numberOfLikes.text = favString;
    NSString* retweetString = [NSString stringWithFormat:@"%i", self.tweet.retweetCount];
    self.numberOfRetweets.text = retweetString;
    
    if (self.tweet.favorited == NO){
        [self.likeButton setImage:[UIImage imageNamed:@"favor-icon.png"] forState:UIControlStateNormal];
    }
    else{
        [self.likeButton setImage:[UIImage imageNamed:@"favor-icon-red.png"] forState:UIControlStateNormal];
    };
    
    if (self.tweet.retweeted == NO){
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon.png"] forState:UIControlStateNormal];
    }
    else{
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon-green.png"] forState:UIControlStateNormal];
    };
};
- (IBAction)closeDetail:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)didTapFavorite:(id)sender {
    if (self.tweet.favorited == NO){
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
        [self _refreshData];
        [self.delegate didLike:self.tweet];
        
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
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        [self _refreshData];
        [self.delegate didLike:self.tweet];
        
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
        if (self.tweet.retweeted == NO){
            self.tweet.retweeted = YES;
            self.tweet.retweetCount += 1;
            [self _refreshData];
            [self.delegate didRetweet:self.tweet];
            
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
            self.tweet.retweeted = NO;
            self.tweet.retweetCount -= 1;
            [self _refreshData];
            [self.delegate didRetweet:self.tweet];
            
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
