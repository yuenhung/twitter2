//
//  ComposeViewController.h
//  twitterclient
//
//  Created by Vincent Lai on 6/27/15.
//  Copyright (c) 2015 Vincent Lai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComposeViewController : UIViewController

- (void)prepareForReplyWithTweetId:(NSString *)tweetId authorScreenName:(NSString *)authorScreenName;

@end
