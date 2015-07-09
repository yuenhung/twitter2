//
//  Tweet.h
//  Twitter
//
//  Created by Vincent Lai on 6/27/15.
//  Copyright (c) 2015 Vincent Lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSDate *createAt;
@property (nonatomic, strong) User *user;
@property (nonatomic, assign) BOOL favorited;
@property (nonatomic, assign) BOOL retweeted;
@property (nonatomic, strong) NSString *tweetId;

- (id)initWithDictionary:(NSDictionary *) dictionary;

+ (NSArray *)tweetsWithArray:(NSArray *)array;

@end
