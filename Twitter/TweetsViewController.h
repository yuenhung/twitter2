//
//  TweetsViewController.h
//  Twitter
//
//  Created by Vincent Lai on 6/28/15.
//  Copyright (c) 2015 Vincent Lai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TweetsViewControllerDelegate <NSObject>

@optional
- (void)movePanelRight;

@required
- (void)movePanelToOriginalPosition;
- (void)movePanelToProfilePosition;

@end

@interface TweetsViewController : UIViewController

@property (nonatomic, assign) id<TweetsViewControllerDelegate> delegate;

- (void)logout;
- (void)onCompose;
@property (nonatomic, assign) BOOL showingLeftPanel;

@end
