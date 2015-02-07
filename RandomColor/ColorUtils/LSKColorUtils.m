//
//  LSKColorUtils.m
//  RandomColor
//
//  Created by Shuai Liu on 15/1/23.
//  Copyright (c) 2015年 vars. All rights reserved.
//

#import "LSKColorUtils.h"
#import "LSKColorDictionary.h"

@implementation LSKColorUtils

+ (NSArray *)generateRadomColors:(NSInteger)count
                         hueName:(NSString *)hueName
                      luminosity:(LSKColorLuminosity)luminosity{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:(NSUInteger)count];
    UIColor *color = [UIColor whiteColor];
    for (NSInteger i = 0; i < count; ++i) {
        NSInteger H = [LSKColorUtils pickHue:hueName];
        NSInteger S = [LSKColorUtils pickSaturation:H luminosity:luminosity];
        NSInteger B = [LSKColorUtils pickBrightness:H saturation:S luminosity:luminosity];
        NSLog(@"H:%zd, S:%zd, B:%zd", H, S, B);
        color = [UIColor colorWithHue:H / 360.0f saturation:S / 100.0f brightness:B / 100.0f alpha:1.0];
        [array addObject:color];
    }
    return array;
}

#pragma mark - Pick Hue

+ (NSInteger)pickHue:(NSString *)hueName {
    NSArray *hueRange = [LSKColorUtils getHueRangeByColorName:hueName];
    NSInteger hue = [LSKColorUtils randomWithIn:hueRange];
    return (hue < 0) ? (hue + 360) : hue;
}

+ (NSArray *)getHueRangeByColorName:(NSString *)colorName {
    NSDictionary *color = [LSKColorDictionary sharedDictionary].colors[colorName];
    if (color && ![color[@"hueRange"] isEqual:[NSNull null]]) {
        return color[@"hueRange"];
    }
    return @[@(0), @(360)];
}

#pragma mark - Pick Saturation

+ (NSInteger)pickSaturation:(NSInteger)hue
                 luminosity:(LSKColorLuminosity)luminosity {
    if (luminosity == LSKColorLuminosityRandom) {
        return [LSKColorUtils randomWithIn:@[@(0), @(100)]];
    }
    if (luminosity == LSKColorLuminosityMonochrome) {
        return 0;
    }
    NSArray *saturationRangeValue = [LSKColorUtils getSaturationRangeByHue:hue];
    if (saturationRangeValue) {
        NSInteger sMin = [saturationRangeValue[0] integerValue];
        NSInteger sMax = [saturationRangeValue[1] integerValue];
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
        return [LSKColorUtils randomWithIn:@[@(sMin), @(sMax)]];
    }
    return [LSKColorUtils randomWithIn:@[@(0), @(0)]];
}

+ (NSArray *)getSaturationRangeByHue:(NSInteger)hue {
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
    return [LSKColorUtils randomWithIn:@[@(bMin), @(bMax)]];
}

+ (NSInteger)getMinBrightness:(NSInteger)hue
                   saturation:(NSInteger)saturation {
    NSDictionary *colorInfo = [LSKColorUtils getColorInfo:hue];
    if (colorInfo) {
        NSArray *lowerBounds = colorInfo[@"lowerBounds"];
        for (NSUInteger i = 0; i < lowerBounds.count - 1; ++i) {
            NSInteger s1 = [lowerBounds[i][0] integerValue];
            NSInteger v1 = [lowerBounds[i][1] integerValue];
            
            NSInteger s2 = [lowerBounds[i + 1][0] integerValue];
            NSInteger v2 = [lowerBounds[i + 1][1] integerValue];
            
            if (saturation >= s1 && saturation <= s2) {
                CGFloat m = ((CGFloat)(v2 - v1)) / ((CGFloat)(s2 - s1));
                CGFloat b = v1 - m * s1;
                return (NSInteger)(m * saturation + b);
            }
        }
    }
    return 0;
}

#pragma mark - other functions

+ (NSInteger)randomWithIn:(NSArray *)range {

    if (range.count < 2) {
        return 0;
    }

    NSInteger starting = [range[0] integerValue];
    NSInteger ending = [range[1] integerValue];

    if (ending < starting) {
        return starting;
    }

    return starting + (arc4random() % (ending - starting + 1));
}

+ (NSDictionary *)getColorInfo:(NSInteger)hue {
    NSInteger newHue = (hue >= 334 && hue <= 360) ? (hue - 360) : hue;
    NSDictionary *colors = [LSKColorDictionary sharedDictionary].colors;
    for (NSString *colorName in colors) {
        NSDictionary *colorInfo = colors[colorName];
        if (![colorInfo[@"hueRange"] isEqual:[NSNull null]]) {
            NSArray *hueRange = colorInfo[@"hueRange"];

            NSInteger hueRange0 = [hueRange[0] integerValue];
            NSInteger hueRange1 = [hueRange[1] integerValue];

            if (newHue >= hueRange0 && newHue <= hueRange1) {
                return colorInfo;
            }
        }
    }
    return nil;
}

@end
