//
//  ViewController.m
//  NHACKSDKPro
//
//  Created by hu jiaju on 16/2/20.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "ViewController.h"
#import "ACKApi.h"

@interface ViewController ()

@property (nullable, nonatomic, strong) UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CGRect bounds = CGRectMake(100, 50, 200, 50);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = bounds;
    [btn setTitle:@"register" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(registerEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    bounds.origin.y += 100;
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = bounds;
    [btn setTitle:@"authentication" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(authenticationEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    bounds.origin.y += 100;
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = bounds;
    [btn setTitle:@"purchase" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(purchaseEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    bounds.origin.y += 100;
    _label = [[UILabel alloc] initWithFrame:bounds];
    [self.view addSubview:_label];
    
    NSString *sdkVersion = [ACKApi version];
    NSLog(@"ack sdk's version :%@",sdkVersion);
}

- (void)registerEvent {
    NSString *m_phone = [NSString stringWithFormat:@"1302362xxxx"];
    BOOL ret = [ACKApi registerWithUserAccount:m_phone];
    [self.label setText:ret?@"1":@"0"];
    NSLog(@"result : %zd",ret);
}

- (void)authenticationEvent {
    NSString *m_phone = [NSString stringWithFormat:@"1302362xxxx"];
    BOOL ret = [ACKApi authenticationWithName:@"张三" withPhone:m_phone withID:@"410222xxxxxxxx1552"];
    [self.label setText:ret?@"1":@"0"];
    NSLog(@"result : %zd",ret);
}

- (void)purchaseEvent {
    NSString *m_phone = [NSString stringWithFormat:@"1302362xxxx"];
    BOOL ret = [ACKApi purchase:@1000 forAccount:m_phone];
    [self.label setText:ret?@"1":@"0"];
    NSLog(@"result : %zd",ret);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
