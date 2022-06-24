//
//  User.m
//  twitter
//
//  Created by Miguel Arriaga Velasco on 6/20/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
//    initalizes a user from a dictionary (json)
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        self.profilePicture = dictionary[@"profile_image_url_https"];
        self.amountOfFollowers = [dictionary[@"followers_count"] intValue];
        self.bioDescription = dictionary[@"description"];
        self.amountOfFollowing = [dictionary[@"friends_count"] intValue];
        self.userID = [dictionary[@"id"] intValue];
        
    }
    return self;
}

@end
