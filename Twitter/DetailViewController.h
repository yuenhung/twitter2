//
//  DetailViewController.h
//  twitterclient
//
//  Created by Vincent Lai on 6/27/15.
//  Copyright (c) 2015 Vincent Lai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@class DetailViewController;

@protocol DetailViewControllerDelegate <NSObject>

-(void)detailReplyInvoked:(DetailViewController *)detailViewController;
-(void)detailFavoriteInvoked:(DetailViewController *)detailViewController;
-(void)detailRetweetInvoked:(DetailViewController *)detailViewController;

@end

@interface DetailViewController : UIViewController

@property (nonatomic, strong) Tweet *tweet;

@property (nonatomic, weak) id<DetailViewControllerDelegate> delegate;

@end
