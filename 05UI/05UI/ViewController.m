//
//  ViewController.m
//  04UI
//
//  Created by Milos Jovanovic on 2015-05-29.
//  Copyright (c) 2015 ca.cbc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (assign, nonatomic) CGRect imageViewOriginalFrame;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.imageView.image = self.image;
    self.label.text = self.text;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.imageViewOriginalFrame = self.imageView.frame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    
}

- (CGAffineTransform)transformForImage {
    CGAffineTransform t = CGAffineTransformMakeScale(self.scrollView.zoomScale, self.scrollView.zoomScale);
    if (self.scrollView.zoomScale >= 1.0f) {
        t = CGAffineTransformTranslate(t, (self.scrollView.zoomScale-1.0f)*CGRectGetWidth(self.imageViewOriginalFrame)/2, 0);
    } else {
        t = CGAffineTransformTranslate(t, (1.0f-self.scrollView.zoomScale)*CGRectGetWidth(self.imageViewOriginalFrame)/2, 0);
    }
    return t;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGAffineTransform t = [self transformForImage];
//    self.descriptionLabel.transform = t;
    self.imageView.transform = t;

}

@end
