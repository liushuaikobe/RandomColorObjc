//
// Created by Shuai Liu on 15/1/27.
// Copyright (c) 2015 vars. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LSKActionSheetView;

#define LSK_ACTION_SHEET_LINE_HEIGHT    (70.0f)

@protocol LSKHuePickerDelegate<NSObject>
@optional
- (void)huePickerView:(LSKActionSheetView *)huePickerView cancelButtonClicked:(id)cancelButton;
- (void)huePickerView:(LSKActionSheetView *)huePickerView hueSeleced:(NSIndexPath *)indexPath;
@end

@interface LSKActionSheetView : UIView

- (void)bindData:(NSArray *)data;
@property (nonatomic, assign) id<LSKHuePickerDelegate> delegate;

@end