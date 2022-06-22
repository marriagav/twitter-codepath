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

@interface ComposeViewController () 
@property (weak, nonatomic) IBOutlet UITextView *_tweetTextContent;


@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self._tweetTextContent.layer.borderWidth = 1.0f;
    self._tweetTextContent.layer.borderColor = [[UIColor lightGrayColor] CGColor];
}

- (void)_closeWindow{
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)closeTweetComposing:(id)sender {
    [self _closeWindow];
}

- (IBAction)postTweet:(id)sender {
    [[APIManager shared]
     postStatusWithText:self._tweetTextContent.text completion:^(Tweet *tweet, NSError *error) {
            if (tweet) {
                [self.delegate didTweet:tweet];
                NSLog(@"Compose Tweet Success!");
                [self _closeWindow];
            } else {
                NSLog(@"Error posting tweet: %@", error.localizedDescription);
            }
    }];
    
}

@end
