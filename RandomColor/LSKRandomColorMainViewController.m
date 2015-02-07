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
#import "LSKActionSheetView.h"

#define LSK_COLOR_TABLEVIEW_CELL_REUSE_ID   @"LSKRandomColorTableViewCell"
#define LSK_RANDOM_COLOR_COUNT              (5)
#define LSK_MAIN_CONTROLLER_FN_VIEW_HEIGHT  (70.0f)


@interface LSKRandomColorMainViewController ()<UITableViewDataSource, UITableViewDelegate, LSKHuePickerDelegate> {
    // ---- Views
    UITableView *_colorTableView;
    UIButton *_hueChooseButton, *_luminosityChooseButton;
    LSKActionSheetView *_huePickView;
    // ---- Data
    NSArray *_colors;
    NSArray *_hues;
    NSArray *_hueNames;
    NSString *_currentHueName;
    NSArray *_luminosities;
}

@end

@implementation LSKRandomColorMainViewController {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // hide status bar
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    // set up hues
    [self setupHues];
    // set up views
    [self setupColorTableView];
    [self setupButtons];
    // load colors
    [[LSKColorDictionary sharedDictionary] loadColors];
    _currentHueName = _hueNames[_hueNames.count - 1];
    [self generateColors];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _colorTableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - LSK_MAIN_CONTROLLER_FN_VIEW_HEIGHT);

    CGFloat buttonWidth = CGRectGetWidth(self.view.bounds) / 2;
    _hueChooseButton.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - LSK_MAIN_CONTROLLER_FN_VIEW_HEIGHT, buttonWidth, LSK_MAIN_CONTROLLER_FN_VIEW_HEIGHT);
    _luminosityChooseButton.frame = CGRectMake(buttonWidth, CGRectGetHeight(self.view.bounds) - LSK_MAIN_CONTROLLER_FN_VIEW_HEIGHT, buttonWidth, LSK_MAIN_CONTROLLER_FN_VIEW_HEIGHT);

    if (_huePickView && !_huePickView.hidden) {

    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - set up Views

- (void)setupColorTableView {
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
}

- (void)setupButtons {
    // set up menus
    if (!_hueChooseButton) {
        _hueChooseButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_hueChooseButton setTitle:@"hue" forState:UIControlStateNormal];
        [_hueChooseButton addTarget:self
                             action:@selector(onHueSelect:)
                   forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_hueChooseButton];
    }
    if (!_luminosityChooseButton) {
        _luminosityChooseButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_luminosityChooseButton setTitle:@"luminosity" forState:UIControlStateNormal];
        [_luminosityChooseButton addTarget:self
                                    action:@selector(onLuminositySelect:)
                          forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_luminosityChooseButton];
    }
}

- (void)setupHuePickerView {
    if (!_huePickView) {
        CGFloat pickerViewHeight = (_hues.count / 2 + 1) * LSK_ACTION_SHEET_LINE_HEIGHT;
        _huePickView = [[LSKActionSheetView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds) - pickerViewHeight,
                CGRectGetWidth(self.view.bounds), pickerViewHeight)];
        _huePickView.delegate = self;
        _huePickView.hidden = YES;
        [self.view addSubview:_huePickView];
        [_huePickView bindData:_hues];
    }
}

#pragma mark - set up datas

- (void)setupHues {
    _hueNames = @[@"red", @"orange",
            @"yellow", @"green",
            @"blue", @"purple",
            @"pink", @"monochrome"];
    _hues = @[[UIColor redColor], [UIColor orangeColor],
            [UIColor yellowColor], [UIColor greenColor],
            [UIColor blueColor], [UIColor purpleColor],
            [UIColor colorWithRed:255/255.0f green:192/255.0f blue:203/255.0f alpha:1.0f], [UIColor grayColor]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _colors.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSKRandomColorTableViewCell *cell = (LSKRandomColorTableViewCell *)[tableView dequeueReusableCellWithIdentifier:LSK_COLOR_TABLEVIEW_CELL_REUSE_ID
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

#pragma mark - HuePicker Delegate

- (void)huePickerView:(LSKActionSheetView *)huePickerView cancelButtonClicked:(id)cancelButton {
    [self hideHuePickerView];
}

- (void)huePickerView:(LSKActionSheetView *)huePickerView hueSeleced:(NSIndexPath *)indexPath {
    [self hideHuePickerView];
    _currentHueName = _hueNames[(NSUInteger)indexPath.row];
    [self generateColors];
    [_colorTableView reloadData];
}


#pragma mark - Options select

- (void)onHueSelect:(id)sender {
    [self showHuePickerView];
}

- (void)onLuminositySelect:(id)sender {

}

- (void)showHuePickerView {
    [self setupHuePickerView];
    _huePickView.hidden = NO;
}

- (void)hideHuePickerView {
    _huePickView.hidden = YES;
}

- (void)generateColors {
    _colors = [LSKColorUtils generateRadomColors:LSK_RANDOM_COLOR_COUNT
                                         hueName:_currentHueName
                                      luminosity:LSKColorLuminosityBright];
}

@end
