//
//  HMWTheWalletManagementViewController.m
//  ELA
//
//  Created by  on 2019/1/3.
//  Copyright © 2019 HMW. All rights reserved.
//

#import "HMWTheWalletManagementViewController.h"
#import "HMWTheWalletManagementTableViewCell.h"
#import "HMWToDeleteTheWalletPopView.h"
#import "HMWSecurityVerificationPopView.h"
#import "HMWModifyTheWalletNameViewController.h"
#import "HMWModifyTheWalletPasswordViewController.h"
#import "HMWsettingKeyStorePWDViewController.h"
#import "HMWExportTheMnemonicWordViewController.h"
#import "ELWalletManager.h"
#import "HMWFMDBManager.h"
#import "FMDBWalletModel.h"
#import "FLPrepareVC.h"
#import "BaseNavigationVC.h"
#import "HWMSignatureTradingSingleQrCodeViewController.h"
#import "AppDelegate.h"
#import "HWMListMoreSignThePublicKeyViewController.h"
#import "HWMTheValidationWordMnemonicPassword.h"


static NSString *cellString=@"HMWTheWalletManagementTableViewCell";


@interface HMWTheWalletManagementViewController ()<UITableViewDelegate,UITableViewDataSource,HMWToDeleteTheWalletPopViewDelegate,HMWSecurityVerificationPopViewDelegate,HWMTheValidationWordMnemonicPasswordDelegate>
@property (weak, nonatomic) IBOutlet UITableView *baseTableView;
/*
*<# #>
*/
@property(strong,nonatomic)UIButton *toDeleteTheWalletButton;
/*
*<# #>
*/
@property(strong,nonatomic)NSArray *dataArray;
//#import "HMWToDeleteTheWalletPopView.h"
    /*
     *<# #>
     */
    @property(strong,nonatomic)HMWToDeleteTheWalletPopView *toDeleteTheWalletPopV;
/*
 *<# #>
 */
@property(strong,nonatomic)HWMTheValidationWordMnemonicPassword *TheValidationWordMPView;
//#import "HMWSecurityVerificationPopView.h"
/*
*<# #>
*/
@property(strong,nonatomic)HMWSecurityVerificationPopView *securityVerificationPopV;
    /*
     *
     */
    @property(assign,nonatomic)NSIndexPath *selectIndex;
    
/*
 *<# #>
 */
@property(copy,nonatomic)NSString *VerifyPayPassword;
@end

@implementation HMWTheWalletManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.userInteractionEnabled=YES;
    [self defultWhite];
    [self setBackgroundImg:@""];
    self.title=NSLocalizedString(@"钱包管理", nil);
    [self makeView];
    UITapGestureRecognizer *delTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toDeleteTheWalletEvent)];
    [self.toDeleteTheWalletButton addGestureRecognizer:delTap];
    [self.view addSubview:self.toDeleteTheWalletButton];
    [self.toDeleteTheWalletButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-80);
        make.left.equalTo(self.view.mas_left).offset(63);
        make.right.equalTo(self.view.mas_right).offset(-63);
        make.height.equalTo(@40);
    }];
     [[HMWCommView share]makeBordersWithView:self.toDeleteTheWalletButton];
}
-(UIButton *)toDeleteTheWalletButton{
    if (!_toDeleteTheWalletButton) {
        _toDeleteTheWalletButton =[[UIButton alloc]init];
        
        [_toDeleteTheWalletButton setTitle:NSLocalizedString(@"删除钱包", nil) forState:UIControlStateNormal];
        _toDeleteTheWalletButton.titleLabel.font=[UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        
           [_toDeleteTheWalletButton addTarget:self action:@selector(toDeleteTheWalletEvent) forControlEvents: UIControlEventTouchUpInside];
        _toDeleteTheWalletButton.backgroundColor=RGBA(63, 92, 104, 0.5);
        
        
    }
    return _toDeleteTheWalletButton;
}
-(void)toDeleteTheWalletEvent{
        UIView *mainView=[self mainWindow];
        [mainView addSubview:self.toDeleteTheWalletPopV];
        [self.toDeleteTheWalletPopV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(mainView);
        }];
}
-(HMWSecurityVerificationPopView *)securityVerificationPopV{
        if (!_securityVerificationPopV) {
            _securityVerificationPopV =[[HMWSecurityVerificationPopView alloc]init];
            _securityVerificationPopV.delegate=self;
        }
        return _securityVerificationPopV;
    }
-(HWMTheValidationWordMnemonicPassword *)TheValidationWordMPView{
    if (!_TheValidationWordMPView) {
  _TheValidationWordMPView=[[HWMTheValidationWordMnemonicPassword alloc]init];
        _TheValidationWordMPView.delegate=self;
    }
    return _TheValidationWordMPView;
}
-(HMWToDeleteTheWalletPopView *)toDeleteTheWalletPopV{
        if (!_toDeleteTheWalletPopV) {
            _toDeleteTheWalletPopV =[[HMWToDeleteTheWalletPopView alloc]init];
            _toDeleteTheWalletPopV.delegate=self;
            _toDeleteTheWalletPopV.deleteType=deleteTheWallet;
        }
        return _toDeleteTheWalletPopV;
    }
-(NSArray *)dataArray{
        if (!_dataArray) {
          
            switch (self.currentWallet.TypeW) {
//                    SingleSign
                case 0:
                    _dataArray =@[@{@"title":NSLocalizedString(@"修改钱包名称", nil),@"name":self.currentWallet.walletName,@"type":@"1"},
                                  @{@"title":NSLocalizedString(@"修改钱包密码",nil),@"name":@"",@"type":@"2"},
                                  @{@"title":NSLocalizedString(@"导出Keystore",nil),@"name":@"",@"type":@"1"},
                                  @{@"title":NSLocalizedString(@"导出助记词",nil),@"name":@"",@"type":@"1"}
//,
//                                  @{@"title":NSLocalizedString(@"导出只读钱包",nil),@"name":@"",@"type":@"1"},
//                                  @{@"title":NSLocalizedString(@"查看多签公钥",nil),@"name":@"",@"type":@"1"}
                                  
                                  ];
                    break;
                case 1:
//                    SingleSignReadonly
                    _dataArray =@[@{@"title":NSLocalizedString(@"修改钱包名称", nil),@"name":self.currentWallet.walletName,@"type":@"1"},
                                  @{@"title":NSLocalizedString(@"导出Keystore",nil),@"name":@"",@"type":@"2"},
                                  @{@"title":NSLocalizedString(@"导出只读钱包",nil),@"name":@"",@"type":@"1"},
                                  @{@"title":NSLocalizedString(@"查看多签公钥",nil),@"name":@"",@"type":@"1"}];
                    break;
                case 2:
//                   HowSign
                    _dataArray =@[@{@"title":NSLocalizedString(@"修改钱包名称", nil),@"name":self.currentWallet.walletName,@"type":@"1"},@{@"title":NSLocalizedString(@"修改钱包密码",nil),@"name":@"",@"type":@"2"},@{@"title":NSLocalizedString(@"导出Keystore",nil),@"name":@"",@"type":@"1"}
                                  ,@{@"title":NSLocalizedString(@"查看钱包公钥",nil),@"name":@"",@"type":@"1"}
                                  ];
                    break;
                case 3:
//                    HowSignReadonly
                    _dataArray =@[@{@"title":NSLocalizedString(@"修改钱包名称", nil),@"name":self.currentWallet.walletName,@"type":@"1"},@{@"title":NSLocalizedString(@"导出Keystore",nil),@"name":@"",@"type":@"1"},@{@"title":NSLocalizedString(@"查看钱包公钥",nil),@"name":@"",@"type":@"1"}];
                    break;

                default:
                    break;
            }
        }
        return _dataArray;
    }
-(void)makeView{
    self.baseTableView.delegate=self;
    self.baseTableView.dataSource=self;
    self.baseTableView.scrollEnabled=NO;
    self.baseTableView.backgroundColor=[UIColor clearColor];
    self.baseTableView.rowHeight=70;
    [self.baseTableView registerNib:[UINib nibWithNibName:cellString bundle:nil] forCellReuseIdentifier:cellString];
self.baseTableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
        
        return self.dataArray.count;
    }
    
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        HMWTheWalletManagementTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellString];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
    cell.dic=self.dataArray[indexPath.section];
        return cell;
        
  
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectIndex=indexPath;

    NSDictionary *dic=self.dataArray[indexPath.section];
    NSString *title=dic[@"title"];
    if ([title isEqualToString:NSLocalizedString(@"修改钱包名称", nil)]) {
        HMWModifyTheWalletNameViewController*modifyTheWalletNameVC=[[HMWModifyTheWalletNameViewController alloc]init];
        modifyTheWalletNameVC.wallet=self.currentWallet;
        [self.navigationController pushViewController:modifyTheWalletNameVC animated:YES];
    }else if ([title isEqualToString:NSLocalizedString(@"修改钱包密码",nil)]){
        HMWModifyTheWalletPasswordViewController *modifyTheWalletPasswordVC=[[HMWModifyTheWalletPasswordViewController alloc]init];
        modifyTheWalletPasswordVC.title=NSLocalizedString(@"修改钱包密码",nil);
        modifyTheWalletPasswordVC.currentWallet=self.currentWallet;
        [self.navigationController pushViewController:modifyTheWalletPasswordVC animated:YES];
        
    }else if ([title isEqualToString:NSLocalizedString(@"导出Keystore",nil)]){
        HMWsettingKeyStorePWDViewController * settingKeyStorePWDVC=[[HMWsettingKeyStorePWDViewController alloc]init];
        settingKeyStorePWDVC.wallet=self.currentWallet;
        [self.navigationController pushViewController:settingKeyStorePWDVC animated:YES];
        
    }else if ([title isEqualToString:NSLocalizedString(@"导出助记词",nil)]){
        UIView *mainView=[self mainWindow];
        [mainView addSubview:self.securityVerificationPopV];
        [self.securityVerificationPopV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(mainView);
        }];
        
    }else if ([title isEqualToString:NSLocalizedString(@"导出只读钱包",nil)]){
//      ExportReadonlyWallet
        invokedUrlCommand *mommand=[[invokedUrlCommand alloc]initWithArguments:@[self.currentWallet.masterWalletID] callbackId:self.currentWallet.walletID className:@"Wallet" methodName:@"ExportReadonlyWallet"];
        
        PluginResult *result= [[ELWalletManager share] ExportReadonlyWallet:mommand];
        NSString *status=[NSString stringWithFormat:@"%@",result.status];
        
        if ([status isEqualToString:@"1"]) {
            NSString *type;
            if (self.currentWallet.TypeW ==0) {// 单签钱包
                type=@"1";
            }
            NSDictionary *jsonDic=[[FLTools share]CreateQrCodeImage:result.message[@"success"] WithType:type withSubWalletIdChain:@"ELA"];
            HWMSignatureTradingSingleQrCodeViewController *vc=[[HWMSignatureTradingSingleQrCodeViewController alloc]init];
            vc.type=ExportReadOnlyWallet;
            vc.QRCodeSignatureDic=jsonDic;
                    [self.navigationController pushViewController:vc animated:YES];
           
            
        }
       
        
    }else if ([title isEqualToString:NSLocalizedString(@"查看多签公钥",nil)]){
        invokedUrlCommand *mommand=[[invokedUrlCommand alloc]initWithArguments:@[self.currentWallet.masterWalletID] callbackId:self.currentWallet.walletID className:@"Wallet" methodName:@"getMasterWalletBasicInfo"];
        
        PluginResult *result= [[ELWalletManager share]getMasterWalletPublicKey:mommand];
        NSString *status=[NSString stringWithFormat:@"%@",result.status];
        if ([status isEqualToString:@"1"]) {
        HWMSignatureTradingSingleQrCodeViewController *vc=[[HWMSignatureTradingSingleQrCodeViewController alloc]init];
        vc.type=LookhHowSignThePublicKey;
            NSDictionary * DataDic=[[FLTools share]dictionaryWithJsonString:result.message[@"success"]];
        vc.QRCodeString=DataDic[@"xPubKeyHDPM"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
    else if ([title isEqualToString:NSLocalizedString(@"查看钱包公钥",nil)]){
        invokedUrlCommand *mommand=[[invokedUrlCommand alloc]initWithArguments:@[self.currentWallet.masterWalletID] callbackId:self.currentWallet.walletID className:@"Wallet" methodName:@"getMasterWalletPublicKey"];
        
        PluginResult *result= [[ELWalletManager share]getMasterWalletPublicKey:mommand];
        NSString *status=[NSString stringWithFormat:@"%@",result.status];
        if ([status isEqualToString:@"1"]) {
            
            HWMListMoreSignThePublicKeyViewController *ListMoreSignThePublicKeyVC=[[HWMListMoreSignThePublicKeyViewController alloc]init];
            ListMoreSignThePublicKeyVC.typeW=self.currentWallet.TypeW;
            ListMoreSignThePublicKeyVC.DataDic=[[FLTools share]dictionaryWithJsonString:result.message[@"success"]];
            [self.navigationController pushViewController:ListMoreSignThePublicKeyVC animated:YES];
        }

    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 5;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    
    
    UIView *fooView =[[UIView alloc]init];
    
    fooView.backgroundColor=[UIColor clearColor];
    
    return fooView;
}
#pragma mark ---------HMWToDeleteTheWalletPopViewDelegate----------
-(void)sureToDeleteViewWithPWD:(NSString *)pwd{
    [self toCancelOrCloseDelegate];
    invokedUrlCommand *mommand=[[invokedUrlCommand alloc]initWithArguments:@[self.currentWallet.masterWalletID,pwd] callbackId:self.currentWallet.walletID className:@"Wallet" methodName:@"exportWalletWithMnemonic"];
    
    PluginResult *result= [[ELWalletManager share]VerifyPayPassword:mommand];
    NSString *status=[NSString stringWithFormat:@"%@",result.status];
    
    if ([status isEqualToString:@"1"]&&[result.message[@"success"] isEqualToString:@"1"]) {
        if (self.currentWallet.HasPassPhrase==YES) {
            self.VerifyPayPassword=pwd;
               UIView *mainView=[self mainWindow];
               [mainView addSubview:self.TheValidationWordMPView];
               [self.TheValidationWordMPView mas_makeConstraints:^(MASConstraintMaker *make){
    make.left.top.right.bottom.equalTo(mainView);}];
        }else{
            [self DestroyMasterWallet];

        }


    }else{

        [[FLTools share]showErrorInfo:NSLocalizedString(@"密码错误", nil)];

    }
}
- (void)toCancelOrCloseDelegate {
    [self.toDeleteTheWalletPopV removeFromSuperview];
    
    self.toDeleteTheWalletPopV=nil;
    
}

-(void)DestroyMasterWallet{
    
    FMDBWalletModel *model=[[FMDBWalletModel alloc]init];
    model.walletID=self.currentWallet.masterWalletID;
    
    invokedUrlCommand *mommand=[[invokedUrlCommand alloc]initWithArguments:@[self.currentWallet.masterWalletID] callbackId:self.currentWallet.walletID className:@"Wallet" methodName:@"DestroyMasterWallet"];
    PluginResult *result= [[ELWalletManager share] DestroyMasterWallet:mommand];
    NSString *status=[NSString stringWithFormat:@"%@",result.status];
    if (![status isEqualToString:@"1"]) {
        return;
    }
    [[HMWFMDBManager sharedManagerType:walletType]delectRecordWallet:model];
    [[FLTools share]showErrorInfo:NSLocalizedString(@"删除成功", nil)];
    [self toCancelOrCloseDelegate];
    if ([[[HMWFMDBManager sharedManagerType:walletType]allRecordWallet] count]!=0) {
        [[NSNotificationCenter defaultCenter]postNotificationName:updataWallet object:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        
        FLPrepareVC *vc=[[FLPrepareVC alloc]init];
        BaseNavigationVC *naVC=[[BaseNavigationVC alloc]initWithRootViewController:vc];
        vc.type=creatWalletType;
        AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appdelegate.window.rootViewController= naVC;
    }
}
#pragma mark ---------MWSecurityVerificationPopViewDelegate----------
- (void)makeSureWithPWD:(NSString *)pwdString {
    [self takeOutOrShutDown];
    NSDictionary *dic=self.dataArray[self.selectIndex.section];
    NSString *title=dic[@"title"];
    
    if ([title isEqualToString:NSLocalizedString(@"修改钱包名称", nil)]) {
        
    }else if ([title isEqualToString:NSLocalizedString(@"修改钱包密码",nil)]){
        
    }else if ([title isEqualToString:NSLocalizedString(@"导出Keystore",nil)]){
       
        
    }else if ([title isEqualToString:NSLocalizedString(@"导出助记词",nil)]){
        invokedUrlCommand *mommand=[[invokedUrlCommand alloc]initWithArguments:@[self.currentWallet.masterWalletID,pwdString] callbackId:self.currentWallet.walletID className:@"Wallet" methodName:@"exportWalletWithMnemonic"];
        
        
        
        
        PluginResult *result= [[ELWalletManager share] exportWalletWithMnemonic:mommand];
        self.currentWallet.passWord=pwdString;
        NSString *status=[NSString stringWithFormat:@"%@",result.status];
        
        if ([status isEqualToString:@"1"]) {
            NSString *theMnemonicWord=result.message[@"success"];
            HMWExportTheMnemonicWordViewController *exportTheMnemonicWordVC=[[HMWExportTheMnemonicWordViewController alloc]init];
            exportTheMnemonicWordVC.theMnemonicWord=theMnemonicWord;
            exportTheMnemonicWordVC.currentWallet=self.currentWallet;
              [self.navigationController pushViewController:exportTheMnemonicWordVC animated:YES];
        }
        
    }else if ([title isEqualToString:NSLocalizedString(@"导出只读钱包",nil)]){
//        HWMSignatureTradingSingleQrCodeViewController *vc=[[HWMSignatureTradingSingleQrCodeViewController alloc]init];
//        vc.type=ExportReadOnlyWallet;
//        [self.navigationController pushViewController:vc animated:YES];
        
    }
//    else if ([title isEqualToString:NSLocalizedString(@"查看多签公钥",nil)]){
//
//
//    }
    
  
}
    
- (void)takeOutOrShutDown {
    [self toCancelOrCloseDelegate];
    [self.securityVerificationPopV removeFromSuperview];
    self.securityVerificationPopV =nil;
    
}
    
-(void)setCurrentWallet:(FLWallet *)currentWallet{
    _currentWallet=currentWallet;
    
}
-(void)closeView{
    [self.TheValidationWordMPView removeFromSuperview];
    self.TheValidationWordMPView=nil;
    
}
-(void)MandatoryDeleteWithPWD:(NSString*)PWD{
    [self takeOutOrShutDown];
    if (PWD==0) {
          [self closeView];
        [self DestroyMasterWallet];
        return;
    }
    invokedUrlCommand *mommand=[[invokedUrlCommand alloc]initWithArguments:@[self.currentWallet.masterWalletID,PWD,self.VerifyPayPassword] callbackId:self.currentWallet.walletID className:@"Wallet" methodName:@"VerifyPassPhrase"];
    PluginResult *result= [[ELWalletManager share] VerifyPassPhrase:mommand];
    NSString *status=[NSString stringWithFormat:@"%@",result.status];
    if ([status isEqualToString:@"1"]&&[result.message[@"success"] isEqualToString:@"1"]) {
          [self closeView];
        [self DestroyMasterWallet];
    }else{
        [[FLTools share]showErrorInfo:NSLocalizedString(@"密码错误", nil)];
    }
}
    @end
