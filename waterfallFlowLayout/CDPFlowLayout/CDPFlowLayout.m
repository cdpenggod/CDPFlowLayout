//
//  CDPFlowLayout.m
//  waterfallFlowLayout
//
//  Created by CDP on 2020/1/3.
//  Copyright © 2020 CDP. All rights reserved.
//

#import "CDPFlowLayout.h"


@interface CDPFlowLayout ()

@property (nonatomic, assign) UIEdgeInsets sectionInsets; //边缘cell距离边缘的距离

@property (nonatomic, assign) NSInteger columnCount; //每个section中的列数

@property (nonatomic, assign) CGFloat lineSpacing; //item上下的间距

@property (nonatomic, assign) CGFloat interitemSpacing; //item左右的间距

@property (nonatomic, assign) CGFloat headerReferenceHeight; //header的height

@property (nonatomic, assign) CGFloat footerReferenceHeight; //footer的height

@property (nonatomic, assign) CGFloat contentHeight; //collectionView的content的高度

@property (nonatomic, assign) CGFloat spacingOfCurrentHeaderToLastFooter; //当前section和上个section尾部的间距

@property (nonatomic, strong) NSMutableArray *attributesArr; //存放attributes对象数组

@property (nonatomic, strong) NSMutableArray *columnHeightArr; //存放每列高度数组

@property (nonatomic, assign) CGRect oldBounds; //当前容器的bounds

@end

@implementation CDPFlowLayout

//初始化
- (instancetype)init {
    if (self = [super init]) {
        _sectionInsets = UIEdgeInsetsZero;
        _columnCount = 1;
        _lineSpacing = 0;
        _interitemSpacing = 0;
        _headerReferenceHeight = 0;
        _footerReferenceHeight = 0;
        _contentHeight = 0;
        _spacingOfCurrentHeaderToLastFooter = 0;
        _attributesArr = [[NSMutableArray alloc] init];
        _columnHeightArr = [[NSMutableArray alloc] init];
        _oldBounds = CGRectZero;
    }
    return self;
}

- (void)dealloc {
    _delegate = nil;
    [_attributesArr removeAllObjects];
    [_columnHeightArr removeAllObjects];
    _attributesArr = nil;
    _columnHeightArr = nil;
}
#pragma mark - 重写父类相关布局方法
- (void)prepareLayout {
    [super prepareLayout];
    
    //布局数据初始化
    _sectionInsets = UIEdgeInsetsZero;
    _columnCount = 1;
    _lineSpacing = 0;
    _interitemSpacing = 0;
    _headerReferenceHeight = 0;
    _footerReferenceHeight = 0;
    _contentHeight = 0;
    _spacingOfCurrentHeaderToLastFooter = 0;
    
    [_attributesArr removeAllObjects];
    [_columnHeightArr removeAllObjects];
    
    UICollectionView *collectionView = self.collectionView;
    _oldBounds = collectionView.bounds;
    
    //获取当前section总数
    NSInteger sectionCount = [collectionView numberOfSections];
    
    //遍历section
    for (NSInteger i = 0; i < sectionCount; i++) {
        
        //获取section中的列数
        if (_delegate && [_delegate respondsToSelector:@selector(collectionView:layout:numberOfColumnsInSection:)]) {
            _columnCount = [_delegate collectionView:collectionView
                                              layout:self
                            numberOfColumnsInSection:i];
        }
        
        //获取section边界距离边缘cell间隔
        if (_delegate && [_delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
            _sectionInsets = [_delegate collectionView:collectionView
                                                layout:self
                                insetForSectionAtIndex:i];
        }
        
        //获取顶部距上个section间隔
        if (_delegate && [_delegate respondsToSelector:@selector(collectionView:layout:spacingOfCurrentHeaderToLastFooterAtIndex:)]) {
            _spacingOfCurrentHeaderToLastFooter = [_delegate collectionView:collectionView
                                                                     layout:self
                                  spacingOfCurrentHeaderToLastFooterAtIndex:i];
        }
        
        //头部Attributes对象
        if (_delegate && [_delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
            UICollectionViewLayoutAttributes *headerLayoutAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                                            atIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]];
            [_attributesArr addObject:headerLayoutAttributes];
        } else {
            _contentHeight += _spacingOfCurrentHeaderToLastFooter;
            _contentHeight += _sectionInsets.top;
        }
        
        //保存当前section中每列高度(主要保存对应数量,高度随后会在下面修正)
        [_columnHeightArr removeAllObjects];
        for (NSInteger c = 0; c < _columnCount; c++) {
            [_columnHeightArr addObject:@(_contentHeight)];
        }
        
        //获取section中的item数量
        NSInteger itemCountOfSection = [collectionView numberOfItemsInSection:i];
        
        //item Attributes对象
        for (NSInteger j = 0; j < itemCountOfSection; j++) {
            UICollectionViewLayoutAttributes *itemLayoutAttbitures = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:j inSection:i]];
            [_attributesArr addObject:itemLayoutAttbitures];
        }
        
        //尾部Attributes对象
        if (_delegate && [_delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)]) {
            UICollectionViewLayoutAttributes *footerLayoutAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                                                            atIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]];
            [_attributesArr addObject:footerLayoutAttributes];
        } else {
            _contentHeight += _sectionInsets.bottom;
        }
    }
}
//计算header和footer
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind
                                                                                                                  withIndexPath:indexPath];
    
    UICollectionView *collectionView = self.collectionView;
    
    //获取section上下左右距离边缘cell间距
    if (_delegate && [_delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        _sectionInsets = [_delegate collectionView:collectionView
                                            layout:self
                            insetForSectionAtIndex:indexPath.section];
    }
    
    //获取和上个section尾部间距
    if (_delegate && [_delegate respondsToSelector:@selector(collectionView:layout:spacingOfCurrentHeaderToLastFooterAtIndex:)]) {
        _spacingOfCurrentHeaderToLastFooter = [_delegate collectionView:collectionView
                                                                 layout:self
                              spacingOfCurrentHeaderToLastFooterAtIndex:indexPath.section];
    }
    
    //获取header和footer的高度
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        //header
        if (_delegate && [_delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
            _headerReferenceHeight = [_delegate collectionView:collectionView
                                                        layout:self
                               referenceSizeForHeaderInSection:indexPath.section];
        }
        
        _contentHeight += _spacingOfCurrentHeaderToLastFooter;
        attributes.frame = CGRectMake(0, _contentHeight, collectionView.bounds.size.width, _headerReferenceHeight);
        
        _contentHeight += _headerReferenceHeight;
        _contentHeight += _sectionInsets.top;
        
    } else if ([elementKind isEqualToString:UICollectionElementKindSectionFooter]) {
        //footer
        if (_delegate && [_delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)]) {
            _footerReferenceHeight = [_delegate collectionView:collectionView
                                                        layout:self
                               referenceSizeForFooterInSection:indexPath.section];
        }
        
        _contentHeight += _sectionInsets.bottom;
        attributes.frame = CGRectMake(0, _contentHeight, collectionView.bounds.size.width, _footerReferenceHeight);
        
        _contentHeight += _footerReferenceHeight;
    }
    
    return attributes;
}
//计算cell
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionView *collectionView = self.collectionView;
    //获取列数
    if (_delegate && [_delegate respondsToSelector:@selector(collectionView:layout:numberOfColumnsInSection:)]) {
        _columnCount = [_delegate collectionView:collectionView
                                          layout:self
                        numberOfColumnsInSection:indexPath.section];
    }
    //获取section距边缘cell间隔
    if (_delegate && [_delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        _sectionInsets = [_delegate collectionView:collectionView
                                            layout:self
                            insetForSectionAtIndex:indexPath.section];
    }
    //获取item上下间隔
    if (_delegate && [_delegate respondsToSelector:@selector(collectionView:layout:lineSpacingForSectionAtIndex:)]) {
        _lineSpacing = [_delegate collectionView:collectionView
                                          layout:self
                    lineSpacingForSectionAtIndex:indexPath.section];
    }
    //获取item左右间隔
    if (_delegate && [_delegate respondsToSelector:@selector(collectionView:layout:interitemSpacingForSectionAtIndex:)]) {
        _interitemSpacing = [_delegate collectionView:collectionView
                                               layout:self
                    interitemSpacingForSectionAtIndex:indexPath.section];
    }
    //获取section和上个section底部间隔
    if (_delegate && [_delegate respondsToSelector:@selector(collectionView:layout:spacingOfCurrentHeaderToLastFooterAtIndex:)]) {
        _spacingOfCurrentHeaderToLastFooter = [_delegate collectionView:collectionView
                                                                 layout:self
                              spacingOfCurrentHeaderToLastFooterAtIndex:indexPath.section];
    }
    
    //计算cell宽度
    CGFloat collectionViewWidth = collectionView.frame.size.width;
    CGFloat cellWidth = (collectionViewWidth - _sectionInsets.left - _sectionInsets.right - (_columnCount-1) * _interitemSpacing) / _columnCount;
    
    //cell高度
    CGFloat cellHeight = (_delegate)? [_delegate collectionView:collectionView
                                                         layout:self
                                       heightForItemAtIndexPath:indexPath
                                                      itemWidth:cellWidth] : 0;
    
    //默认第 0 列高度最小
    NSInteger tempMinColumn = 0;
    //默认取出第 0 列高度
    CGFloat minColumnHeight = [_columnHeightArr[0] doubleValue];
    
    for (NSInteger i = 0; i < _columnCount; i++) {
        CGFloat columnHeight = [_columnHeightArr[i] doubleValue];
        if (minColumnHeight > columnHeight) {
            minColumnHeight = columnHeight;
            tempMinColumn = i;
        }
    }
    
    CGFloat cellX = _sectionInsets.left + tempMinColumn * (cellWidth + _interitemSpacing);
    CGFloat cellY = minColumnHeight;
    
    //当item>=列数 即此item不在此section的第一列 因此要加上此区的 lineSpacing
    if (indexPath.item >= _columnCount) {
        cellY += _lineSpacing;
    }
    
    //更新contentHeight
    if (_contentHeight < minColumnHeight) {
        _contentHeight = minColumnHeight;
    }
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.frame = CGRectMake(cellX, cellY, cellWidth, cellHeight);
    
    _columnHeightArr[tempMinColumn] = @(CGRectGetMaxY(attributes.frame));
    
    //更新contentHeight
    for (NSInteger i = 0; i < _columnHeightArr.count; i++) {
        
        CGFloat maxColumnHeight = [_columnHeightArr[i] doubleValue];
        
        if (_contentHeight < maxColumnHeight) {
            _contentHeight = maxColumnHeight;
        }
    }
    
    return attributes;
}
//返回展示数据
- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return _attributesArr;
}
//返回contentSize
- (CGSize)collectionViewContentSize {
    UICollectionView *collectionView = self.collectionView;
    return CGSizeMake(collectionView.frame.size.width, MAX(CGRectGetHeight(collectionView.bounds), _contentHeight));
}
//判断布局更改
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    if ((_oldBounds.size.width != newBounds.size.width) || (_oldBounds.size.height != newBounds.size.height)) {
        return YES;
    }
    return NO;
}
#pragma mark - 私有方法
//列数
- (NSInteger)columnCount {
    if (_columnCount) {
        return _columnCount;
    }
    return 1;
}











@end
