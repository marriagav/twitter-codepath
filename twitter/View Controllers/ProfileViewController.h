//
//  ProfileViewController.h
//  twitter
//
//  Created by Miguel Arriaga Velasco on 6/23/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController

@property (nonatomic, strong) User *user;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *profileName;
@property (weak, nonatomic) IBOutlet UILabel *profileUsername;
@property (weak, nonatomic) IBOutlet UILabel *followingAmount;
@property (weak, nonatomic) IBOutlet UILabel *followersAmount;
@property (weak, nonatomic) IBOutlet UILabel *bio;
@property (nonatomic, strong) NSArray *tweetsArray;

@end

NS_ASSUME_NONNULL_END
