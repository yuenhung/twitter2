//
//  UIImageView+NSAdditions.h
//  rottenclient
//
//  Created by Vincent Lai on 6/30/15.
//  Copyright (c) 2015 Vincent Lai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (NSAdditions)

- (void)fadeInImageWithURLRequest:(NSURLRequest *)urlRequest
                 placeholderImage:(UIImage *)placeholderImage;

@end
