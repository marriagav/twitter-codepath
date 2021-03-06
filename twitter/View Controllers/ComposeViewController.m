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

@interface ComposeViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *_tweetHere;
@property (weak, nonatomic) IBOutlet UITextView *_tweetTextContent;
@property (weak, nonatomic) IBOutlet UIImageView *_profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *_wordCount;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    Format the typing area
    self._tweetTextContent.layer.borderWidth = 0.5f;
    self._tweetTextContent.layer.borderColor = [[UIColor lightGrayColor] CGColor];
//    Initialize the profile picture of the user thats signed in
    [self _setupProfilePicture];
    self._tweetTextContent.delegate=self;
    self._tweetTextContent.delegate = self;
}

- (void)textViewDidChange:(UITextView *)textView{
    self._tweetHere.hidden=(textView.text.length>0);
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

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    // Set the max character limit
    int characterLimit = 280;

    // Construct what the new text would be if we allowed the user's latest edit
    NSString *newText = [self._tweetTextContent.text stringByReplacingCharactersInRange:range withString:text];

    // Update character count label
    self._wordCount.text = [NSString stringWithFormat:@"%@/%@", [NSString stringWithFormat:@"%lu", (unsigned long)newText.length], @"280"];

    // Should the new text should be allowed? True/False
    return newText.length < characterLimit;
}

@end
