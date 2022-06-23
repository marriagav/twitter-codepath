//
//  DetailsViewController.h
//  twitter
//
//  Created by Miguel Arriaga Velasco on 6/22/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DetailsViewControllerDelegate

- (void)didLike:(Tweet *)tweet;
- (void)didRetweet:(Tweet *)tweet;

@end

@interface DetailsViewController : UIViewController

@property (nonatomic, weak) id<DetailsViewControllerDelegate> delegate;
@property (strong, nonatomic) Tweet* tweet;
@property (weak, nonatomic) IBOutlet UILabel *nameOutlet;
@property (weak, nonatomic) IBOutlet UILabel *usernameOutlet;
@property (weak, nonatomic) IBOutlet UILabel *contentOutlet;
@property (weak, nonatomic) IBOutlet UILabel *dateOutlet;
@property (weak, nonatomic) IBOutlet UILabel *numberOfRetweets;
@property (weak, nonatomic) IBOutlet UILabel *numberOfLikes;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;


@end

NS_ASSUME_NONNULL_END
