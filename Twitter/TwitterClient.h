//
//  TwitterClient.h
//  Twitter
//
//  Created by Vincent Lai on 6/27/15.
//  Copyright (c) 2015 Vincent Lai. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "User.h"
#import "Tweet.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *)sharedInstance;

- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion;
- (void)openURL:(NSURL *)url;

- (void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion;
- (void)userTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion;
- (void)setFavoriteWithParams:(NSDictionary *)params completion:(void (^)(Tweet *tweet, NSError *error))completion;
- (void)unsetFavoriteWithParams:(NSDictionary *)params completion:(void (^)(Tweet *tweet, NSError *error))completion;
- (void)retweetWithParams:(NSDictionary *)params tweetId:(NSString *)tweetId completion:(void (^)(Tweet *tweet, NSError *error))completion;
- (void)addTweetWithParams:(NSDictionary *)params completion:(void (^)(Tweet *tweet, NSError *error))completion;

@end
