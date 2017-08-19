//
//  MGIndicatorView.m
//  circularProgressView
//
//  Created by acmeway on 16/12/16.
//  Copyright © 2016年 acmeway. All rights reserved.
//

#import "MGIndicatorView.h"
#import "UIView+Frame.h"
#import "UIColor+Extensions.h"


#define degreesToRadians(x) (M_PI*(x)/180.0) //把角度转换成PI的方式

@interface MGIndicatorView ()

@property (nonatomic, assign) CGRect    indicatorFrame;

@end

@implementation MGIndicatorView

- (void)setAge:(NSInteger)age
{
    _age = age;
    
    self.ageLbl.text = [NSString stringWithFormat:@"%.ld",age];
}

- (instancetype)initWithFrame:(CGRect)frame 
{
    if (self = [super initWithFrame:frame]) {
        
        _indicatorFrame = frame;
        
        UILabel *ageLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height * 0.076, self.width, 14)];
        
        self.ageLbl = ageLbl;
        
        ageLbl.textColor = [UIColor colorWithHex:@"999999"];
        
        ageLbl.font = [UIFont systemFontOfSize:12];
        
        ageLbl.textAlignment = NSTextAlignmentCenter;
        
        ageLbl.backgroundColor = [UIColor clearColor];
        
        [self addSubview:ageLbl];
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect {

    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(self.width * 0.2, 0)];
    
    [path addLineToPoint:CGPointMake(_indicatorFrame.size.width*0.8, 0)];
    
    [path addLineToPoint:CGPointMake(_indicatorFrame.size.width/2.0, _indicatorFrame.size.width * 0.58)];

    path.lineJoinStyle = kCGLineJoinRound;
    
    [[UIColor colorWithHex:@"0ecc9c"] setStroke];
    
    [[UIColor colorWithHex:@"0ecc9c"] setFill];
    
    [path fill];
    
    [path stroke];
    
}




@end
