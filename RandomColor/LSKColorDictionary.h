//
//  LSKColorDictionary.h
//  RandomColor
//
//  Created by Shuai Liu on 15/1/23.
//  Copyright (c) 2015年 vars. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSKColorDictionary : NSObject

+ (LSKColorDictionary *)sharedDictionary;

@property (nonatomic, strong) NSMutableDictionary* colors;

- (void)defineColor:(NSString *)name
           hueRange:(NSArray *)hueRangeArray
        lowerBounds:(NSArray *)lowerBoundsArray;

- (NSRange)rangeArraytoRange:(NSArray *)rangeArray;

- (void)loadColors;

@end
