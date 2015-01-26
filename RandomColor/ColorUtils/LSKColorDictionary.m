//
//  LSKColorDictionary.m
//  RandomColor
//
//  Created by Shuai Liu on 15/1/23.
//  Copyright (c) 2015年 vars. All rights reserved.
//

#import "LSKColorDictionary.h"

@implementation LSKColorDictionary

- (id)init {
    self = [super init];
    if (self) {
        self.colors = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)defineColor:(NSString *)name
           hueRange:(NSArray *)hueRangeArray
        lowerBounds:(NSArray *)lowerBoundsArray {
    NSInteger sMin = [lowerBoundsArray[0][0] integerValue];
    NSInteger sMax = [lowerBoundsArray[lowerBoundsArray.count - 1][0] integerValue];
    
    NSInteger bMin = [lowerBoundsArray[lowerBoundsArray.count - 1][1] integerValue];
    NSInteger bMax = [lowerBoundsArray[0][1] integerValue];
    
    if (hueRangeArray) {
    
        NSRange hueRange = [[LSKColorDictionary sharedDictionary] rangeArraytoRange:hueRangeArray];
        
        [LSKColorDictionary sharedDictionary].colors[name] = @{
                                                               @"hueRange":[NSValue valueWithRange:hueRange],
                                                               @"lowerBounds": lowerBoundsArray,
                                                               @"saturationRange": [NSValue valueWithRange:NSMakeRange(sMin, sMax - sMin)],
                                                               @"brightnessRange": [NSValue valueWithRange:NSMakeRange(bMin, bMax - bMin)]
                                                               };
    } else {
        [LSKColorDictionary sharedDictionary].colors[name] = @{
                                                               @"hueRange":[NSNull null],
                                                               @"lowerBounds": lowerBoundsArray,
                                                               @"saturationRange": [NSValue valueWithRange:NSMakeRange(sMin, sMax - sMin)],
                                                               @"brightnessRange": [NSValue valueWithRange:NSMakeRange(bMin, bMax - bMin)]
                                                               };
    }
}

- (NSRange)rangeArraytoRange:(NSArray *)rangeArray {
    return NSMakeRange([rangeArray[0] integerValue], [rangeArray[1] integerValue] - [rangeArray[0] integerValue]);
}


+ (LSKColorDictionary *)sharedDictionary {
    static LSKColorDictionary * sharedDictionary = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDictionary = [[LSKColorDictionary alloc] init];
    });
    return sharedDictionary;
}


- (void)loadColors {
    [self defineColor:@"monochrome"
             hueRange:nil
          lowerBounds:@[@[@0, @0], @[@100, @0]]];
    [self defineColor:@"red"
             hueRange:@[@(-26),@18]
          lowerBounds:@[@[@20,@100],@[@30,@92],@[@40,@89],@[@50,@85],@[@60,@78],@[@70,@70],@[@80,@60],@[@90,@55],@[@100,@50]]];
    [self defineColor:@"orange"
             hueRange:@[@19, @46]
          lowerBounds:@[@[@20,@100],@[@30,@93],@[@40,@88],@[@50,@86],@[@60,@85],@[@70,@70],@[@100,@70]]];
    [self defineColor:@"yellow"
             hueRange:@[@47,@62]
          lowerBounds:@[@[@25,@100],@[@40,@94],@[@50,@89],@[@60,@86],@[@70,@84],@[@80,@82],@[@90,@80],@[@100,@75]]];
    [self defineColor:@"green"
             hueRange:@[@63,@178]
          lowerBounds:@[@[@30,@100],@[@40,@90],@[@50,@85],@[@60,@81],@[@70,@74],@[@80,@64],@[@90,@50],@[@100,@40]]];
    [self defineColor:@"blue"
             hueRange:@[@179, @257]
          lowerBounds:@[@[@20,@100],@[@30,@86],@[@40,@80],@[@50,@74],@[@60,@60],@[@70,@52],@[@80,@44],@[@90,@39],@[@100,@35]]];
    [self defineColor:@"purple"
             hueRange:@[@258, @282]
          lowerBounds:@[@[@20,@100],@[@30,@87],@[@40,@79],@[@50,@70],@[@60,@65],@[@70,@59],@[@80,@52],@[@90,@45],@[@100,@42]]];
    [self defineColor:@"pink"
             hueRange:@[@283, @334]
          lowerBounds:@[@[@20,@100],@[@30,@90],@[@40,@86],@[@60,@84],@[@80,@80],@[@90,@75],@[@100,@73]]];
}

@end
