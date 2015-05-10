//
//  ViewController.m
//  02Animation
//
//  Created by Milos Jovanovic on 2015-05-02.
//  Copyright (c) 2015 ca.cbc. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/CAAnimation.h>

@interface ViewController () {
    CGFloat xRotation, zRotation;
    CGFloat scale;
    CGFloat xTranslation, yTranslation;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    scale = 1.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CATransform3D)currentTransformation {
    CATransform3D t = CATransform3DIdentity;
    t = CATransform3DScale(t, scale, scale, 1.0);
    t = CATransform3DTranslate(t, xTranslation, yTranslation, 0);

    t = CATransform3DRotate(t, zRotation, 0, 0, 1.0f);
    t = CATransform3DRotate(t, xRotation, 1.0f, 0, 0);
    return t;
}

- (void)animateImageFromTransformation:(CATransform3D)from toTransformation:(CATransform3D)to {
//    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//        image.layer.transform = [self currentTransformation];
//    } completion:^(BOOL finished) {
//        
//    }];
    CABasicAnimation* ani = [CABasicAnimation animationWithKeyPath:@"transform"];
    ani.fillMode = kCAFillModeForwards;
    ani.fromValue = [NSValue valueWithCATransform3D:from];
    ani.toValue = [NSValue valueWithCATransform3D:to];
    ani.duration = 0.5f;
    ani.beginTime = CACurrentMediaTime();
    ani.removedOnCompletion = NO;
    [image.layer addAnimation:ani forKey:@"ani"];
}

- (IBAction)up:(id)sender {
    CATransform3D from = [self currentTransformation];
    yTranslation -= 20;
    CATransform3D to = [self currentTransformation];
    [self animateImageFromTransformation:from toTransformation:to];
}

- (IBAction)down:(id)sender {
    CATransform3D from = [self currentTransformation];
    yTranslation += 20;
    CATransform3D to = [self currentTransformation];
    [self animateImageFromTransformation:from toTransformation:to];
}

- (IBAction)left:(id)sender {
    CATransform3D from = [self currentTransformation];
    xTranslation -= 20;
    CATransform3D to = [self currentTransformation];
    [self animateImageFromTransformation:from toTransformation:to];
}

- (IBAction)right:(id)sender {
    CATransform3D from = [self currentTransformation];
    xTranslation += 20;
    CATransform3D to = [self currentTransformation];
    [self animateImageFromTransformation:from toTransformation:to];
}

- (IBAction)rotateCCW:(id)sender {
    CATransform3D from = [self currentTransformation];
    zRotation -= 0.25f*M_PI;
    CATransform3D to = [self currentTransformation];
    [self animateImageFromTransformation:from toTransformation:to];
}

- (IBAction)rotateCW:(id)sender {
    CATransform3D from = [self currentTransformation];
    zRotation += 0.25f*M_PI;
    CATransform3D to = [self currentTransformation];
    [self animateImageFromTransformation:from toTransformation:to];
}

- (IBAction)rotateIn:(id)sender {
    CATransform3D from = [self currentTransformation];
    xRotation += 0.1f*M_PI;
    CATransform3D to = [self currentTransformation];
    [self animateImageFromTransformation:from toTransformation:to];
}

- (IBAction)rotateOut:(id)sender {
    CATransform3D from = [self currentTransformation];
    xRotation -= 0.1f*M_PI;
    CATransform3D to = [self currentTransformation];
    [self animateImageFromTransformation:from toTransformation:to];
}

- (IBAction)scaleUp:(id)sender {
    CATransform3D from = [self currentTransformation];
    scale += 0.1;
    CATransform3D to = [self currentTransformation];
    [self animateImageFromTransformation:from toTransformation:to];
}

- (IBAction)scaleDown:(id)sender {
    CATransform3D from = [self currentTransformation];
    scale -= 0.1;
    CATransform3D to = [self currentTransformation];
    [self animateImageFromTransformation:from toTransformation:to];
}

- (IBAction)reset:(id)sender {
    CATransform3D from = [self currentTransformation];
    xRotation = 0;
    zRotation = 0;
    scale = 1.0f;
    xTranslation = 0;
    yTranslation = 0;
    CATransform3D to = [self currentTransformation];
    [self animateImageFromTransformation:from toTransformation:to];
}

- (IBAction)perspectiveChanged:(UISlider*)sender {
    CATransform3D t = CATransform3DIdentity;
    t.m34 = 1.0/-sender.value;
    self.view.layer.sublayerTransform = t;

}




@end
