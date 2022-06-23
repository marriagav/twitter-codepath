//
//  ComposeViewController.h
//  twitter
//  View controller in charge of the Compose tweet view, from where tweets are posted
//  Created by Miguel Arriaga Velasco on 6/22/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ComposeViewControllerDelegate

- (void)didTweet:(Tweet *)tweet;

@end

@interface ComposeViewController : UIViewController

@property (nonatomic, weak) id<ComposeViewControllerDelegate> delegate;

@end



NS_ASSUME_NONNULL_END
