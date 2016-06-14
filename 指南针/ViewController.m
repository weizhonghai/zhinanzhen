//
//  ViewController.m
//  指南针
//
//  Created by 魏忠海 on 16/6/14.
//  Copyright © 2016年 魏忠海. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
@interface ViewController ()<CLLocationManagerDelegate>
{
    CALayer *znzLayer;
}
@property (nonatomic, strong) CLLocationManager *cllocationM;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //如果磁力可用，则开始监听方向改变
    if (![CLLocationManager headingAvailable]) {
        //创建显示方向的指南针图片layer
        znzLayer = [[CALayer alloc]init];
        NSInteger screenHeight = [UIScreen mainScreen].bounds.size.height;
        NSInteger y = (screenHeight - 320) / 2;
        znzLayer.frame = CGRectMake(0, y, 320, 320);
        //设置znzLayer 显示的图片
        znzLayer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"2"].CGImage);
        [self.view.layer addSublayer:znzLayer];
//        znzLayer.backgroundColor = [UIColor blueColor].CGColor;
        self.cllocationM = [[CLLocationManager alloc]init];
        self.cllocationM.delegate = self;
        [self.cllocationM startUpdatingHeading];
    }else{
        NSLog(@"您的设备磁力不可用");
    }
}
#pragma mark
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    //将设备的方向角度换算成弧度
    CGFloat headings = -1 * M_PI *newHeading.magneticHeading / 180;
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform"];
    CATransform3D fromValue = znzLayer.transform;
    //设置动画开始的属性值
    anim.fromValue = [NSValue valueWithCATransform3D:fromValue];
    //绕Z轴旋转heading弧度的变换矩阵
    CATransform3D toValue = CATransform3DMakeRotation(headings, 0, 0, 1);
    //设置动画结束的属性
    anim.toValue = [NSValue valueWithCATransform3D:toValue];
    anim.duration = 0.5;
    anim.removedOnCompletion = YES;
    //设置动画结束后znzlay的变换矩阵
    znzLayer.transform = toValue;
    [znzLayer addAnimation:anim forKey:nil];
}
- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager{
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
