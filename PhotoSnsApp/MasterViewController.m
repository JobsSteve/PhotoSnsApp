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
#import "Post.h"
#import "PhotoCell.h"

@interface MasterViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property(nonatomic, strong) NSMutableArray *posts;
@end

@implementation MasterViewController

- (void)refreshPosts
{
    for (int i = 0; i < 3; i++) {
        Post *post = [[Post alloc]init];
        post.photo = [UIImage imageNamed:@"constructocat"];
        post.caption = [NSString stringWithFormat:@"Octcat %d", i + 1];
        [_posts addObject:post];
    }
    [self.collectionView reloadData];
}

- (void)insertNewPost:(Post *)post
{
    [_posts insertObject:post atIndex:0];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.collectionView insertItemsAtIndexPaths:@[indexPath]];
    
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
    
    if (post.photo) {
        cell.imageView.image = post.photo;
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
