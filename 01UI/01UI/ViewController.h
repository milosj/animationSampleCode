//
//  ViewController.h
//  01UI
//
//  Created by Milos Jovanovic on 2015-05-28.
//  Copyright (c) 2015 ca.cbc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

