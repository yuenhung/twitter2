//
//  LoginViewController.m
//  Twitter
//
//  Created by Vincent Lai on 6/27/15.
//  Copyright (c) 2015 Vincent Lai. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "LoginViewController.h"
#import "TwitterClient.h"
#import "TweetsViewController.h"
#import "LeftMenuViewController.h"
#import "ProfileViewController.h"

#define CENTER_TAG 1
#define LEFT_PANEL_TAG 2

#define CORNER_RADIUS 4

#define SLIDE_TIMING .25
#define PANEL_WIDTH 60

@interface LoginViewController ()<TweetsViewControllerDelegate, LeftMenuViewControllerDelegate, ProfileViewControllerDelegate>

@property (nonatomic, strong) TweetsViewController *tweetsViewController;
@property (nonatomic, strong) ProfileViewController *profileViewController;
@property (nonatomic, strong) LeftMenuViewController *leftMenuViewController;
@property (nonatomic, assign) BOOL showingLeftPanel;
@property (nonatomic, assign) float navigationBarHeight;

@end

@implementation LoginViewController
- (IBAction)onLogin:(id)sender {
    [[TwitterClient sharedInstance] loginWithCompletion:^(User *user, NSError *error) {
        if (user != nil) {
            
            NSLog(@"Welcome to %@", user.name);
            //[self presentViewController:[[UINavigationController alloc] initWithRootViewController:[[TweetsViewController alloc] init]] animated:YES completion:nil];
            [self loadTweetsViewController];
            
        } else {
            
        }
    }];
}

- (void) loadTweetsViewController {
    self.tweetsViewController = [[TweetsViewController alloc] initWithNibName:@"TweetsViewController" bundle:nil];
    self.tweetsViewController.view.tag = CENTER_TAG;
    self.tweetsViewController.delegate = self;
    
    [self.view addSubview:self.tweetsViewController.view];
    //[self addChildViewController:self.tweetsViewController];
    
    [self.tweetsViewController didMoveToParentViewController:self];
    
    self.tweetsViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    
    //self.navigationController.view.frame = CGRectMake(100.0, 0.0, self.view.frame.size.width, self.view.frame.size.height);
    //self.navigationController.navigationBar.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height);
    
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
    
}


-(void)logout {
    if (self.tweetsViewController != nil)
        [self.tweetsViewController logout];
    else
        [self.profileViewController logout];
}

-(void)onCompose {
    if (self.tweetsViewController != nil)
        [self.tweetsViewController onCompose];
    else
        [self.profileViewController onCompose];
}


-(UIView *)getLeftView {
    // init view if it doesn't already exist
    if (self.leftMenuViewController == nil)
    {
        // this is where you define the view for the left panel
        self.leftMenuViewController = [[LeftMenuViewController alloc] initWithNibName:@"LeftMenuViewController" bundle:nil];
        self.leftMenuViewController.view.tag = LEFT_PANEL_TAG;
        self.leftMenuViewController.delegate = self;//self.tweetsViewController;
        
        [self.view addSubview:self.leftMenuViewController.view];
        
        //[self addChildViewController:self.leftMenuViewController];
        [self.leftMenuViewController didMoveToParentViewController:self];
        
        self.leftMenuViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    self.showingLeftPanel = YES;
    
    // setup view shadows
    [self showCenterViewWithShadow:YES withOffset:-2];
    
    UIView *view = self.leftMenuViewController.view;
    
    return view;
}

-(UIView *)getProfileView {
    if (self.tweetsViewController != nil) {
        [self.tweetsViewController.view removeFromSuperview];
        self.tweetsViewController = nil;
    }
    
    // init view if it doesn't already exist
    if (self.profileViewController == nil)
    {
        // this is where you define the view for the left panel
        self.profileViewController = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
        self.profileViewController.view.tag = CENTER_TAG;
        self.profileViewController.delegate = self;//self.tweetsViewController;
        
        [self.view addSubview:self.profileViewController.view];
        
        //[self addChildViewController:self.leftMenuViewController];
        [self.profileViewController didMoveToParentViewController:self];
        
        self.profileViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    self.showingLeftPanel = NO;
    
    // setup view shadows
    [self showCenterViewWithShadow:YES withOffset:-2];
    
    UIView *view = self.profileViewController.view;
    
    return view;
}

-(UIView *)getTweetsView {
    
    if (self.profileViewController != nil) {
        [self.profileViewController.view removeFromSuperview];
        self.profileViewController = nil;
    }
    
    // init view if it doesn't already exist
    if (self.tweetsViewController == nil)
    {
        // this is where you define the view for the left panel
        self.tweetsViewController = [[TweetsViewController alloc] initWithNibName:@"TweetsViewController" bundle:nil];
        self.tweetsViewController.view.tag = CENTER_TAG;
        self.tweetsViewController.delegate = self;//self.tweetsViewController;
        
        [self.view addSubview:self.tweetsViewController.view];
        
        //[self addChildViewController:self.leftMenuViewController];
        [self.tweetsViewController didMoveToParentViewController:self];
        
        self.tweetsViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    self.showingLeftPanel = NO;
    
    // setup view shadows
    [self showCenterViewWithShadow:YES withOffset:-2];
    
    UIView *view = self.tweetsViewController.view;
    
    return view;
}

-(void)movePanelRight {
    
    self.loginButton.hidden = YES;
    UIView *childView = [self getLeftView];
    [self.view sendSubviewToBack:childView];
    
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.navigationController.navigationBar.frame = CGRectMake(self.view.frame.size.width - PANEL_WIDTH, 0, self.navigationController.navigationBar.frame.size.width, self.navigationBarHeight+20);
        if (self.tweetsViewController != nil)
            self.tweetsViewController.view.frame = CGRectMake(self.view.frame.size.width - PANEL_WIDTH, 0, self.view.frame.size.width, self.view.frame.size.height);
        else
            self.profileViewController.view.frame = CGRectMake(self.view.frame.size.width - PANEL_WIDTH, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
                     completion:^(BOOL finished) {
                         if (finished) {
                             self.tweetsViewController.showingLeftPanel = YES;
                             self.profileViewController.showingLeftPanel = YES;
                         }
                     }];
}

-(void)movePanelToOriginalPosition {
    [self getTweetsView];
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.navigationController.navigationBar.frame = CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width, self.navigationBarHeight+20);
        self.tweetsViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [self resetMainView];
                         }
                     }];
}

-(void)movePanelToProfilePosition {
    [self getProfileView];
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.navigationController.navigationBar.frame = CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width, self.navigationBarHeight+20);
        self.profileViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [self resetMainView];
                         }
                     }];
}

-(void)resetMainView {
    // remove left and right views, and reset variables, if needed
    if (self.leftMenuViewController != nil) {
        [self.leftMenuViewController.view removeFromSuperview];
        self.leftMenuViewController = nil;
        self.tweetsViewController.showingLeftPanel = NO;
        self.profileViewController.showingLeftPanel = NO;
        self.showingLeftPanel = NO;
    }

    // remove view shadows
    [self showCenterViewWithShadow:NO withOffset:0];
}

-(void)showCenterViewWithShadow:(BOOL)value withOffset:(double)offset {
    if (value) {
        [self.tweetsViewController.view.layer setCornerRadius:CORNER_RADIUS];
        [self.tweetsViewController.view.layer setShadowColor:[UIColor blackColor].CGColor];
        [self.tweetsViewController.view.layer setShadowOpacity:0.8];
        [self.tweetsViewController.view.layer setShadowOffset:CGSizeMake(offset, offset)];
        
    } else {
        [self.tweetsViewController.view.layer setCornerRadius:0.0f];
        [self.tweetsViewController.view.layer setShadowOffset:CGSizeMake(offset, offset)];
    }
}

-(void)hideBar
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
-(void)showBar
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
    [self hideBar];
    
    self.loginButton.hidden = NO;
    User *user = [User currentUser];
    if(user != nil) {
        self.loginButton.hidden = YES;
        [self loadTweetsViewController];
    }
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
