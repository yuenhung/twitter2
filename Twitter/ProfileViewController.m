//
//  TweetsViewController.m
//  Twitter
//
//  Created by Vincent Lai on 6/28/15.
//  Copyright (c) 2015 Vincent Lai. All rights reserved.
//

#import "ProfileViewController.h"
#import "User.h"
#import "TwitterClient.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "DetailViewController.h"
#import "ComposeViewController.h"
#import "LeftMenuViewController.h"
#import "UIImageView+NSAdditions.h"


@interface ProfileViewController ()<UITableViewDataSource, UITableViewDelegate, TweetCellDelegate, DetailViewControllerDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *tweets;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    User *currentUser = [User currentUser];
    
    [self.profileImage fadeInImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:currentUser.profileImageUrl]] placeholderImage:nil];
    
    self.userName.text = currentUser.name;
    self.address.text = [NSString stringWithFormat:@"@%@", currentUser.screenname];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 86;
    
    //註冊 TweetCell
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];
    
    // refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    [self.refreshControl removeConstraints:self.refreshControl.constraints];
    
    
    //add navigationItem
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(onCompose)];
    
    self.navigationItem.title = @"Home";
    
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:107./255. green:179./255. blue:255./255. alpha:1];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    
    [self showBar];

    [self refreshData];
    
    //self.navigationController.navigationBar.frame = CGRectMake(self.view.frame.size.width-50, 0.0, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height);
    
}


- (void)refreshData {
    [[TwitterClient sharedInstance] userTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
        self.tweets = tweets;
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    }];
}

-(void)hideBar
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
-(void)showBar
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)logout {

            
    if (self.showingLeftPanel == YES)
    {
        [_delegate movePanelToOriginalPosition];
    }
    else
    {
        [_delegate movePanelRight];
    }
}

- (void)onCompose {
    ComposeViewController *vc = [[ComposeViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

//TweetCell 餵進 tableView
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.delegate = self;
    
    Tweet *tweet = self.tweets[indexPath.row];
    [cell populateFromTweet:tweet];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DetailViewController *vc = [[DetailViewController alloc] init];
    vc.delegate = self;
    vc.tweet = self.tweets[indexPath.row];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)replyInvoked:(TweetCell *)tweetCell {
    NSInteger row = [self.tableView indexPathForCell:tweetCell].row;
    
    Tweet *tweet = self.tweets[row];
    
    [self replyToTweet:tweet];
}

-(void)replyToTweet:(Tweet *)tweet {
    ComposeViewController *vc = [[ComposeViewController alloc] init];
    [vc prepareForReplyWithTweetId:tweet.tweetId authorScreenName:tweet.user.screenname];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

-(void)favoriteInvoked:(TweetCell *)tweetCell {
    NSInteger row = [self.tableView indexPathForCell:tweetCell].row;
    
    [self toggleFavorite:self.tweets[row] completion:^(Tweet *newTweet, NSError *error) {
        if (newTweet) {
            [tweetCell populateFromTweet:newTweet];
        }
    }];
}

-(void)retweet:(Tweet*)tweet completion:(void (^)(Tweet *newTweet, NSError *error))completion {
    if (tweet.retweeted) {
        completion(nil, nil);
    } else {
        [[TwitterClient sharedInstance] retweetWithParams:nil tweetId:tweet.tweetId completion:^(Tweet *newTweet, NSError *error) {
            if (newTweet) {
                tweet.retweeted = YES;
                completion(newTweet, error);
            }
        }];
    }
}

-(void)retweetInvoked:(TweetCell *)tweetCell {
    NSInteger row = [self.tableView indexPathForCell:tweetCell].row;
    [self retweet:self.tweets[row] completion:^(Tweet *newTweet, NSError *error) {
        if (newTweet) {
            [tweetCell populateFromTweet:self.tweets[row]];
        }
    }];
}

-(void)toggleFavorite:(Tweet*)tweet completion:(void (^)(Tweet *newTweet, NSError *error))completion {
    if(tweet.favorited) {
        [[TwitterClient sharedInstance] unsetFavoriteWithParams:@{@"id": tweet.tweetId} completion:^(Tweet *newTweet, NSError *error) {
            if (newTweet) {
                tweet.favorited = NO;
            }
            completion(newTweet, error);
        }];
    } else {
        [[TwitterClient sharedInstance] setFavoriteWithParams:@{@"id": tweet.tweetId} completion:^(Tweet *newTweet, NSError *error) {
            if (newTweet) {
                tweet.favorited = YES;
            }
            completion(newTweet, error);
        }];
    }
}

-(NSInteger)getTweetRow:(Tweet*)tweet {
    return [self.tweets indexOfObject:tweet];
}

-(void)detailReplyInvoked:(DetailViewController *)detailViewController {
    [self replyToTweet:detailViewController.tweet];
}


-(void)detailFavoriteInvoked:(DetailViewController *)detailViewController {
    [self toggleFavorite:detailViewController.tweet completion:^(Tweet *newTweet, NSError *error) {
        if (!error) {
            
            [(TweetCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[self getTweetRow:detailViewController.tweet] inSection:0]] populateFromTweet:detailViewController.tweet];
            
            detailViewController.tweet = detailViewController.tweet;
        }
    }];
}

-(void)detailRetweetInvoked:(DetailViewController *)detailViewController {
    [self retweet:detailViewController.tweet completion:^(Tweet *newTweet, NSError *error) {
        if (!error) {
            [(TweetCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[self getTweetRow:detailViewController.tweet] inSection:0]] populateFromTweet:detailViewController.tweet];
            
            detailViewController.tweet = detailViewController.tweet;
        }
    }];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
