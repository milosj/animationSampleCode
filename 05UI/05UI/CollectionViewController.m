//
//  CollectionViewController.m
//  05UI
//
//  Created by Milos Jovanovic on 2015-06-02.
//  Copyright (c) 2015 ca.cbc. All rights reserved.
//

#import "ViewController.h"
#import "DMRCollectionViewLayout.h"
#import "CollectionViewController.h"

@interface CollectionViewController ()

@property (strong, nonatomic) UIImageView* imageView;
@property (strong, nonatomic) UIView* maskView;
@property (strong, nonatomic) CIFilter* bump;
@property (strong, nonatomic) CIContext *context;
@property (strong, nonatomic) NSOperationQueue* workQueue;
@property (assign, nonatomic) CGPoint lastTouchPoint;
@property (strong, nonatomic) NSMutableDictionary* images;
@property (strong, nonatomic) NSArray* data;


@end

@implementation CollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    //set up a filter instance and context
    //we want to do only once for perfomance reasons
    self.bump = [CIFilter filterWithName:@"CIHoleDistortion"];
    [self.bump setValue:@200 forKey:kCIInputRadiusKey];
    self.context = [CIContext contextWithOptions:nil];
    
    //set up a background queue to do CI work
    self.workQueue = [NSOperationQueue new];
    
    self.maskView = [UIView new];
    self.maskView.backgroundColor = [UIColor whiteColor];
    self.maskView.hidden = YES;
    [self.view addSubview:self.maskView];
    
    self.imageView = [UIImageView new];
    self.imageView.hidden = YES;
    [self.view addSubview:self.imageView];
    
    self.images = [NSMutableDictionary new];
    
    [self.collectionView setCollectionViewLayout:[DMRCollectionViewLayout new]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSURL* url = [NSURL URLWithString:@"http://cbc.ca/json/cmlink/1.3084190"];
        self.data = [[NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:url] options:0 error:nil] objectForKey:@"galleryImages"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    });
}

- (void)viewDidAppear:(BOOL)animated {
    self.maskView.frame = CGRectMake(0, self.collectionView.contentInset.top, self.view.frame.size.width, self.view.frame.size.height);
    self.imageView.frame = self.maskView.frame;
    [self.collectionView reloadData];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.data.count;
}


- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
    UILabel* label = (UILabel*)[cell viewWithTag:2];
    label.text = [self.data[indexPath.row] objectForKey:@"imageTitle"];
    UIImageView* imageView = (UIImageView*)[cell viewWithTag:1];
    if (self.images[indexPath]) {
        imageView.image = self.images[indexPath];
    } else {
        imageView.image = nil;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSArray* sizes = [self.data[indexPath.row] objectForKey:@"imageFiles"];
            NSDictionary* bestSize = [sizes lastObject];
            NSURL* url = [NSURL URLWithString:bestSize[@"file"]];
            NSData* imgData = [NSData dataWithContentsOfURL:url];
            if (imgData) {
                UIImage* img = [UIImage imageWithData:imgData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.images[indexPath] = img;
                    if ([collectionView.indexPathsForVisibleItems containsObject:indexPath]) {
                        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
                    }
                });
                
            }
        });
    }
    
    return cell;
    
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

#pragma mark <UIScrollViewDelegate>

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([self.collectionView numberOfItemsInSection:0] > 0) {
        self.maskView.hidden = YES;
        self.imageView.hidden = YES;
        
        //user began dragging - grab the screen and save it
        CGPoint previousOffset = scrollView.contentOffset;
        scrollView.contentOffset = CGPointZero; //we want the image of the top of the scrollview content
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        
        UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        CGImageRef cgImage = img.CGImage;
        CIImage* cimg = [[CIImage alloc] initWithCGImage:cgImage];
        [self.bump setValue:cimg forKey:kCIInputImageKey];
        self.imageView.image = img;
        scrollView.contentOffset = previousOffset; //return the scrollview to where it was
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    self.maskView.hidden = YES;
    self.imageView.hidden = YES;
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat dY = scrollView.contentOffset.y;
    if ([self.collectionView numberOfItemsInSection:0] > 0 && dY < -self.collectionView.contentInset.top) { //if pulling down
        //show the mask (which hides the collection view and provides white background)
        //show the imageView that will contain our filtered image
        
        self.maskView.hidden = NO;
        self.imageView.hidden = NO;
        if (self.workQueue.operationCount < 10) { //we'll keep a number of operations to a minimum to reduce lag
            //find where the user's finger is
            CGPoint touchPoint = [scrollView.panGestureRecognizer locationInView:scrollView];
            if (powf(powf(self.lastTouchPoint.x-touchPoint.x,2.0f) + powf(self.lastTouchPoint.y-touchPoint.y,2.0f),0.5f) > 5.0f) { //render only if user has moved enough pixels
                [self.workQueue addOperationWithBlock:^{
                    //center the distortion above the finger
                    [self.bump setValue:[CIVector vectorWithCGPoint:CGPointMake(touchPoint.x*self.traitCollection.displayScale, self.view.frame.size.height*self.traitCollection.displayScale-dY)] forKey:kCIInputCenterKey];
                    //increase the radius of the distortion the more the user pulls the scroll view
                    [self.bump setValue:[NSNumber numberWithFloat:-2*dY] forKey:kCIInputRadiusKey];
                    //get the filtered image
                    CIImage *result = [self.bump valueForKey:kCIOutputImageKey];
                    //transform it into something we can use
                    CGImageRef cgImage = [self.context createCGImage:result fromRect:result.extent];
                    UIImage* filteredImage = [UIImage imageWithCGImage:cgImage];
                    CGImageRelease(cgImage);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //update the imageView
                        self.imageView.image = filteredImage;
                    });
                }];
            }
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSIndexPath* selectedCellIndexPath = [self.collectionView indexPathForCell:sender];
    self.transitionRow = selectedCellIndexPath;
    ViewController* vc = (ViewController*)segue.destinationViewController;
    
    vc.image = self.images[selectedCellIndexPath];
    vc.text = [self.data[selectedCellIndexPath.row] objectForKey:@"imageTitle"];
    
}


@end
