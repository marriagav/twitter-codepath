//
//  ProfileViewController.m
//  twitter
//
//  Created by Miguel Arriaga Velasco on 6/23/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIImageView+AFNetworking.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setOutlets];
}

- (void)_setOutlets {
    self.profileName.text = self.user.name;
    self.profileUsername.text = [NSString stringWithFormat:@"%@%@", @"@", self.user.screenName];
    self.bio.text = self.user.bioDescription;
//    self.followersAmount.text = self.user.amountOfFollowers;
//    self.followingAmount.text = self.user.amountOfFollowing;
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

@end
