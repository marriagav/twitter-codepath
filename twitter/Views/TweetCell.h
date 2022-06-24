//
//  TweetCell.h
//  twitter
//  The tweet cell is in charge of setting its own outlets values according to the information on the twitter database through api calls
//  Created by Miguel Arriaga Velasco on 6/20/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TweetCellDelegate;

@interface TweetCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameOutlet;
@property (weak, nonatomic) IBOutlet UILabel *contentOutlet;
@property (weak, nonatomic) IBOutlet UILabel *dateOutlet;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *usernameOutlet;
@property (weak, nonatomic) IBOutlet UILabel *likeCount;
@property (weak, nonatomic) IBOutlet UIButton *replyButtonOutlet;
@property (weak, nonatomic) IBOutlet UILabel *tweetContentOutlet;
@property (weak, nonatomic) IBOutlet UILabel *retweetCount;
@property (weak, nonatomic) IBOutlet UIButton *retweetButtonOutlet;
@property (weak, nonatomic) IBOutlet UIButton *likeButtonOutlet;
@property (strong, nonatomic) Tweet* tweet;
@property (weak, nonatomic) IBOutlet UIButton *messageOutlet;
@property (nonatomic, weak) id<TweetCellDelegate> delegate;

- (void)setTweet:(Tweet *)tweet;
- (void) didTapUserProfile:(UITapGestureRecognizer *)sender;

@end

@protocol TweetCellDelegate

- (void)tweetCell:(TweetCell *) tweetCell didTap: (User *)user;

@end

NS_ASSUME_NONNULL_END
