//
//  TwitterClient.m
//  Twitter
//
//  Created by Vincent Lai on 6/27/15.
//  Copyright (c) 2015 Vincent Lai. All rights reserved.
//

#import "TwitterClient.h"
#import "Tweet.h"

NSString *const kTwitterConsumerKey = @"MAa1IvqqsFTmFylZwqj8iyPGZ";
NSString *const kTwitterConsumerSecret = @"6P8WYYU7Y7dW5rPXOgdS6fp1FUmaCnZzWxEXv1vazcDwpEWC2v";
NSString *const kTwitterBaseUrl = @"https://api.twitter.com";

@interface TwitterClient()

@property (nonatomic, strong) void (^loginCompletion)(User *user, NSError *error);

@end

@implementation TwitterClient

+ (TwitterClient *)sharedInstance{

    static TwitterClient *instance = nil;
    
    static dispatch_once_t onceToken;
    //開啟thread處理
    dispatch_once(&onceToken, ^{
        if(instance == nil) {
            instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:kTwitterBaseUrl] consumerKey:kTwitterConsumerKey consumerSecret:kTwitterConsumerSecret];
        }
    });
    
    return instance;

}

//登入處理
- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion {
    self.loginCompletion = completion;
    
    [self.requestSerializer removeAccessToken];
    //登入請求
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"cptwitterdemo://oauth"] scope:nil success:^(BDBOAuth1Credential *requestToken) {
        NSLog(@"got the request token!");
        
        NSURL *authURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token]];
        [[UIApplication sharedApplication] openURL:authURL];
        
    } failure:^(NSError *error) {
        NSLog(@"Failed to get the request token!");
        self.loginCompletion(nil, error);
    }];
    
}

//request 成功後 access token
- (void) openURL:(NSURL *)url{
    [self fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuth1Credential credentialWithQueryString:url.query] success:^(BDBOAuth1Credential *accessToken) {
        NSLog(@"got the access token!");
        [self.requestSerializer saveAccessToken:accessToken];
        
        
        [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            User *user = [[User alloc] initWithDictionary:responseObject];
            [User setCurrentUser:user];
            NSLog(@"current user: %@", user.name);
            self.loginCompletion(user, nil);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failed getting current user!");
            self.loginCompletion(nil, error);
        }];
        
    } failure:^(NSError *error) {
        NSLog(@"Failed to get the access token!");
        self.loginCompletion(nil, error);
    }];
}

//使用GET method 讀取1.1/statuses/home_timeline.json的資訊
- (void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion{
    [self GET:@"1.1/statuses/home_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *tweets = [Tweet tweetsWithArray:responseObject];
        completion(tweets, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

//使用GET method 讀取1.1/statuses/user_timeline.json的資訊
- (void)userTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion{
    [self GET:@"1.1/statuses/user_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *tweets = [Tweet tweetsWithArray:responseObject];
        completion(tweets, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}


-(void)setFavoriteWithParams:(NSDictionary *)params completion:(void (^)(Tweet *tweet, NSError *error))completion {
    [self POST:@"1.1/favorites/create.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        Tweet *tweet = [[Tweet alloc] initWithDictionary:responseObject];
        
        completion(tweet, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

-(void)unsetFavoriteWithParams:(NSDictionary *)params completion:(void (^)(Tweet *tweet, NSError *error))completion {
    [self POST:@"1.1/favorites/destroy.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        Tweet *tweet = [[Tweet alloc] initWithDictionary:responseObject];
        
        completion(tweet, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

-(void)retweetWithParams:(NSDictionary *)params tweetId:(NSString *)tweetId completion:(void (^)(Tweet *tweet, NSError *error))completion {
    [self POST:[NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", tweetId] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        Tweet *tweet = [[Tweet alloc] initWithDictionary:responseObject];
        
        completion(tweet, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

-(void)addTweetWithParams:(NSDictionary *)params completion:(void (^)(Tweet *tweet, NSError *error))completion {
    [self POST:@"1.1/statuses/update.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        Tweet *tweet = [[Tweet alloc] initWithDictionary:responseObject];
        
        completion(tweet, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}


@end
