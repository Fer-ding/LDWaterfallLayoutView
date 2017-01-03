//
//  LDLayout.m
//  LDWaterfallLayoutView
//
//  Created by YueHui on 17/1/3.
//  Copyright © 2017年 LeapDing. All rights reserved.
//

#import "LDLayout.h"

@interface LDLayout ()
/**
 存放每列高度字典
 */
@property (nonatomic, strong) NSMutableDictionary *itemHeightDict;
/**
 存放所有item的attrubutes属性
 */
@property (nonatomic, strong) NSMutableArray *itemAttrubutes;
/**
 计算每个item高度的block，必须实现
 */
@property (nonatomic, copy) HeightBlock heightBlock;

@end

@implementation LDLayout

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    //默认行数 2行
    //默认行间距 10.0f
    //默认列间距 10.0f
    //默认内边距 top:10 left:10 bottom:10 right:10
    
    self.colCount = 2;
    self.rowSpacing = 10.0f;
    self.colSpacing = 10.0f;
    self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    _itemHeightDict = [NSMutableDictionary dictionary];
    _itemAttrubutes = [NSMutableArray array];
    
    return self;
}


/**
 准备好布局时使用
 */
- (void)prepareLayout {
    [super prepareLayout];
    
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    //初始化每列的高度
    for (int i = 0; i < self.colCount; i++) {
        [_itemHeightDict setObject:@(self.sectionInset.top) forKey:[NSString stringWithFormat:@"%i",i]];
    }
    
    //得到每个item的属性值进行存储
    for (int i = 0; i < itemCount; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [_itemAttrubutes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    
}


/**
 设置可滚动区域

 @return 可滚动区域的size
 */
- (CGSize)collectionViewContentSize {
    __block NSString *maxHeightColoumn = @"0";
    [_itemHeightDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        if ([_itemHeightDict[maxHeightColoumn] floatValue] < [obj floatValue]) {
            maxHeightColoumn = key;
        }
    }];
    return CGSizeMake(self.collectionView.bounds.size.width, [_itemHeightDict[maxHeightColoumn] floatValue] + self.sectionInset.bottom);
}


/**
 *
 *
 @return 返回视图框内item的属性，可以直接返回所有item属性
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return _itemAttrubutes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //通过indexpath创建一个item属性
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    //计算item宽
    CGFloat itemW = (self.collectionView.bounds.size.width - (self.sectionInset.left + self.sectionInset.right) - (self.colCount - 1) * self.colSpacing) / self.colCount;
    CGFloat itemH;
    //计算item高
    if (self.heightBlock) {
        itemH = self.heightBlock(indexPath, itemW);
    } else {
        NSAssert(itemH != 0, @"Please implement computeIndexCellHeightWithWidthBlock Method!");
    }
    //计算item的frame
    CGRect itemFrame;
    itemFrame.size = CGSizeMake(itemW, itemH);
    //循环遍历找出高度最短行
    __block NSString *colMinHeight = @"0";
    [_itemHeightDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        if ([_itemHeightDict[colMinHeight] floatValue] > [obj floatValue]) {
            colMinHeight = key;
        }
    }];
    int col = [colMinHeight intValue];
    //找出最短行后，计算item位置
    itemFrame.origin = CGPointMake(self.sectionInset.left + col * (itemW + self.colSpacing), [_itemHeightDict[colMinHeight] floatValue]);
    _itemHeightDict[colMinHeight] = @(itemFrame.size.height + self.rowSpacing + [_itemHeightDict[colMinHeight] floatValue]);
    attr.frame = itemFrame;
    
    return attr;
}


/**
 设置计算高度block方法

 @param heightBlock 计算item高度的blcok
 */
- (void)computeIndexCellHeightWithWidthBlock:(HeightBlock)heightBlock {
    if (self.heightBlock != heightBlock) {
        self.heightBlock = heightBlock;
    }
}

@end
