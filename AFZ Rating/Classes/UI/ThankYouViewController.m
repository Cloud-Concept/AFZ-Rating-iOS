//
//  ThankYouViewController.m
//  AFZ Rating
//
//  Created by Mina Zaklama on 11/4/14.
//  Copyright (c) 2014 Cloud Concept. All rights reserved.
//

#import "ThankYouViewController.h"

@interface ThankYouViewController ()

@end

@implementation ThankYouViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self performSelector:@selector(returnToRootView) withObject:nil afterDelay:5.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)returnToRootView
{
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.dwc.ae"]];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
