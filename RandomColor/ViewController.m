//
//  ViewController.m
//  RandomColor
//
//  Created by Shuai Liu on 15/1/23.
//  Copyright (c) 2015年 vars. All rights reserved.
//

#import "ViewController.h"
#import "LSKColorDictionary.h"
#import "LSKColorUtils.h"

@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *hueSelectButton;
@property (weak, nonatomic) IBOutlet UIButton *luminositySelectButton;
@property (weak, nonatomic) IBOutlet UICollectionView *colorCollectionView;

@end

@implementation ViewController {
    NSArray *_colors;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[LSKColorDictionary sharedDictionary] loadColors];
    _colors = [LSKColorUtils generateRadomColors:16 hueName:@"monochrome" luminosity:LSKColorLuminosityLight];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 16;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView
                                    dequeueReusableCellWithReuseIdentifier:@"LSKColorCellReuseID"
                                    forIndexPath:indexPath];
    cell.backgroundColor = (UIColor *)_colors[indexPath.row];
    return cell;
}

@end
