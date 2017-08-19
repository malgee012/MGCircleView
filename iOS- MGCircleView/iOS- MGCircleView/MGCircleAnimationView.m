//
//  MGCircleAnimationView.m
//  iOS- MGCircleView
//
//  Created by acmeway on 17/3/13.
//  Copyright © 2017年 acmeway. All rights reserved.
//

#import "MGCircleAnimationView.h"
#import "UIView+Frame.h"
#import "UIColor+Extensions.h"
#import "MGIndicatorView.h"


#define LRScreenWidth [UIScreen mainScreen].bounds.size.width
#define LRScreenHeight [UIScreen mainScreen].bounds.size.height

// 角度 & 弧度 互换
#define RADIANS_TO_DEGREES(x) ((x)/M_PI*180.0)  // π换成角度

#define DEGREES_TO_RADIANS(x) ((x)/180.0*M_PI)  // 角度换成π

#define degreesToRadians(x) (M_PI*(x)/180.0) //把角度转换成PI的方式


static const CGFloat kAnimationTime = 2;    // 动画时长

@interface MGCircleAnimationView ()

@property (nonatomic, strong) CAShapeLayer      *bottomLayer;    // 进度条底色

@property (nonatomic, strong) CAShapeLayer      *progressLayer;  // 进度

@property (nonatomic, assign) CGFloat lineWidth;            // 弧线宽度

@property (nonatomic, assign) CGFloat stareAngle;           // 开始角度

@property (nonatomic, assign) CGFloat endAngle;             // 结束角度

@property (nonatomic, strong) MGIndicatorView       *indicatorView;

@end

@implementation MGCircleAnimationView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.lineWidth = self.frame.size.width*0.06;
        
        self.stareAngle = -90;
        
        self.endAngle = 270;
        
        [self setupSubviews];
        
    }
    return self;
}

- (void)setupSubviews
{
    //  设置路径
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.width / 2, self.height / 2)
                                                        radius:self.width * 0.4
                                                    startAngle:degreesToRadians(self.stareAngle)
                                                      endAngle:degreesToRadians(self.endAngle)
                                                     clockwise:YES];

    [self setupBottomLayerWithPath:path];
    
    for (int i = 0; i < 12; i++) {
        
        UIView *layerView = [[UIView alloc] init];
        
        layerView.backgroundColor = [UIColor colorWithHex:@"2e2e2e"];
        
        [self addSubview:layerView];
        
        layerView.frame = CGRectMake((self.width - 3) / 2.0, 20, 3, self.width/3.0);
        
        layerView.layer.anchorPoint = CGPointMake(0.5, 1);
        layerView.layer.position = CGPointMake(self.width / 2, self.width / 2);
        
        //  在OC的开发中，关于角度统一使用弧度值  逆时针是负值  顺时针正值
        //  180° = M_PI
        
        CGFloat angle = M_PI_2 / 3.0 * i;
        
        layerView.transform = CGAffineTransformRotate(layerView.transform, angle);
        
    }
    
    // 绘制底色
    [self drawDashLine:self lineWidth:3 lineSpacing:4 lineColor:[UIColor colorWithHex:@"0ecc9c"] path:path];
    
   // 绘制弧形进度
    [self drawDashProgressLine:self lineWidth:3 lineSpacing:4 lineColor:[UIColor colorWithHex:@"2e2e2e"] path:path];
    
    [self addIndicatorView];
    
}


/**
 * 绘制底层弧形圆环背景

 @param path 弧形路径
 */
- (void)setupBottomLayerWithPath:(UIBezierPath *)path
{
    CAShapeLayer *bottomLayer = [CAShapeLayer layer];
    
    bottomLayer.frame = self.bounds;
    
    bottomLayer.fillColor = [[UIColor clearColor] CGColor];
    
    bottomLayer.strokeColor = [[UIColor  blackColor] CGColor];
    
    bottomLayer.opacity = 0.5;
    
    bottomLayer.lineCap = kCALineCapRound;
    
    bottomLayer.lineWidth = 48;
    
    bottomLayer.path = [path CGPath];
    
    [self.layer addSublayer:bottomLayer];

}


// 添加指示器
- (void)addIndicatorView
{
    
    self.indicatorView = [[MGIndicatorView alloc] initWithFrame:CGRectMake((self.width-self.width*0.055)/2.0,
                                                                           (self.width-self.width*0.9)/2.0,
                                                                           self.width * 0.055,
                                                                           self.width * 0.9)];

    
    _indicatorView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.indicatorView];
    
}

- (void)addIndicatorViewAnimation:(CALayer *)layer
{
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    CGFloat angle = (M_PI * 2) * (_percent / self.ideallyValue) + degreesToRadians(0.8);
    
    rotationAnimation.toValue = [NSNumber numberWithFloat: angle];
    
    rotationAnimation.duration = kAnimationTime;
    
    rotationAnimation.repeatCount = 1;
    
    //以下两行同时设置才能保持移动后的位置状态不变
    rotationAnimation.fillMode=kCAFillModeForwards;
    
    rotationAnimation.removedOnCompletion = NO;
    
    [layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
}
/**
 ** lineView:       需要绘制成虚线的view
 ** lineWidth:     虚线的宽度
 ** lineSpacing:    虚线的间距
 ** lineColor:      虚线的颜色
 **/
- (void)drawDashLine:(UIView *)lineView
           lineWidth:(int)lineWidth
         lineSpacing:(int)lineSpacing
           lineColor:(UIColor *)lineColor
                path:(UIBezierPath *)path
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    self.bottomLayer = shapeLayer;
    
    [shapeLayer setBounds:lineView.bounds];
    
    [shapeLayer setPosition:CGPointMake(self.width / 2, self.height / 2)];
    
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    
    //  设置虚线长度
    [shapeLayer setLineWidth:8];
    
    [shapeLayer setLineJoin:kCALineJoinRound];
    
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineWidth],
                                    [NSNumber numberWithInt:lineSpacing], nil]];

    shapeLayer.strokeColor = lineColor.CGColor;
    
    shapeLayer.path = path.CGPath;
    
    //  把绘制好的虚线添加上来
    [self.layer addSublayer:shapeLayer];
}
/**
 ** lineView:       需要绘制成虚线的view
 ** lineWidth:     虚线的宽度
 ** lineSpacing:    虚线的间距
 ** lineColor:      虚线的颜色
 **/
- (void)drawDashProgressLine:(UIView *)lineView
                   lineWidth:(int)lineWidth
                 lineSpacing:(int)lineSpacing
                   lineColor:(UIColor *)lineColor
                        path:(UIBezierPath *)path
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    self.progressLayer = shapeLayer;
    
    [shapeLayer setBounds:lineView.bounds];
    
    [shapeLayer setPosition:CGPointMake(self.width / 2, self.height / 2)];
    
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    
    //  设置虚线长度
    [shapeLayer setLineWidth:8];
    
    [shapeLayer setLineJoin:kCALineJoinRound];
    
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineWidth],
                                    [NSNumber numberWithInt:lineSpacing], nil]];
    
    shapeLayer.strokeColor = lineColor.CGColor;
    
    shapeLayer.path = path.CGPath;
    
    shapeLayer.strokeEnd = 0;
    
    [self.layer addSublayer:self.progressLayer];
    
}


- (void)setPercent:(NSInteger)percent
{
    _percent = percent;
    
    [self setPercent:percent animated:YES];
}

- (void)setPercent:(NSInteger)percent animated:(BOOL)animated
{
    _percent = percent;
    
    self.indicatorView.age = percent;
    
    [self addAnimationForAgeLblWithLayer:self.indicatorView.ageLbl.layer];
    
    [self addIndicatorViewAnimation:self.indicatorView.layer];
    
    [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(circleAnimation) userInfo:nil repeats:NO];
    
}

// 弧形动画
- (void)circleAnimation
{
    [CATransaction begin];
    
    /** 对layer层的属性操作，都会形成隐式动画，要使用隐式动画，需要关闭layer层的animation动画属性 */
    [CATransaction setDisableActions:NO]; // 关闭animation动画效果，开启隐式动画
    
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    
    [CATransaction setAnimationDuration:kAnimationTime];
    
    self.progressLayer.strokeEnd = _percent / self.ideallyValue;
    
    [CATransaction commit];
    
}

/// 设置60的逆旋转动画
- (void)addAnimationForAgeLblWithLayer:(CALayer *)layer
{
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    CGFloat angle =  (M_PI * 2) * (_percent / self.ideallyValue) + degreesToRadians(0.8);
    
    rotationAnimation.toValue = [NSNumber numberWithFloat: - angle];
    
    rotationAnimation.duration = kAnimationTime;
    
    rotationAnimation.repeatCount = 1;
    
    rotationAnimation.fillMode=kCAFillModeForwards;
    
    rotationAnimation.removedOnCompletion = NO;
    
    [layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];

}

@end
