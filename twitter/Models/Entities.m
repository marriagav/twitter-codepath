//
//  Entities.m
//  twitter
//
//  Created by Miguel Arriaga Velasco on 6/24/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "Entities.h"

@implementation Entities

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
//    initalizes a user from a dictionary (json)
    self = [super init];
    if (self) {
        self.media = dictionary[@"media"];
        self.urls = dictionary[@"urls"];
    }
    return self;
}


@end
