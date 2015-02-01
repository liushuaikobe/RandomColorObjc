//
// Created by Shuai Liu on 15/1/27.
// Copyright (c) 2015 vars. All rights reserved.
//

#import "LSKActionSheetView.h"

#define LSK_ACTION_SHEET_CELL_REUSE_ID  (@"LSKActionSheetCell")

@interface LSKActionSheetView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    UICollectionView *_menuCollectionView;
    UIButton *_cancelButton;

    NSArray *_dataArray;
}

@end

@implementation LSKActionSheetView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = APP_THEME_COLOR;
        // set up menu collection view
        UICollectionViewFlowLayout *viewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        viewFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _menuCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:viewFlowLayout];
        _menuCollectionView.delegate = self;
        _menuCollectionView.dataSource = self;
        [_menuCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:LSK_ACTION_SHEET_CELL_REUSE_ID];
        [self addSubview:_menuCollectionView];
        // set up cancelButton
        _cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(onCancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancelButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // _cancelButton
    _cancelButton.frame = CGRectMake(0.0f, CGRectGetHeight(self.bounds) - LSK_ACTION_SHEET_LINE_HEIGHT,
            CGRectGetWidth(self.bounds), LSK_ACTION_SHEET_LINE_HEIGHT);
    // _menuCollectionView
    CGFloat menuHeight = CGRectGetHeight(self.bounds) - LSK_ACTION_SHEET_LINE_HEIGHT;
    _menuCollectionView.frame = CGRectMake(0.0f,
            CGRectGetHeight(self.bounds) - LSK_ACTION_SHEET_LINE_HEIGHT - menuHeight,
            CGRectGetWidth(self.bounds), menuHeight);
}

- (void)bindData:(NSArray *)data {
    _dataArray = [NSArray arrayWithArray:data];
}


- (void)collectionView:(UICollectionView *)collectionView
        didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(huePickerView:hueSeleced:)]) {
        [self.delegate huePickerView:self hueSeleced:indexPath];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LSK_ACTION_SHEET_CELL_REUSE_ID forIndexPath:indexPath];
    cell.backgroundColor = (UIColor *)_dataArray[(NSUInteger)indexPath.row];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize result;
    result.width = CGRectGetWidth(self.bounds) / 2;
    result.height = LSK_ACTION_SHEET_LINE_HEIGHT;
    return result;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
        minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
        minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (void)onCancelButtonClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(huePickerView:hueSeleced:)]) {
        [self.delegate huePickerView:self cancelButtonClicked:sender];
    }
}

@end