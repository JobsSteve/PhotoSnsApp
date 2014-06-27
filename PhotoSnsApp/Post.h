//
//  Post.h
//  PhotoSnsApp
//
//  Created by Yuumi Yoshida on 2014/06/27.
//  Copyright (c) 2014年 Yuumi Yoshida. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NSRails/NSRails.h>

@interface Post : NSRRemoteObject
@property (nonatomic, strong) NSString *caption;

@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *photoUrl;
@property (nonatomic, strong) NSString *photoThumbUrl;
@end
