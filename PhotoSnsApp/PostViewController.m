//
//  ViewController.m
//  PhotoSnsApp
//
//  Created by Yuumi Yoshida on 2014/06/27.
//  Copyright (c) 2014年 Yuumi Yoshida. All rights reserved.
//

#import "PostViewController.h"

#define PLACE_HOLDER_TEXT @"写真の説明など…"

@interface PostViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *photoPreviewImage;
@property (weak, nonatomic) IBOutlet UITextView *captionText;
@property (nonatomic) BOOL firstView;
@end

@implementation PostViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _firstView = YES;
    _photoPreviewImage.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_firstView) {
        [self pushSelectImage:nil];
        _firstView = NO;
        _captionText.text = PLACE_HOLDER_TEXT;
        _captionText.textColor = [UIColor lightGrayColor];
    }
}

- (IBAction)pushSelectImage:(id)sender
{
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imgPicker.delegate = self;
    [self presentViewController:imgPicker animated:YES completion:nil];
}

- (IBAction)closeKeyborad:(id)sender {
    [_captionText resignFirstResponder];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage* photo = [info objectForKey:UIImagePickerControllerOriginalImage];
    _photoPreviewImage.image = photo;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:PLACE_HOLDER_TEXT]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = PLACE_HOLDER_TEXT;
        textView.textColor = [UIColor lightGrayColor];
    }
    [textView resignFirstResponder];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    _post         = [[Post alloc]init];
    _post.caption = _captionText.text;
    _post.photo   = _photoPreviewImage.image;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
