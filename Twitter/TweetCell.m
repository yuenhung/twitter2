//
//  TweetCell.m
//  Twitter
//
//  Created by Vincent Lai on 6/30/15.
//  Copyright (c) 2015 Vincent Lai. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+NSAdditions.h"
#import "NSDate+DateTools.h"


@implementation TweetCell

- (void)awakeFromNib {
    // Initialization code
    self.tweetLabel.preferredMaxLayoutWidth = self.tweetLabel.frame.size.width;
    
    //註冊callback function給image View
    [self.retweetButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onRetweet:)]];
    [self.replyButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onReply:)]];
    [self.favoriteButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onFavorite:)]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


//更新TweetCell 的資料
-(void)populateFromTweet:(Tweet*)tweet {
    self.tweetLabel.text = tweet.text;
    
    if (tweet.favorited) {
        self.favoriteButton.image = [UIImage imageNamed:@"favorite_on"];
    } else {
        self.favoriteButton.image = [UIImage imageNamed:@"favorite"];
    }
    
    if (tweet.retweeted) {
        self.retweetButton.image = [UIImage imageNamed:@"retweet_on"];
    } else {
        self.retweetButton.image = [UIImage imageNamed:@"retweet"];
    }
    
    self.nameLabel.text = tweet.user.name;
    self.addressLabel.text = [NSString stringWithFormat:@"@%@", tweet.user.screenname];
    
    [self.profileImage fadeInImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:tweet.user.profileImageUrl]] placeholderImage:nil];
    
    self.timeLabel.text = tweet.createAt.shortTimeAgoSinceNow;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.tweetLabel.preferredMaxLayoutWidth = self.tweetLabel.frame.size.width;
}

//三個圖示的callback function
- (void)onReply:(UITapGestureRecognizer *)sender {
    [self.delegate replyInvoked:self];
}

- (void)onRetweet:(UITapGestureRecognizer *)sender {
    [self.delegate retweetInvoked:self];
}

- (void)onFavorite:(UITapGestureRecognizer *)sender {
    [self.delegate favoriteInvoked:self];
}


@end
