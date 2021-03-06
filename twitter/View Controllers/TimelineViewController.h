//
//  TimelineViewController.h
//  twitter
//  This view controller is in charge of displaying the tweets in the timeline.
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetCell.h"

@interface TimelineViewController : UIViewController

@property (strong, nonatomic) NSMutableArray* tweetsArray;

- (void)tweetCell:(TweetCell *)tweetCell didTap:(User *)user;
- (void)loadMoreData;


@end
