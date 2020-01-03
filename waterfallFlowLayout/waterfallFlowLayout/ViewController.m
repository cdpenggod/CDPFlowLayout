//
//  ViewController.m
//  waterfallFlowLayout
//
//  Created by mac on 2020/1/3.
//  Copyright © 2020 CDP. All rights reserved.
//

#import "ViewController.h"

#import "CDPCollectionViewCell.h"

#import "CDPFlowLayout.h" //引入头文件并实现delegate


#define CDPHeader @"CDPHeader"
#define CDPFooter @"CDPFooter"

//如需实现- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;点击方法
//则还要实现UICollectionViewDelegate协议

@interface ViewController () <CDPFlowLayoutDelegate,UICollectionViewDataSource>


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self createCollectionView];
    
}
#pragma mark - 创建UI
-(void)createCollectionView{
    //初始化layout
    CDPFlowLayout *flowLayout=[[CDPFlowLayout alloc] init];
    flowLayout.delegate=self;
    
    UICollectionView *collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height) collectionViewLayout:flowLayout];
    collectionView.showsHorizontalScrollIndicator=NO;
    
    //背景色
    collectionView.backgroundColor=[UIColor cyanColor];
    
    //设置dataSource
    collectionView.dataSource=self;
    
    [self.view addSubview:collectionView];
    
    //注册header，footer，cell
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
              withReuseIdentifier:CDPHeader];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
              withReuseIdentifier:CDPFooter];
    
    [collectionView registerClass:[CDPCollectionViewCell class] forCellWithReuseIdentifier:[CDPCollectionViewCell getIdentifier]];
}
#pragma mark - collectionView相关delegate
//section高
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(CDPFlowLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return 30;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(CDPFlowLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    return 30;
}
//section头尾
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {

    if (kind==UICollectionElementKindSectionHeader) {
        //header
        UICollectionReusableView *view=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                          withReuseIdentifier:CDPHeader
                                                                                 forIndexPath:indexPath];
        //header显示灰色
        view.backgroundColor=[UIColor grayColor];
        return view;
        
    }
    else if(kind==UICollectionElementKindSectionFooter){
        //footer
        UICollectionReusableView *view=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                          withReuseIdentifier:CDPFooter
                                                                                 forIndexPath:indexPath];
        //footer显示黑色
        view.backgroundColor=[UIColor blackColor];
        return view;
    }
    return nil;
}
//section数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 10;
}
//每个section一行多少列
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(CDPFlowLayout *)collectionViewLayout numberOfColumnsInSection:(NSInteger)section{
    return 2;
}
//行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(CDPFlowLayout *)collectionViewLayout lineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 10;
}
//列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(CDPFlowLayout *)collectionViewLayout interitemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 10;
}
//设置section距离上下左右边缘cell相距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(CDPFlowLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(10,10,10,10);
}
//每个item高度
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(CDPFlowLayout *)collectionViewLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth{
    
    return [CDPCollectionViewCell getHeight];
}
//每个section的item数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 12;
}
//cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    CDPCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:[CDPCollectionViewCell getIdentifier]
                                                                          forIndexPath:indexPath];
    [cell update:indexPath.row];
    return cell;
}



            
@end
