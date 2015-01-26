//
//  LSKRandomColorMainViewController.m
//  RandomColor
//
//  Created by Shuai Liu on 15/1/23.
//  Copyright (c) 2015年 vars. All rights reserved.
//

#import "LSKRandomColorMainViewController.h"
#import "LSKRandomColorTableViewCell.h"
#import "LSKColorDictionary.h"
#import "LSKColorUtils.h"

#define LSK_COLOR_TABLEVIEW_CELL_REUSE_ID   @"LSKRandomColorTableViewCell"
#define LSK_RANDOM_COLOR_COUNT              (5)
#define LSK_MAIN_CONTROLLER_FN_VIEW_HEIGHT  (70.0f)


@interface LSKRandomColorMainViewController ()<UITableViewDataSource, UITableViewDelegate> {
    // ---- Views
    UITableView *_colorTableView;
    // ---- Data
    NSArray *_colors;
}

@end

@implementation LSKRandomColorMainViewController {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // hide status bar
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    // set up table views
    if (!_colorTableView) {
        _colorTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _colorTableView.delegate = self;
        _colorTableView.dataSource = self;
        _colorTableView.backgroundColor = [UIColor whiteColor];
        _colorTableView.bounces = NO;
        _colorTableView.showsHorizontalScrollIndicator = NO;
        _colorTableView.showsVerticalScrollIndicator = NO;
        _colorTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_colorTableView registerClass:[LSKRandomColorTableViewCell class]
                forCellReuseIdentifier:LSK_COLOR_TABLEVIEW_CELL_REUSE_ID];
        [self.view addSubview:_colorTableView];
    }
    // generate colors
    [[LSKColorDictionary sharedDictionary] loadColors];
    _colors = [LSKColorUtils generateRadomColors:LSK_RANDOM_COLOR_COUNT
                                         hueName:@"monochrome"
                                      luminosity:LSKColorLuminosityLight];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _colors.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSKRandomColorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LSK_COLOR_TABLEVIEW_CELL_REUSE_ID
                                                                        forIndexPath:indexPath];
    cell.backgroundColor = _colors[(NSUInteger)indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (CGRectGetHeight(self.view.bounds) - LSK_MAIN_CONTROLLER_FN_VIEW_HEIGHT) / [self tableView:tableView numberOfRowsInSection:1];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}


@end
