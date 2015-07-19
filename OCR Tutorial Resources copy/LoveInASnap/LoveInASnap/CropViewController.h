//
//  CropViewController.h
//  LoveInASnap
//
//  Created by Chris Beyer on 7/19/15.
//  Copyright (c) 2015 Lyndsey Scott. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageCropView.h"

@interface CropViewController : UIViewController <ImageCropViewControllerDelegate> {
  ImageCropView* imageCropView;
  UIImage* image;
  IBOutlet UIImageView *imageView;
}
@property (nonatomic, strong) IBOutlet ImageCropView* imageCropView;
- (void)cropImage:(UIImage *)image;


@end
