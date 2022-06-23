//
//  ComposeViewController.m
//  twitter
//
//  Created by Miguel Arriaga Velasco on 6/22/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AFNetworking.h"

@interface ComposeViewController ()

@property (weak, nonatomic) IBOutlet UITextView *_tweetTextContent;
@property (weak, nonatomic) IBOutlet UIImageView *_profilePicture;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    Format the typing area
    self._tweetTextContent.layer.borderWidth = 0.5f;
    self._tweetTextContent.layer.borderColor = [[UIColor lightGrayColor] CGColor];
//    Initialize the profile picture of the user thats signed in
    [self _setupProfilePicture];
}

- (void)_setupProfilePicture{
//    this method retrieves the image of the user thats logged in from the apimanager class
    self._profilePicture.image = nil;
    [[APIManager shared] getUserInfo: ^(User *user, NSError *error){
        if (error) {
            NSLog(@"Error getting home timeline: %@", error.localizedDescription);
        } else {
            if (user.profilePicture != nil) {
                NSString *URLString = user.profilePicture;
                NSURL *url = [NSURL URLWithString:URLString];
                [self._profilePicture setImageWithURL:url];
            }
        }
    }];
//    Format the picture
    self._profilePicture.layer.cornerRadius = self._profilePicture.frame.size.height/2;
    self._profilePicture.layer.borderWidth = 0;
    self._profilePicture.clipsToBounds=YES;
}

- (void)_closeWindow{
//    Closes the window
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)closeTweetComposing:(id)sender {
//    Gets called when the exit button is pressed
    [self _closeWindow];
}

- (IBAction)postTweet:(id)sender {
//    This method calls the post method from the apimanager, allowing the user to post the tweet
    [[APIManager shared]
     postStatusWithText:self._tweetTextContent.text completion:^(Tweet *tweet, NSError *error) {
            if (tweet) {
//                calls the didTweet method from the delegate (TimelineViewController)
                [self.delegate didTweet:tweet];
                NSLog(@"Compose Tweet Success!");
//                Closses the window
                [self _closeWindow];
            } else {
                NSLog(@"Error posting tweet: %@", error.localizedDescription);
            }
    }];
}

@end
