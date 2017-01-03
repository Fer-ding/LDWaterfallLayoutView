//
//  LDLayout.h
//  LDWaterfallLayoutView
//
//  Created by YueHui on 17/1/3.
//  Copyright © 2017年 LeapDing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef CGFloat(^HeightBlock)(NSIndexPath *indexPath , CGFloat width);

@interface LDLayout : UICollectionViewLayout

/**
 *  列数
 */
@property (nonatomic, assign) NSInteger colCount;
/**
 *  行间距
 */
@property (nonatomic, assign) CGFloat rowSpacing;
/**
 *  列间距
 */
@property (nonatomic, assign) CGFloat colSpacing;
/**
 *  内边距
 */
@property (nonatomic, assign) UIEdgeInsets sectionInset;

/**
 *  对象方法
 *
 *  @param heightBlock 在block中最后要返回一个item的高度
 */
- (void)computeIndexCellHeightWithWidthBlock:(HeightBlock)heightBlock;

@end
