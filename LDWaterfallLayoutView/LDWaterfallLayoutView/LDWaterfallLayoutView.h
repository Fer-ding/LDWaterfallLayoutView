//
//  LDWaterfallLayoutView.h
//  LDWaterfallLayoutView
//
//  Created by YueHui on 17/1/3.
//  Copyright © 2017年 LeapDing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LDCollectionViewCell.h"

@interface LDWaterfallLayoutView : UIView

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
 *  数据源
 */
@property (nonatomic, copy) NSArray<LDCellModel *> *dataArray;

@end
