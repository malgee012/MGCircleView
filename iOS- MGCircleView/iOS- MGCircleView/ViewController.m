//
//  ViewController.m
//  iOS- MGCircleView
//
//  Created by acmeway on 17/3/13.
//  Copyright © 2017年 acmeway. All rights reserved.
//

#import "ViewController.h"
#import "UIColor+Extensions.h"
#import "UIView+Frame.h"
#import "MGCircleAnimationView.h"


#define LRScreenWidth [UIScreen mainScreen].bounds.size.width
#define LRScreenHeight [UIScreen mainScreen].bounds.size.height


@interface ViewController ()

@property (nonatomic, weak) MGCircleAnimationView *circleView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHex:@"999999"];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake((LRScreenWidth-0.5)/2.0, 0, 0.5, LRScreenHeight)];
    
    line.centerX = self.view.centerX;
    
    line.backgroundColor = [UIColor colorWithHex:@"2e2e2e"];
    
    [self.view addSubview:line];
    

    MGCircleAnimationView *circleView = [[MGCircleAnimationView alloc] initWithFrame:CGRectMake(40, 130, LRScreenWidth-80, LRScreenWidth-80)];
    self.circleView = circleView;
    circleView.backgroundColor = [UIColor colorWithHex:@"2e2e2e"];
    
    [circleView setIdeallyValue:100.0];
    
    [circleView setPercent:60];
    
    [self.view addSubview:circleView];
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    
    [self.circleView setPercent:60];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
