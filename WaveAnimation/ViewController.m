//
//  ViewController.m
//  WaveAnimation
//
//  Created by WXQ on 2018/9/4.
//  Copyright © 2018年 JingBei. All rights reserved.
//

#import "ViewController.h"
#import "FirstView.h"

#define K_W    66
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"波浪动画";
    [self.view addSubview:[[FirstView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-K_W)/2, 100, K_W, K_W) waveStyle:WaveAnimationStyleOne]];
    [self.view addSubview:[[FirstView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-K_W)/2, 200, K_W, K_W) waveStyle:WaveAnimationStyleTwo]];
    [self.view addSubview:[[FirstView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-K_W)/2, 300, K_W, K_W) waveStyle:WaveAnimationStyleThree]];
    [self.view addSubview:[[FirstView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-K_W)/2, 400, K_W, K_W) waveStyle:WaveAnimationStyleFour]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
