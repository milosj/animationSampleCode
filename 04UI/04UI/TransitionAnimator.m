//
//  TransitionAnimator.m
//  04UI
//
//  Created by Milos Jovanovic on 2015-05-31.
//  Copyright (c) 2015 ca.cbc. All rights reserved.
//

#import "TableViewController.h"
#import "ViewController.h"
#import "TransitionAnimator.h"


@interface TransitionAnimator()

@property (strong, nonatomic) id<UIViewControllerContextTransitioning> transitionContext;

@end

@implementation TransitionAnimator



- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.75f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
 
    TableViewController* tableView;
    ViewController* vc;
    if ([[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey] isKindOfClass:[TableViewController class]]) {
        tableView = (TableViewController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        vc = (ViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    } else {
        tableView = (TableViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        vc = (ViewController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    }
    UIView* container = transitionContext.containerView;
    self.transitionContext = transitionContext;

    UITableViewCell* cell = [tableView.tableView cellForRowAtIndexPath:[tableView.tableView indexPathForSelectedRow]];
    UIImageView* cellImage = (UIImageView*)[cell viewWithTag:1];
    UILabel* cellLabel = (UILabel*)[cell viewWithTag:2];
    UIView* cellShadow = [cell viewWithTag:3];
    
    UIImageView* transitionImageView = [UIImageView new];
    transitionImageView.image = cellImage.image;
    transitionImageView.bounds = cellImage.bounds;
    transitionImageView.center = [container convertPoint:cellImage.center fromView:cell];
    [container addSubview:transitionImageView];
    
    UIView* shadowView = [UIView new];
    shadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    shadowView.bounds = cellShadow.bounds;
    shadowView.center = [container convertPoint:cellShadow.center fromView:cell];
    [container addSubview:shadowView];
    
    UILabel* transitionLabel = [UILabel new];
    transitionLabel.text = cellLabel.text;
    transitionLabel.font = cellLabel.font;
    transitionLabel.textAlignment = cellLabel.textAlignment;
    transitionLabel.textColor = cellLabel.textColor;
    transitionLabel.bounds = cellLabel.bounds;
    transitionLabel.center = [container convertPoint:cellLabel.center fromView:cell];
    [container addSubview:transitionLabel];

    
    vc.imageView.hidden = YES;
    vc.label.hidden = YES;
    vc.view.transform = CGAffineTransformMakeTranslation(0.0f, vc.view.frame.size.height);

    [container insertSubview:vc.view belowSubview:transitionImageView];

    
    [UIView animateWithDuration:1.25f animations:^{
        transitionImageView.transform = CGAffineTransformTranslate(CGAffineTransformMakeScale(1.2f, 1.2f), 0.0f, 10.0f);
        transitionLabel.transform = CGAffineTransformTranslate(CGAffineTransformMakeScale(1.2f, 1.2f), 0.0f, 10.0f);
        shadowView.transform = CGAffineTransformTranslate(CGAffineTransformMakeScale(1.2f, 1.2f), 0.0f, 10.0f);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.25f animations:^{
            vc.view.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:1.25f animations:^{
                transitionImageView.transform = CGAffineTransformIdentity;
                transitionLabel.transform = CGAffineTransformIdentity;
                shadowView.transform = CGAffineTransformIdentity;
                [vc viewWillAppear:YES];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:1.25f animations:^{
                    shadowView.transform =                 CGAffineTransformScale(CGAffineTransformTranslate(shadowView.transform, 0.0f, shadowView.frame.size.height), 1.0f, 0.0001f) ;

                    transitionImageView.center = [container convertPoint:vc.imageView.center fromView:vc.view];
                    transitionLabel.center = [container convertPoint:vc.label.center fromView:vc.view];
                            transitionLabel.textColor = vc.label.textColor;
                } completion:^(BOOL finished) {
                    vc.imageView.hidden = NO;
                    vc.label.hidden = NO;
                    [transitionImageView removeFromSuperview];
                    [transitionLabel removeFromSuperview];
                    [vc viewDidAppear:YES];
                }];
            }];
            
        }];
    }];
    
    
//    CABasicAnimation* moveImageAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
//    moveImageAnimation.toValue = [NSValue valueWithCGPoint:vc.imageView.layer.position];
//    moveImageAnimation.duration = [self transitionDuration:transitionContext];
//    moveImageAnimation.delegate = self;
//    [transitionImageView.layer addAnimation:moveImageAnimation forKey:@"position"];
    
//    maskLayerAnimation.toValue = [NSValue ]
//    maskLayerAnimation.duration = self.transitionDuration(transitionContext)
//    maskLayerAnimation.delegate = self
//    maskLayer.addAnimation(maskLayerAnimation, forKey: "path")
}

@end
