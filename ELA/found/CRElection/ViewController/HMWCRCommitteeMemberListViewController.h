//
//  HMWCRCommitteeMemberListViewController.h
//  elastos wallet
//
//  Created by 韩铭文 on 2019/8/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HMWCRCommitteeMemberListViewController : UIViewController
/*
 *<# #>
 */
@property(copy,nonatomic)NSString *typeString;
/*
 *
 */
@property(copy,nonatomic)NSString *CROwnerDID;
/*
 *<# #>
 */
@property(copy,nonatomic)NSString *CROwnerPublicKey;
@property(copy,nonatomic)NSString *nodeName;
@end

NS_ASSUME_NONNULL_END
