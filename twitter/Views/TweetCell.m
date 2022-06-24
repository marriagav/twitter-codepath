//
//  TweetCell.m
//  twitter
//
//  Created by Miguel Arriaga Velasco on 6/20/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "QuartzCore/QuartzCore.h"
#import "APIManager.h"
#import "DateTools.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    Create picture gesture recognizer
    [self _pictureGestureRecognizer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)didTapRetweet:(id)sender {
//    Gets called when the tweet is retweeted or unretweeted
    if (self.tweet.retweeted == NO){
//        Case to retweet tweet
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
//        Data gets refreshed to update outlets
        [self _refreshData];
//        Api call to retweet is made
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
//        Case to unretweet tweetr
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
//        Refresh data to update outlets
        [self _refreshData];
//        Api call to unretweet is made
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

- (IBAction)didTapFavorite:(id)sender {
    //    Gets called when the tweet is favorited or unfavorited
    if (self.tweet.favorited == NO){
//       case to like a tweet
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
        //Refresh data to update outlets
        [self _refreshData];
        //Api call to like is made
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
//        case to unlike a tweet
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        //Refresh data to update outlets
        [self _refreshData];
//        Api call to unlike is made
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

- (UIImage *)_imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)_setImagesOnTweets{
    if (self.tweet.entities.media){
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        NSURL *url = [NSURL URLWithString:self.tweet.entities.media[0][@"media_url_https"]];
        UIImage *image=nil;
        NSData *urlData = [NSData dataWithContentsOfURL:url];
        image = [UIImage imageWithData:urlData];
        UIImage *myImage = [self _imageWithImage:image scaledToSize:CGSizeMake(250, 250)];
        attachment.image = myImage;

        NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];

        NSMutableAttributedString *finalString= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\r", self.tweet.text]];
        
        [finalString appendAttributedString:attachmentString];

        self.contentOutlet.attributedText = finalString;
    }
    else{
        self.contentOutlet.text = self.tweet.text;
    }
}

- (void)_refreshData{
//    Method to update the outlets according to tweet on twitter database
    self.nameOutlet.text = self.tweet.user.name;
    [self _setImagesOnTweets];
    self.usernameOutlet.text = [NSString stringWithFormat:@"%@%@", @"@", self.tweet.user.screenName];
//  The date is formatted
    NSDate *date = self.tweet.createdAtDate;
    self.dateOutlet.text = date.shortTimeAgoSinceNow;
//  Set the profile picture
    self.profilePicture.image = nil;
        if (self.tweet.user.profilePicture != nil) {
        NSString *URLString = self.tweet.user.profilePicture;
        NSURL *url = [NSURL URLWithString:URLString];
        [self.profilePicture setImageWithURL:url];
        }
//    Format the profile picture
    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.height/2;
    self.profilePicture.layer.borderWidth = 0;
    self.profilePicture.clipsToBounds=YES;
//    Update favorite and retweet likes
    NSString* favString = [NSString stringWithFormat:@"%i", self.tweet.favoriteCount];
    self.likeCount.text = favString;
    NSString* retweetString = [NSString stringWithFormat:@"%i", self.tweet.retweetCount];
    self.retweetCount.text = retweetString;
//    Set image of the icon depending on status (liked, unliked, retweeted, unretweeted)
    if (self.tweet.favorited == NO){
        [self.likeButtonOutlet setImage:[UIImage imageNamed:@"favor-icon.png"] forState:UIControlStateNormal];
    }
    else{
        [self.likeButtonOutlet setImage:[UIImage imageNamed:@"favor-icon-red.png"] forState:UIControlStateNormal];
    };
    
    if (self.tweet.retweeted == NO){
        [self.retweetButtonOutlet setImage:[UIImage imageNamed:@"retweet-icon.png"] forState:UIControlStateNormal];
    }
    else{
        [self.retweetButtonOutlet setImage:[UIImage imageNamed:@"retweet-icon-green.png"] forState:UIControlStateNormal];
    };
};

- (void)setTweet:(Tweet *)tweet {
//    Setter for the tweet
    _tweet = tweet;
    [self _refreshData];
};

- (void) didTapUserProfile:(UITapGestureRecognizer *)sender{
    [self.delegate tweetCell:self didTap:self.tweet.user];
}

- (void)_pictureGestureRecognizer{
//    Method to set up a tap gesture recognizer for the profile picture
    UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapUserProfile:)];
    [self.profilePicture addGestureRecognizer:profileTapGestureRecognizer];
    [self.profilePicture setUserInteractionEnabled:YES];
}

@end

