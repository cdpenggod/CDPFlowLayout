//
//  CDPFlowLayout.h
//  waterfallFlowLayout
//
//  Created by CDP on 2020/1/3.
//  Copyright © 2020 CDP. All rights reserved.
//

#import <UIKit/UIKit.h>


@class CDPFlowLayout;

@protocol CDPFlowLayoutDelegate <NSObject>

@required//必须实现

/**
 *  cell高度
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(CDPFlowLayout *)collectionViewLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth;

@optional//可选

/**
 *  header的高度
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(CDPFlowLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;

/**
 *  footer的高度
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(CDPFlowLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section;

/**
 *  section上下左右距离边缘cell间距
 */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(CDPFlowLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;

/**
 *  每个section中的列数
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(CDPFlowLayout *)collectionViewLayout numberOfColumnsInSection:(NSInteger)section;

/**
 *  item上下的间距
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(CDPFlowLayout *)collectionViewLayout lineSpacingForSectionAtIndex:(NSInteger)section;

/**
 *  item左右的间距
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(CDPFlowLayout *)collectionViewLayout interitemSpacingForSectionAtIndex:(NSInteger)section;

/**
 *  当前section和上个section尾部间距
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(CDPFlowLayout *)collectionViewLayout spacingOfCurrentHeaderToLastFooterAtIndex:(NSInteger)section;

@end





@interface CDPFlowLayout : UICollectionViewLayout
//瀑布流layout


@property (nonatomic,weak) id<CDPFlowLayoutDelegate> delegate;



@end







