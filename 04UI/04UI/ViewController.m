//
//  ViewController.m
//  04UI
//
//  Created by Milos Jovanovic on 2015-05-29.
//  Copyright (c) 2015 ca.cbc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

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
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    [self.scrollView setContentSize:CGSizeMake(window.frame.size.width, window.frame.size.height)];
    [self.view layoutIfNeeded];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

@end
