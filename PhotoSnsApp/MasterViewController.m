//
//  MasterViewController.m
//  PhotoSnsApp
//
//  Created by Yuumi Yoshida on 2014/06/27.
//  Copyright (c) 2014年 Yuumi Yoshida. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "PostViewController.h"
#import "LoginViewController.h"
#import "Post.h"
#import "PhotoCell.h"

@interface MasterViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property(nonatomic, strong) NSMutableArray *posts;
@end

@implementation MasterViewController

- (void)refreshPosts
{
    [Post remoteAllAsync:^(NSArray *allRemote, NSError *error) {
        if (error) {
            NSLog(@"error: %@", error.userInfo);
            if (error.userInfo[NSRErrorResponseBodyKey] &&
                [(NSString *)error.userInfo[NSRErrorResponseBodyKey] rangeOfString:@"Access denied"].location != NSNotFound) {
                [self performSegueWithIdentifier:@"Login" sender:self];
            }
        } else {
            NSLog(@"------- OK");
            _posts = [NSMutableArray arrayWithArray:allRemote];
            [self.collectionView reloadData];
        }
    }];
 }

- (void)insertNewPost:(Post *)post
{
    [_posts insertObject:post atIndex:0];

    [post remoteCreateAsync:^(NSError *error) {
        if (error) {
            NSLog(@"+++ err %@", error);
        } else {
            NSLog(@"+++ ok : id=%@", post.remoteID);
            NSIndexPath *newIndex = [NSIndexPath indexPathForItem:0 inSection:0];
            [self.collectionView insertItemsAtIndexPaths:@[newIndex]];
            
        }
    }];    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _posts = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (_posts.count == 0) {
        [self performSelector:@selector(refreshPosts) withObject:nil afterDelay:0.1];
    }
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return _posts.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    PhotoCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    Post *post = _posts[indexPath.row];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    if (post.photoThumbUrl) {
        cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:post.photoThumbUrl]]];
    } else {
        cell.imageView.image = nil;
    }
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSArray *selectedItems = [self.collectionView indexPathsForSelectedItems];
    if ([[segue identifier] isEqualToString:@"ShowDetail"] && selectedItems.count > 0) {
        NSIndexPath *indexPath = selectedItems[0];
        DetailViewController *detail = [segue destinationViewController];
        detail.post = _posts[indexPath.row];
    }
}

- (IBAction)postDataDone:(UIStoryboardSegue *)segue
{
    PostViewController *postViewController = [segue sourceViewController];
    [self performSelector:@selector(insertNewPost:) withObject:postViewController.post afterDelay:0.3];
}

- (IBAction)loginDone:(UIStoryboardSegue *)segue
{
    LoginViewController *login = [segue sourceViewController];
    
    [NSRConfig defaultConfig].basicAuthUsername = login.email;
    [NSRConfig defaultConfig].basicAuthPassword = login.password;
    
    [login dismissViewControllerAnimated:NO completion:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
