//
//  LSKColorUtils.m
//  RandomColor
//
//  Created by Shuai Liu on 15/1/23.
//  Copyright (c) 2015年 vars. All rights reserved.
//

#import "LSKColorUtils.h"
#import "LSKColorDictionary.h"
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>


@implementation LSKColorUtils

+ (NSArray *)generateRadomColors:(NSInteger)count
                         hueName:(NSString *)hueName
                      luminosity:(LSKColorLuminosity)luminosity{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:count];
    UIColor *color = [UIColor whiteColor];
    for (NSInteger i = 0; i < count; ++i) {
        NSInteger H = [LSKColorUtils pickHue:hueName];
        NSInteger S = [LSKColorUtils pickSaturation:H luminosity:luminosity];
        NSInteger B = [LSKColorUtils pickBrightness:H saturation:S luminosity:luminosity];
        NSLog(@"H:%zd, S:%zd, B:%zd", H, S, B);
        color = [UIColor colorWithHue:H / 360.0 saturation:S / 100.0 brightness:B / 100.0 alpha:1.0];
        [array addObject:color];
    }
    return array;
}

#pragma mark - Pick Hue

+ (NSInteger)pickHue:(NSString *)hueName {
    NSRange hueRange = [LSKColorUtils getHueRangeByColorName:hueName];
    NSInteger hue = [LSKColorUtils randomWithIn:hueRange];
    return (hue < 0) ? (hue + 360) : hue;
}

+ (NSRange)getHueRangeByColorName:(NSString *)colorName {
    NSDictionary *color = [LSKColorDictionary sharedDictionary].colors[colorName];
    if (color && ![color[@"hueRange"] isEqual:[NSNull null]]) {
        return [color[@"hueRange"] rangeValue];
    }
    return NSMakeRange(0, 360);
}

#pragma mark - Pick Saturation

+ (NSInteger)pickSaturation:(NSInteger)hue
                 luminosity:(LSKColorLuminosity)luminosity {
    if (luminosity == LSKColorLuminosityRandom) {
        return [LSKColorUtils randomWithIn:NSMakeRange(0, 100)];
    }
    if (luminosity == LSKColorLuminosityMonochrome) {
        return 0;
    }
    NSValue *saturationRangeValue = [LSKColorUtils getSaturationRangeByHue:hue];
    if (saturationRangeValue) {
        NSRange saturationRange = [saturationRangeValue rangeValue];
        NSInteger sMin = saturationRange.location;
        NSInteger sMax = saturationRange.location + saturationRange.length;
        switch (luminosity) {
            case LSKColorLuminosityDark: {
                sMin = sMax - 10;
                break;
            }
            case LSKColorLuminosityBright: {
                sMin = 55;
                break;
            }
            case LSKColorLuminosityLight: {
                sMax = 55;
                break;
            }
            default: {
                break;
            }
        }
        return [LSKColorUtils randomWithIn:NSMakeRange(sMin, sMax - sMin)];
    }
    return [LSKColorUtils randomWithIn:NSMakeRange(0, 0)];
}

+ (NSValue *)getSaturationRangeByHue:(NSInteger)hue {
    NSDictionary *colorInfo = [LSKColorUtils getColorInfo:hue];
    if (colorInfo) {
        return colorInfo[@"saturationRange"];
    }
    return nil;
}

#pragma mark - Pick Brightness

+ (NSInteger)pickBrightness:(NSInteger)hue
                 saturation:(NSInteger)saturation
                 luminosity:(LSKColorLuminosity)luminosity {
    NSInteger bMin = [LSKColorUtils getMinBrightness:hue saturation:saturation];
    NSInteger bMax = 100;
    switch (luminosity) {
        case LSKColorLuminosityDark: {
            bMax = bMin + 20;
            break;
        }
        case LSKColorLuminosityLight: {
            bMin = (bMax + bMin) / 2;
            break;
        }
        case LSKColorLuminosityRandom: {
            bMin = 0;
            bMax = 100;
            break;
        }
        default:
            break;
    }
    return [LSKColorUtils randomWithIn:NSMakeRange(bMin, bMax - bMin)];
}

+ (NSInteger)getMinBrightness:(NSInteger)hue
                   saturation:(NSInteger)saturation {
    NSDictionary *colorInfo = [LSKColorUtils getColorInfo:hue];
    if (colorInfo) {
        NSArray *lowerBounds = colorInfo[@"lowerBounds"];
        for (int i = 0; i < lowerBounds.count - 1; ++i) {
            NSInteger s1 = [lowerBounds[i][0] integerValue];
            NSInteger v1 = [lowerBounds[i][1] integerValue];
            
            NSInteger s2 = [lowerBounds[i + 1][0] integerValue];
            NSInteger v2 = [lowerBounds[i + 1][1] integerValue];
            
            if (saturation >= s1 && saturation <= s2) {
                CGFloat m = ((CGFloat)(v2 - v1)) / ((CGFloat)(s2 - s1));
                CGFloat b = v1 - m * s1;
                return m * saturation + b;
            }
        }
    }
    return 0;
}

#pragma mark - other functions

+ (NSInteger)randomWithIn:(NSRange)range {
    if (range.length == 0) {
        return range.location;
    }
    return arc4random() % range.length + range.location;
}

+ (NSDictionary *)getColorInfo:(NSInteger)hue {
    NSInteger newHue = (hue >= 334 && hue <= 360) ? (hue - 360) : hue;
    NSDictionary *colors = [LSKColorDictionary sharedDictionary].colors;
    for (NSString *colorName in colors) {
        NSDictionary *colorInfo = colors[colorName];
        if (![colorInfo[@"hueRange"] isEqual:[NSNull null]]) {
            NSRange hueRange = [colorInfo[@"hueRange"] rangeValue];
            if (newHue >= hueRange.location && newHue <= (hueRange.location + hueRange.length)) {
                return colorInfo;
            }
        }
    }
    return nil;
}

@end
