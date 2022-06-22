//
//  TweetCell.m
//  twitter
//
//  Created by Miguel Arriaga Velasco on 6/20/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTweet:(Tweet *)tweet {
    // Since we're replacing the default setter, we have to set the underlying private storage _movie ourselves.
    // _movie was an automatically declared variable with the @propery declaration.
    // You need to do this any time you create a custom setter.
    _tweet = tweet;
    
    self.nameOutlet.text = self.tweet.user.name;
    self.contentOutlet.text = self.tweet.text;
    self.usernameOutlet.text = [NSString stringWithFormat:@"%@%@", @"@", self.tweet.user.screenName];
    self.dateOutlet.text = self.tweet.createdAtString;
    NSString* favString = [NSString stringWithFormat:@"%i", self.tweet.favoriteCount];
    self.likeButtonOutlet.titleLabel.text = favString;
    NSString* retweetString = [NSString stringWithFormat:@"%i", self.tweet.retweetCount];
    self.retweetButtonOutlet.titleLabel.text = retweetString;

    self.profilePicture.image = nil;
        if (self.tweet.user.profilePicture != nil) {
        NSString *URLString = tweet.user.profilePicture;
        NSURL *url = [NSURL URLWithString:URLString];
    //    NSData *urlData = [NSData dataWithContentsOfURL:url];
        [self.profilePicture setImageWithURL:url];
        }
    };

@end

