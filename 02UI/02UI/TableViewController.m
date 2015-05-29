//
//  TableViewController.m
//  02UI
//
//  Created by Milos Jovanovic on 2015-05-28.
//  Copyright (c) 2015 ca.cbc. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController ()
@property (strong, nonatomic) UIImageView* imageView;
@property (strong, nonatomic) UIView* maskView;
@property (strong, nonatomic) CIFilter* bump;
@property (strong, nonatomic) CIContext *context;
@property (strong, nonatomic) NSOperationQueue* workQueue;
@property (assign, nonatomic) CGFloat lastGeneratedY;
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    //set up a filter instance and context
    //we want to do only once for perfomance reasons
    self.bump = [CIFilter filterWithName:@"CIHoleDistortion"];
    [self.bump setValue:[CIVector vectorWithCGPoint:CGPointMake(187, 282)] forKey:kCIInputCenterKey];
    [self.bump setValue:@100 forKey:kCIInputRadiusKey];
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
}

- (void)viewDidAppear:(BOOL)animated {
    self.maskView.frame = self.view.bounds;
    self.imageView.frame = self.view.bounds;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return 10;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"imageCell" forIndexPath:indexPath];
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {


    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    CGImageRef cgImage = img.CGImage;
    CIImage* cimg = [[CIImage alloc] initWithCGImage:cgImage];
    [self.bump setValue:cimg forKey:kCIInputImageKey];
    self.imageView.image = img;

    self.maskView.hidden = NO;
    self.imageView.hidden = NO;

}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    self.maskView.hidden = YES;
    self.imageView.hidden = YES;

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat dY = scrollView.contentOffset.y;
    if (dY < 0) { //if pulling down
        if (self.workQueue.operationCount < 3) { //we'll keep a number of operations to a minimum to reduce lag
            self.lastGeneratedY = dY;
            [self.workQueue addOperationWithBlock:^{
                //find where the user's finger is
                CGPoint touchPoint = [scrollView.panGestureRecognizer locationInView:scrollView];
                //center the distortion above the finger
                [self.bump setValue:[CIVector vectorWithCGPoint:CGPointMake(touchPoint.x*self.traitCollection.displayScale, self.view.frame.size.height*self.traitCollection.displayScale)] forKey:kCIInputCenterKey];
                //increase the radius of the distortion the more the user pulls the scroll view
                [self.bump setValue:[NSNumber numberWithFloat:-MIN(150, dY)] forKey:kCIInputRadiusKey];
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


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
