//
//  LDWaterfallLayoutView.m
//  LDWaterfallLayoutView
//
//  Created by YueHui on 17/1/3.
//  Copyright © 2017年 LeapDing. All rights reserved.
//

#import "LDWaterfallLayoutView.h"

#import "LDLayout.h"

@interface LDWaterfallLayoutView () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) LDLayout *ld_layout;

@end

@implementation LDWaterfallLayoutView

//- (instancetype)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    if (!self) {
//        return nil;
//    }
//    return self;
//}

- (void)setDataArray:(NSArray<LDCellModel *> *)dataArray {
    _dataArray = [dataArray copy];
    
    [self setupUI];
}

- (void)setupUI {
    
    self.ld_layout = [[LDLayout alloc] init];
    self.ld_layout.colCount = self.colCount; //列数
    self.ld_layout.rowSpacing = self.rowSpacing; //行间距
    self.ld_layout.colSpacing = self.colSpacing; //列间距
    self.ld_layout.sectionInset = self.sectionInset;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) collectionViewLayout:self.ld_layout];
    
    [self.collectionView registerClass:[LDCollectionViewCell class] forCellWithReuseIdentifier:@"LDCollectionViewCell"];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:self.collectionView];
    
    
    //返回每个cell的高   对应indexPath
    [self.ld_layout computeIndexCellHeightWithWidthBlock:^CGFloat(NSIndexPath *indexPath, CGFloat width) {
        
        LDCellModel *model = self.dataArray[indexPath.row];
        CGFloat oldWidth = model.imgWidth;
        CGFloat oldHeight = model.imgHeight;
        
        CGFloat newWidth = width;
        CGFloat newHeigth = oldHeight*newWidth / oldWidth;
        return newHeigth;
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LDCollectionViewCell *cell = (LDCollectionViewCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:@"LDCollectionViewCell" forIndexPath:indexPath];
    
    cell.model = self.dataArray[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"选中了第%ld个item",indexPath.row);
}


@end
