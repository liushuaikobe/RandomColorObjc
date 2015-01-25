//
//  LSKColorUtils.h
//  RandomColor
//
//  Created by Shuai Liu on 15/1/23.
//  Copyright (c) 2015年 vars. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

typedef NS_ENUM(NSInteger, LSKColorLuminosity) {
    LSKColorLuminosityRandom,
    LSKColorLuminosityMonochrome,
    LSKColorLuminosityBright,
    LSKColorLuminosityDark,
    LSKColorLuminosityLight
};

@interface LSKColorUtils : NSObject

+ (NSArray *)generateRadomColors:(NSInteger)count
                         hueName:(NSString *)hueName
                      luminosity:(LSKColorLuminosity)luminosity;

+ (NSInteger)randomWithIn:(NSRange)range;

+ (NSDictionary *)getColorInfo:(NSInteger)hue;

@end
