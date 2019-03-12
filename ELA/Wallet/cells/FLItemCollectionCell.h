//
//  FLItemCollectionCell.h
//  FLWALLET
//
//  Created by fxl on 2018/4/18.
//  Copyright © 2018年 fxl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FLItemCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UIImageView *goldLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconImgWith;

@end
