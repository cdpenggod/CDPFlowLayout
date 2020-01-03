//
//  CDPCollectionViewCell.h
//  waterfallFlowLayout
//
//  Created by CDP on 2020/1/3.
//  Copyright © 2020 CDP. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface CDPCollectionViewCell : UICollectionViewCell





+(NSString *)getIdentifier;

+(CGFloat)getHeight;


/**
 *  更新cell
 */
-(void)update:(NSInteger)index;






@end



