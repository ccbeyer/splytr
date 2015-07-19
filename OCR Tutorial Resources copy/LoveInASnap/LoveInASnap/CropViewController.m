//
//  CropViewController.m
//  LoveInASnap
//
//  Created by Chris Beyer on 7/19/15.
//  Copyright (c) 2015 Lyndsey Scott. All rights reserved.
//

#import "CropViewController.h"
#import "ImageCropView.h"

@interface CropViewController ()

@end

@implementation CropViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)cropImage:(UIImage *)image{
  ImageCropViewController *controller = [[ImageCropViewController alloc] initWithImage:image];
  controller.delegate = self;
  [[self navigationController] pushViewController:controller animated:YES];
}
- (void)ImageCropViewController:(ImageCropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage{
  image = croppedImage;
  imageView.image = croppedImage;
  [[self navigationController] popViewControllerAnimated:YES];
}
- (void)ImageCropViewControllerDidCancel:(ImageCropViewController *)controller{
  imageView.image = image;
  [[self navigationController] popViewControllerAnimated:YES];
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
