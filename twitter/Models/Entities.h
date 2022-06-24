//
//  Entities.h
//  twitter
//
//  Created by Miguel Arriaga Velasco on 6/24/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Entities : NSObject

@property (nonatomic, strong) NSArray *media; // Media
@property (nonatomic, strong) NSDictionary *urls; // urls

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
