//
//  TransitionAnimator.m
//  04UI
//
//  Created by Milos Jovanovic on 2015-05-31.
//  Copyright (c) 2015 ca.cbc. All rights reserved.
//

#import "CollectionViewController.h"
#import "ViewController.h"
#import "TransitionAnimator.h"

#define ANIM_MULTIPLIER 3.0f


@interface TransitionAnimator()

@property (strong, nonatomic) id<UIViewControllerContextTransitioning> transitionContext;

@end

@implementation TransitionAnimator



- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return ANIM_MULTIPLIER*1.0f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
 
    CollectionViewController* collectionView;
    ViewController* vc;
    
    UIViewController* sourceVC;
    UIImageView* sourceImage;
    UILabel* sourceLabel;
    UIView* sourceShadow;
    UIView* sourceContainer;
    
    UIViewController* targetVC;
    UIImageView* targetImage;
    UILabel* targetLabel;
    UIView* targetShadow;
    UIView* targetContainer;
    
    BOOL forwardTransition;
    
    if ([[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey] isKindOfClass:[CollectionViewController class]]) {
        collectionView = (CollectionViewController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        vc = (ViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        
        sourceVC = collectionView;
        targetVC = vc;
        
        sourceContainer = [collectionView.collectionView cellForItemAtIndexPath:collectionView.transitionRow];
        sourceImage = (UIImageView*)[sourceContainer viewWithTag:1];
        sourceLabel = (UILabel*)[sourceContainer viewWithTag:2];
        sourceShadow = [sourceContainer viewWithTag:3];
        
        targetContainer = vc.scrollView;
        targetImage = vc.imageView;
        targetLabel = vc.label;
        targetShadow = nil;
        
        forwardTransition = YES;
    } else {
        collectionView = (CollectionViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        vc = (ViewController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        
        sourceVC = vc;
        targetVC = collectionView;
        
        targetContainer = [collectionView.collectionView cellForItemAtIndexPath:collectionView.transitionRow];
        targetImage = (UIImageView*)[targetContainer viewWithTag:1];
        targetLabel = (UILabel*)[targetContainer viewWithTag:2];
        targetShadow = [targetContainer viewWithTag:3];
        
        sourceContainer = vc.scrollView;
        sourceImage = vc.imageView;
        sourceLabel = vc.label;
        sourceShadow = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(sourceImage.frame), CGRectGetMaxY(sourceImage.frame), CGRectGetWidth(sourceImage.frame), CGRectGetHeight(targetShadow.frame))];
        
        forwardTransition = NO;
    }
    sourceImage.hidden = YES;
    sourceLabel.hidden = YES;
    sourceShadow.hidden = YES;

    
    UIView* container = transitionContext.containerView;
    self.transitionContext = transitionContext;
    
    UIImageView* transitionImageView = [UIImageView new];
    transitionImageView.image = sourceImage.image;
    transitionImageView.bounds = sourceImage.bounds;
    transitionImageView.center = [container convertPoint:sourceImage.center fromView:sourceContainer];
    transitionImageView.contentMode = sourceImage.contentMode;
    [container addSubview:transitionImageView];
    
    UIView* transitionShadow = [UIView new];
    transitionShadow.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    transitionShadow.bounds = sourceShadow.bounds;
    transitionShadow.center = [container convertPoint:sourceShadow.center fromView:sourceContainer];
    [container addSubview:transitionShadow];
    
    UILabel* transitionLabel = [UILabel new];
    transitionLabel.text = sourceLabel.text;
    transitionLabel.font = sourceLabel.font;
    transitionLabel.textAlignment = sourceLabel.textAlignment;
    transitionLabel.textColor = sourceLabel.textColor;
    transitionLabel.bounds = sourceLabel.bounds;
    transitionLabel.center = [container convertPoint:sourceLabel.center fromView:sourceContainer];
    [container addSubview:transitionLabel];

    targetImage.hidden = YES;
    targetLabel.hidden = YES;
    targetShadow.hidden = YES;
    
    if (targetVC == vc) {
        targetVC.view.transform = CGAffineTransformMakeTranslation(0.0f, targetVC.view.frame.size.height);
        UIGraphicsBeginImageContextWithOptions(sourceVC.view.bounds.size, sourceVC.view.opaque, 0.0);
        [sourceVC.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        vc.backgroundImageView.hidden = YES;
        vc.backgroundImageView.image = img;
    }
    
    if (forwardTransition) {
        [container insertSubview:targetVC.view belowSubview:transitionImageView];
    } else {
        [container insertSubview:targetVC.view belowSubview:sourceVC.view];
    }
    

    
    [UIView animateWithDuration:ANIM_MULTIPLIER* 0.25f animations:^{

        if (!forwardTransition) {
            transitionImageView.center = [container convertPoint:targetImage.center fromView:targetContainer];
            transitionLabel.center = [container convertPoint:targetLabel.center fromView:targetContainer];
            transitionShadow.center = [container convertPoint:targetShadow.center fromView:targetContainer];
            
        }
        transitionImageView.alpha = 0.8f;
        transitionImageView.transform = CGAffineTransformTranslate(CGAffineTransformMakeScale(1.2f, 1.2f), 0.0f, 10.0f);
        transitionLabel.transform = CGAffineTransformTranslate(CGAffineTransformMakeScale(1.2f, 1.2f), 0.0f, 10.0f);
        transitionShadow.transform = CGAffineTransformTranslate(CGAffineTransformMakeScale(1.2f, 1.2f), 0.0f, 10.0f);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:ANIM_MULTIPLIER*0.25f animations:^{

            if (forwardTransition) {
                targetVC.view.transform = CGAffineTransformIdentity;
            } else {
                sourceVC.view.transform = CGAffineTransformMakeTranslation(0.0f, targetVC.view.frame.size.height);
            }
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:ANIM_MULTIPLIER*0.25f animations:^{
                if (forwardTransition) {
                    transitionShadow.transform = CGAffineTransformIdentity;
                    transitionShadow.alpha = 0.0f;
                } else {
                    transitionShadow.bounds = targetShadow.bounds;
                }
                transitionImageView.contentMode = targetImage.contentMode;
                transitionImageView.bounds = targetImage.bounds;
                transitionImageView.center = [container convertPoint:targetImage.center fromView:targetContainer];
                transitionLabel.center = [container convertPoint:targetLabel.center fromView:targetContainer];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:ANIM_MULTIPLIER*0.25f animations:^{
                    transitionImageView.alpha = 1.0f;
                    
                    transitionImageView.transform = CGAffineTransformIdentity;
                    transitionLabel.transform = CGAffineTransformIdentity;
                    transitionShadow.transform = CGAffineTransformIdentity;
                    
                } completion:^(BOOL finished) {
                    if (targetVC == vc) {
                        vc.backgroundImageView.hidden = NO;
                    }
                    targetImage.hidden = NO;
                    targetLabel.hidden = NO;
                    targetShadow.hidden = NO;
                    [transitionImageView removeFromSuperview];
                    [transitionLabel removeFromSuperview];
                    [transitionShadow removeFromSuperview];
                    [transitionContext completeTransition:YES];
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
