//
//  ViewController.m
//  01UI
//
//  Created by Milos Jovanovic on 2015-05-28.
//  Copyright (c) 2015 ca.cbc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) CIFilter* bump;
@property (strong, nonatomic) CIContext *context;
@property (strong, nonatomic) CIImage *baseImage;
@property (strong, nonatomic) NSOperationQueue* workQueue;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //set up a filter instance and context
    //we want to do only once for perfomance reasons
    self.bump = [CIFilter filterWithName:@"CIHoleDistortion"];
    [self.bump setValue:[CIVector vectorWithCGPoint:CGPointMake(187, 282)] forKey:kCIInputCenterKey];
    [self.bump setValue:@100 forKey:kCIInputRadiusKey];
    self.context = [CIContext contextWithOptions:nil];
    
    //set up a background queue to do CI work
    self.workQueue = [NSOperationQueue new];

}

- (void)viewDidAppear:(BOOL)animated {
    //load the base image to apply filters to
    //we're loading it in x1 to simplify this code
    UIImage* uiimage = [UIImage imageWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tvtest" ofType:@"png"]] scale:1.0f];
    CGImageRef cgimage = [uiimage CGImage];
    self.baseImage = [[CIImage alloc] initWithCGImage:cgimage];
    [self.bump setValue:self.baseImage forKey:kCIInputImageKey];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat dY = scrollView.contentOffset.y;
    if (dY < 0) { //if pulling down
        if (self.workQueue.operationCount < 5) { //we'll keep a number of operations to a minimum to reduce lag
            [self.workQueue addOperationWithBlock:^{
                //find where the user's finger is
                CGPoint touchPoint = [scrollView.panGestureRecognizer locationInView:scrollView];
                //center the distortion above the finger
                [self.bump setValue:[CIVector vectorWithCGPoint:CGPointMake(touchPoint.x, self.imageView.frame.size.height)] forKey:kCIInputCenterKey];
                //increase the radius of the distortion the more the user pulls the scroll view
                [self.bump setValue:[NSNumber numberWithFloat:-dY] forKey:kCIInputRadiusKey];
                //get the filtered image
                CIImage *result = [self.bump valueForKey:kCIOutputImageKey];
                //transform it into something we can use
                CGImageRef cgImage = [self.context createCGImage:result fromRect:result.extent];
                UIImage* filteredImage = [UIImage imageWithCGImage:cgImage];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //update the imageView
                    self.imageView.image = filteredImage;
                });
            }];
        }
    }
}


@end
