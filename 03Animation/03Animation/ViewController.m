//
//  ViewController.m
//  03Animation
//
//  Created by Milos Jovanovic on 2015-06-03.
//  Copyright (c) 2015 ca.cbc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (assign, nonatomic) CGFloat animationRate;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.animationRate = 1.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)starPulse:(id)sender {
    UIButton* star = (UIButton*)sender;
    [UIView animateWithDuration:0.2 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        star.transform = CGAffineTransformMakeScale(1.3, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            star.transform = CGAffineTransformMakeScale(1.1, 1.3);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
                star.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                
            }];
            
        }];
        
    }];
}

- (IBAction)starPop:(id)sender {
    
    UIButton* star = (UIButton*)sender;
    [UIView animateWithDuration:0.2 delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        star.transform = CGAffineTransformMakeScale(0.000001, 0.000001);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 delay:0.7f options:UIViewAnimationOptionCurveEaseOut animations:^{
            star.transform = CGAffineTransformMakeScale(1.2, 1.2);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
                star.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
            }];
        }];
    }];
}

- (IBAction)star1UP:(id)sender {
    UIButton* star = (UIButton*)sender;
    
    CATransform3D t0 = CATransform3DMakeTranslation(0, -3*CGRectGetHeight(star.frame), 0);
    
    CABasicAnimation *lift = [CABasicAnimation animationWithKeyPath:@"transform"];
    [lift setToValue:[NSValue valueWithCATransform3D:t0]];
    lift.fillMode = kCAFillModeForwards;
    lift.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    lift.duration = 0.4f;

    CABasicAnimation *shrink = [CABasicAnimation animationWithKeyPath:@"transform"];
    CATransform3D t1 =  CATransform3DScale(t0, 0.8f, 0.8f, 1.0f);
    [shrink setToValue:[NSValue valueWithCATransform3D:t1]];
    shrink.fillMode = kCAFillModeForwards;
    shrink.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    shrink.beginTime = lift.duration - 0.1;
    shrink.duration = 0.1f;

    CABasicAnimation *pop = [CABasicAnimation animationWithKeyPath:@"transform"];
    CATransform3D t2 = CATransform3DScale(t0, 1.4f, 1.4f, 1.0f);
    pop.beginTime = shrink.beginTime + shrink.duration;
    [pop setToValue:[NSValue valueWithCATransform3D:t2]];
    pop.fillMode = kCAFillModeForwards;
    pop.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    pop.duration = 0.2f;

    CABasicAnimation *deflate = [CABasicAnimation animationWithKeyPath:@"transform"];
    deflate.beginTime = pop.beginTime+pop.duration;
    [deflate setToValue:[NSValue valueWithCATransform3D:t1]];
    deflate.fillMode = kCAFillModeForwards;
    deflate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    deflate.duration = 0.2f;
    
    CABasicAnimation *fall = [CABasicAnimation animationWithKeyPath:@"transform"];
    fall.beginTime = deflate.beginTime+deflate.duration+0.05f;
    [fall setToValue:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
    fall.fillMode = kCAFillModeForwards;
    fall.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    fall.duration = 0.3f;
    
    CAAnimationGroup *oneUping = [CAAnimationGroup animation];
    oneUping.animations = [NSArray arrayWithObjects: lift, shrink, pop, deflate, fall, nil];
    oneUping.duration = fall.beginTime + fall.duration;
    oneUping.beginTime = CACurrentMediaTime();
    oneUping.autoreverses = NO;
    
    oneUping.removedOnCompletion = NO;
    oneUping.fillMode = kCAFillModeForwards;
    [oneUping setValue:star forKey:@"layer"];
    oneUping.delegate = self;
    
    
    
    [star.layer addAnimation:oneUping forKey:@"oneUp"];

    
}


- (IBAction)starBounce:(id)sender {
    UIButton* star = (UIButton*)sender;
    
    CATransform3D t0 = CATransform3DMakeTranslation(0, -3*CGRectGetHeight(star.frame), 0);
    
    CABasicAnimation *lift = [CABasicAnimation animationWithKeyPath:@"transform"];
    [lift setToValue:[NSValue valueWithCATransform3D:t0]];
    lift.fillMode = kCAFillModeForwards;
    lift.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    lift.duration = 0.4f;
    
    CABasicAnimation *fall = [CABasicAnimation animationWithKeyPath:@"transform"];
    fall.beginTime = lift.beginTime+lift.duration+0.1f;
    [fall setToValue:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
    fall.fillMode = kCAFillModeForwards;
    fall.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    fall.duration = 0.3f;
    
    CABasicAnimation *bigBounceLift = [CABasicAnimation animationWithKeyPath:@"transform"];
    [bigBounceLift setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, -CGRectGetHeight(star.frame), 0)]];
    bigBounceLift.beginTime = fall.beginTime+fall.duration;
    bigBounceLift.fillMode = kCAFillModeForwards;
    bigBounceLift.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    bigBounceLift.duration = 0.2f;
    
    CABasicAnimation *bigBounceFall = [CABasicAnimation animationWithKeyPath:@"transform"];
    bigBounceFall.beginTime = bigBounceLift.beginTime+bigBounceLift.duration+0.05f;
    [bigBounceFall setToValue:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
    bigBounceFall.fillMode = kCAFillModeForwards;
    bigBounceFall.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    bigBounceFall.duration = 0.15f;

    CABasicAnimation *lilBounceLift = [CABasicAnimation animationWithKeyPath:@"transform"];
    [lilBounceLift setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, -0.3*CGRectGetHeight(star.frame), 0)]];
    lilBounceLift.beginTime = bigBounceFall.beginTime+bigBounceFall.duration;
    lilBounceLift.fillMode = kCAFillModeForwards;
    lilBounceLift.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    lilBounceLift.duration = 0.15f;
    
    CABasicAnimation *lilBounceFall = [CABasicAnimation animationWithKeyPath:@"transform"];
    lilBounceFall.beginTime = lilBounceLift.beginTime+lilBounceLift.duration+0.05f;
    [lilBounceFall setToValue:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
    lilBounceFall.fillMode = kCAFillModeForwards;
    lilBounceFall.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    lilBounceFall.duration = 0.1f;

    
    
    CAAnimationGroup *bounce = [CAAnimationGroup animation];
    bounce.animations = [NSArray arrayWithObjects: lift, fall, bigBounceLift, bigBounceFall, lilBounceLift, lilBounceFall, nil];
    bounce.duration = lilBounceFall.beginTime + lilBounceFall.duration;
    bounce.beginTime = CACurrentMediaTime();
    bounce.autoreverses = NO;
    
    bounce.removedOnCompletion = NO;
    bounce.fillMode = kCAFillModeForwards;
    [bounce setValue:star forKey:@"layer"];
    bounce.delegate = self;
    
    
    
    [star.layer addAnimation:bounce forKey:@"bounce"];
}


- (IBAction)starWobble:(id)sender {
    UIButton* star = (UIButton*)sender;
    
    
    CABasicAnimation *cc = [CABasicAnimation animationWithKeyPath:@"transform"];
    [cc setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeRotation(-M_PI/16, 0.0f, 0.0f, 1.0f)]];
    cc.fillMode = kCAFillModeForwards;
    cc.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    cc.duration = 0.1f;

    CABasicAnimation *c = [CABasicAnimation animationWithKeyPath:@"transform"];
    [c setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, 1, 0)]];
    c.beginTime = cc.beginTime + cc.duration;
    c.fillMode = kCAFillModeForwards;
    c.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    c.duration = 0.1f;
    
    
    CAAnimationGroup *wobble = [CAAnimationGroup animation];
    wobble.animations = [NSArray arrayWithObjects: cc, c, nil];
    wobble.duration = c.beginTime + c.duration;
    wobble.beginTime = CACurrentMediaTime();
    wobble.autoreverses = NO;
    wobble.repeatCount = 20;
    wobble.removedOnCompletion = YES;
    wobble.fillMode = kCAFillModeForwards;
    [wobble setValue:star forKey:@"layer"];
    wobble.delegate = self;

    [star.layer addAnimation:wobble forKey:@"wobble"];
}

- (IBAction)starJump:(id)sender {
    UIButton* star = (UIButton*)sender;
    
    CABasicAnimation *squat = [CABasicAnimation animationWithKeyPath:@"transform"];
    [squat setToValue:[NSValue valueWithCATransform3D:CATransform3DTranslate(CATransform3DMakeScale(1.2, 0.8, 1.0), 0, 0.2*CGRectGetHeight(star.frame), 0)]];
    squat.fillMode = kCAFillModeForwards;
    squat.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    squat.duration = 0.4f;
    
    
    CABasicAnimation *lift = [CABasicAnimation animationWithKeyPath:@"transform"];
    [lift setToValue:[NSValue valueWithCATransform3D:CATransform3DScale(  CATransform3DMakeTranslation(0, -3*CGRectGetHeight(star.frame), 0), 0.95f, 1.4f, 1.0f) ]];
    lift.beginTime = squat.beginTime+squat.duration+0.3f;
    lift.fillMode = kCAFillModeForwards;
    lift.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    lift.duration = 0.4f;
    
    CABasicAnimation *fall = [CABasicAnimation animationWithKeyPath:@"transform"];
    fall.beginTime = lift.beginTime+lift.duration+0.1f;
    [fall setToValue:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
    fall.fillMode = kCAFillModeForwards;
    fall.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    fall.duration = 0.4f;
    
    CABasicAnimation *squish = [CABasicAnimation animationWithKeyPath:@"transform"];
    [squish setToValue:[NSValue valueWithCATransform3D:CATransform3DTranslate(CATransform3DMakeScale(1.2f, 0.9f, 1.0f), 0,  0.1*CGRectGetHeight(star.frame), 0)]];
    squish.beginTime = fall.beginTime+fall.duration;
    squish.fillMode = kCAFillModeForwards;
    squish.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    squish.duration = 0.15f;
    
    CABasicAnimation *stand = [CABasicAnimation animationWithKeyPath:@"transform"];
    stand.beginTime = squish.beginTime+squish.duration;
    [stand setToValue:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
    stand.fillMode = kCAFillModeForwards;
    stand.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    stand.duration = 0.1f;
    
    
    CAAnimationGroup *jump = [CAAnimationGroup animation];
    jump.animations = [NSArray arrayWithObjects: squat, lift, fall, squish, stand, nil];
    jump.duration = stand.beginTime + stand.duration;
    jump.beginTime = CACurrentMediaTime();
    jump.autoreverses = NO;
    
    jump.removedOnCompletion = NO;
    jump.fillMode = kCAFillModeForwards;
    [jump setValue:star forKey:@"layer"];
    jump.delegate = self;
    
    
    
    [star.layer addAnimation:jump forKey:@"jump"];
}

@end
