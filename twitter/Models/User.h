//
//  User.h
//  twitter
//  Model to represent an User
//  Created by Miguel Arriaga Velasco on 6/20/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSString *profilePicture;
@property (nonatomic) int amountOfFollowers;
@property (nonatomic) int amountOfFollowing;
@property (nonatomic, strong) NSString *bioDescription;
@property (nonatomic) int userID;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
