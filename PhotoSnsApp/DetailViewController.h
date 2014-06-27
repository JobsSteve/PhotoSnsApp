//
//  DetailViewController.h
//  PhotoSnsApp
//
//  Created by Yuumi Yoshida on 2014/06/27.
//  Copyright (c) 2014年 Yuumi Yoshida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

@interface DetailViewController : UIViewController
@property(strong, nonatomic) Post *post;
@end
