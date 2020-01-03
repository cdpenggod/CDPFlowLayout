//
//  CDPCollectionViewCell.m
//  waterfallFlowLayout
//
//  Created by mac on 2020/1/3.
//  Copyright © 2020 CDP. All rights reserved.
//

#import "CDPCollectionViewCell.h"

@implementation CDPCollectionViewCell{
    
    UILabel *_label;
}




+(NSString *)getIdentifier{
    return @"CDPCollectionViewCell";
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.contentView.backgroundColor=[UIColor whiteColor];
        self.userInteractionEnabled=NO;
        
        [self createUI];
    }
    return self;
}

+(CGFloat)getHeight{
    return arc4random()%200+40;
}
//更新cell
-(void)update:(NSInteger)index{
    _label.text=[NSString stringWithFormat:@"%ld",(long)index];
}
#pragma mark - 创建UI
-(void)createUI{
    _label=[[UILabel alloc] initWithFrame:CGRectMake(0,0,([UIScreen mainScreen].bounds.size.width-30)/2,40)];
    _label.textAlignment=NSTextAlignmentCenter;
    _label.textColor=[UIColor blackColor];
    _label.font=[UIFont systemFontOfSize:20];
    [self.contentView addSubview:_label];
}


@end
