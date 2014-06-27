//
//  Post.m
//  PhotoSnsApp
//
//  Created by Yuumi Yoshida on 2014/06/27.
//  Copyright (c) 2014年 Yuumi Yoshida. All rights reserved.
//

#import "Post.h"

@implementation Post

- (BOOL) shouldSendProperty:(NSString *)property whenNested:(BOOL)nested
{
    if ([property isEqualToString:@"userId"] || [property isEqualToString:@"name"] ||
        [property isEqualToString:@"photoUrl"] || [property isEqualToString:@"photoThumbUrl"])
        return NO;

    return [super shouldSendProperty:property whenNested:nested];
}


- (void)setImage:(UIImage *)image
{
    _imageData = [self base64FromImage:image];
}

- (NSString *)base64FromImage:(UIImage *)image
{
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}


@end
