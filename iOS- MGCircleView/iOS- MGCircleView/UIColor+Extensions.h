//
//  UIColor+Extensions.h
//  circularProgressView
//
//  Created by acmeway on 16/12/15.
//  Copyright © 2016年 acmeway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extensions)



/**传入颜色的hex值(如#FFFFFF,oxffffff,ffffff)，返回对应的UIColor对象*/
+ (UIColor *)colorWithHex:(NSString *)hex;

/**传入颜色的hex值(如#FFFFFF,oxffffff,ffffff) 和alpha，返回对应的UIColor对象*/
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

/**苍白的紫罗兰红色*/
+ (UIColor *)paleVioletRed;



@end
