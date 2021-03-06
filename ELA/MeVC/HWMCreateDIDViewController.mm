//
//  HWMCreateDIDViewController.m
//  elastos wallet
//
//  Created by 韩铭文 on 2019/10/21.
//

#import "HWMCreateDIDViewController.h"
#import "HWMCreateDIDListTableViewCell.h"
#import "HWMDIDWalletListView.h"
#import "HWMDIDDataListView.h"
#import "HMWFMDBManager.h"
#import "ELWalletManager.h"
static NSString *cellString=@"HWMCreateDIDListTableViewCell";

@interface HWMCreateDIDViewController ()<UITableViewDelegate,UITableViewDataSource,HWMDIDWalletListViewDelegate,HWMDIDDataListViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UITableView *table;
/*
 *<# #>
 */
@property(copy,nonatomic)NSArray *dataSorse;
/*
 *<# #>
 */
@property(strong,nonatomic)HWMDIDDataListView *dataListView;
/*
 *<# #>
 */
@property(strong,nonatomic)HWMDIDWalletListView *walletListView;
/*
 *<# #>
 */
@property(strong,nonatomic)NSMutableArray *walletListArray;
/*
 *<# #>
 */
@property(assign,nonatomic)NSInteger wallerSelectIndex;

@end

@implementation HWMCreateDIDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self defultWhite];
    [self setBackgroundImg:@""];
    self.title=NSLocalizedString(@"创建DID", nil);
    [self makeUI];
}
-(NSMutableArray *)walletListArray{
    if (!_walletListArray) {
        NSArray *allWalletListArray=[NSArray arrayWithArray:[[HMWFMDBManager sharedManagerType:walletType] allRecordWallet]];
        _walletListArray=[[NSMutableArray alloc]init];
       for (int i=0; i<allWalletListArray.count; i++) {
              FMDBWalletModel *model=allWalletListArray[i];
              invokedUrlCommand *cmommand=[[invokedUrlCommand alloc]initWithArguments:@[model.walletID] callbackId:model.walletID className:@"wallet" methodName:@"createMasterWallet"];
              PluginResult * resultBase =[[ELWalletManager share]getMasterWalletBasicInfo:cmommand];
              NSString *statusBase=[NSString stringWithFormat:@"%@",resultBase.status];
              NSDictionary *baseDic=[[NSDictionary alloc]init];
              if ([statusBase isEqualToString:@"1"] ) {
                  baseDic=[[FLTools share]dictionaryWithJsonString:resultBase.message[@"success"]];
                  NSString *Readonly=[NSString stringWithFormat:@"%@",baseDic[@"Readonly"]];
                  if ([Readonly isEqualToString:@"0"]) {
                      if ([baseDic[@"M"] integerValue]==1) {
                          model.TypeW=SingleSign;
                          [_walletListArray addObject:model];
                      }else{
                          model.TypeW=HowSign;
                 
                      }
                  }else{
                      if ([baseDic[@"M"] integerValue]==1) {
                          model.TypeW=SingleSignReadonly;
                      }else{
                          model.TypeW=HowSignReadonly;
                      }
                  }
              }
              
              
          
          }
    }
    return _walletListArray;
}
-(void)makeUI{

          self.dataSorse = @[NSLocalizedString(@"请输入DID名称（必填）", nil),NSLocalizedString(@"请选择钱包", nil),NSLocalizedString(@"主管理公钥（发布后不可更改）", nil),NSLocalizedString(@"DID（与主管理公钥一一对应）",nil),
           NSLocalizedString(@"请选择失效日期", nil)];
    [self.nextButton setTitle:NSLocalizedString(@"下一步", nil) forState: UIControlStateNormal];
    [[HMWCommView share]makeBordersWithView:self.nextButton];
    [self.table registerNib:[UINib nibWithNibName:cellString bundle:nil] forCellReuseIdentifier:cellString];
       self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
     self.table.rowHeight = 55;
       self.table.delegate =self;
       self.table.dataSource =self;
    self.table.backgroundColor=[UIColor clearColor];
//       UIImageView *bgview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
//      [self CAGradientColorFrome:RGB(83, 136, 136) withToColor:RGB(16, 47, 58) withView:bgview];
//       self.table.backgroundView = bgview;
      
    
}
-(HWMDIDDataListView *)dataListView{
    if (!_dataListView) {
        _dataListView =[[HWMDIDDataListView alloc]init];
        _dataListView.delegate=self;
    }
    return _dataListView;
}
-(HWMDIDWalletListView *)walletListView{
    if (!_walletListView) {
        _walletListView =[[HWMDIDWalletListView alloc]init];
        _walletListView.delegate=self;
    }
    return _walletListView;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   // FLSugarModel *model = self.dataSouse[indexPath.row];
    HWMCreateDIDListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellString];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    NSString *textString=self.dataSorse[indexPath.row];
    switch (indexPath.row) {
            case 0:
            cell.arrowImageView.alpha=0.f;
            cell.intPutTextField.placeholder=textString;
            [[HMWCommView share]makeTextFieldPlaceHoTextColorWithTextField:cell.intPutTextField withTxt:textString];
            break;
            case 1:
            cell.arrowImageView.alpha=1.f;
            cell.intPutTextField.text=textString;
            cell.intPutTextField.enabled=NO;
            
            break;
            case 2:
            cell.arrowImageView.alpha=0.f;
            cell.intPutTextField.placeholder=textString;
            [[HMWCommView share]makeTextFieldPlaceHoTextColorWithTextField:cell.intPutTextField withTxt:textString];
            break;
            case 3:
            cell.arrowImageView.alpha=0.f;
            cell.intPutTextField.placeholder=textString;
            [[HMWCommView share]makeTextFieldPlaceHoTextColorWithTextField:cell.intPutTextField withTxt:textString];
            break;
            case 4:
            cell.arrowImageView.alpha=1.f;
            cell.intPutTextField.text=textString;
            cell.intPutTextField.enabled=NO;
            break;
            
        default:
            break;
    }
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.dataSorse.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row==1) {
        UIView *mainView =[self mainWindow];
        [mainView addSubview:self.walletListView];
        [self.walletListView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(mainView);
        }];
        self.walletListView.dataSourceArray=self.walletListArray;
        
    }else if (indexPath.row==4){
        UIView *mainView =[self mainWindow];
               [mainView addSubview:self.dataListView];
        [self.dataListView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(mainView);
        }];
    }
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, AppWidth, 50)];
    headView.backgroundColor=[UIColor clearColor];
    UILabel *headLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, AppWidth-30, 50)];
    headLabel.text=NSLocalizedString(@"DID信息", nil);
    headLabel.font=[UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    headLabel.textColor=[UIColor whiteColor];
    [headView addSubview:headLabel];
    return headView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50.f;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]initWithFrame:CGRectZero];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}
#pragma mark ---------HWMDIDWalletListViewDelegate----------
- (void)cancelDIDListViewView {
    [self.walletListView removeFromSuperview];
    self.walletListView=nil;
    
}

- (void)selectListIndex:(NSInteger)index {
    [self cancelDIDListViewView];
    self.wallerSelectIndex=index;
    
}



@end
