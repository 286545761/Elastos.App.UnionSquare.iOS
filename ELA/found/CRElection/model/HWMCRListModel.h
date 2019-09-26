//
//  HWMCRListModel.h
//  elastos wallet
//
//  Created by 韩铭文 on 2019/9/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HWMCRListModel : NSObject
/*
 *<# #>
 */
@property(copy,nonatomic)NSString *location;
/*
 *<# #>
 */
@property(copy,nonatomic)NSString *index;
/*
 *<# #>
 */
@property(copy,nonatomic)NSString *did;
/*
 *<# #>
 */
@property(copy,nonatomic)NSString *nickname;
/*
 *<# #>
 */
@property(copy,nonatomic)NSString *code;
/*
 *<# #>
 */
@property(copy,nonatomic)NSString *votes;
/*
 *<# #>
 */
@property(copy,nonatomic)NSString *voterate;
/*
 *<# #>
 */
@property(copy,nonatomic)NSString *state;
/*
 *<# #>
 */
@property(copy,nonatomic)NSString *url;
@property(nonatomic,assign)BOOL isCellSelected;
@property(nonatomic,assign)BOOL isNewCellSelected;
@end

NS_ASSUME_NONNULL_END