//
//  ViewController.m
//  01Animation
//
//  Created by Milos Jovanovic on 2015-05-02.
//
//  Copyright (c) 2015 Milos Jovanovic
//
//Licensed under the Apache License, Version 2.0 (the "License");
//you may not use this file except in compliance with the License.
//You may obtain a copy of the License at
//
//http://www.apache.org/licenses/LICENSE-2.0
//
//Unless required by applicable law or agreed to in writing, software
//distributed under the License is distributed on an "AS IS" BASIS,
//WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//See the License for the specific language governing permissions and
//limitations under the License.


#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tappedAButton:(id)sender {
//    //example 1: simple animation
//    [UIView animateWithDuration:0.5f animations:^{
//        aButton.center = CGPointMake(100, 100);
//    }];
    
//    //example 2: transform
//    [UIView animateWithDuration:0.5f animations:^{
//        aButton.transform = CGAffineTransformMakeTranslation(-200, -200);
//    }];

//    //example 3: transform and back
//    static BOOL isTranslated = NO;
//    [UIView animateWithDuration:0.5f animations:^{
//        if (!isTranslated) {
//            aButton.transform = CGAffineTransformMakeTranslation(-200, -200);
//        } else {
//            aButton.transform = CGAffineTransformIdentity;
//        }
//        isTranslated = !isTranslated;
//    }];

//    //example 4: multiple steps
//    static int translationStep = 0;
//    [UIView animateWithDuration:0.5f animations:^{
//        switch (translationStep) {
//            case 0:
//                aButton.transform = CGAffineTransformMakeTranslation(-100, 0);
//                break;
//            case 1:
//                aButton.transform = CGAffineTransformMakeTranslation(-100, -100);
//                break;
//            case 2:
//                aButton.transform = CGAffineTransformMakeTranslation(-200, -100);
//                break;
//            case 3:
//                aButton.transform = CGAffineTransformMakeTranslation(-200, -200);
//                break;
//            case 4:
//                aButton.transform = CGAffineTransformIdentity;
//                translationStep = -1;
//                break;
//            default:
//                break;
//        }
//        translationStep++;
//    }];

    //example 5: full animation call
    static int translationStep = 0;
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        switch (translationStep) {
            case 0:
                aButton.transform = CGAffineTransformMakeTranslation(-100, 0);
                break;
            case 1:
                aButton.transform = CGAffineTransformMakeRotation(90.f);
                break;
            case 2:
                aButton.transform = CGAffineTransformMakeScale(3.0f, 3.0f);
                break;
            default:
                break;
        }
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3f animations:^{
            aButton.transform = CGAffineTransformIdentity;
            if (translationStep < 2) {
                translationStep++;
            } else {
                translationStep = 0;
            }
        }];
    }];
}


@end
