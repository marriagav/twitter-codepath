//
//  DetailsViewController.h
//  twitter
//
//  Created by Miguel Arriaga Velasco on 6/22/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *nameOutlet;
@property (weak, nonatomic) IBOutlet UILabel *usernameOutlet;
@property (weak, nonatomic) IBOutlet UILabel *contentOutlet;
@property (weak, nonatomic) IBOutlet UILabel *dateOutlet;
@property (weak, nonatomic) IBOutlet UILabel *numberOfRetweets;
@property (weak, nonatomic) IBOutlet UILabel *numberOfLikes;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;


@end

NS_ASSUME_NONNULL_END
