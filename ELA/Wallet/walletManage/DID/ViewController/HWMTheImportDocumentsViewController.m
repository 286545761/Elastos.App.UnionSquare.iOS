//
//  HWMTheImportDocumentsViewController.m
//  elastos wallet
//
//  Created by  on 2020/2/14.
//

#import "HWMTheImportDocumentsViewController.h"
#import "HWMImportDocumentsTableViewCell.h"
#import "HWMallDocumentsListViewController.h"
#import "MyUtil.h"
#import "NSString+YYAdd.h"
static NSString *cellString=@"HWMImportDocumentsTableViewCell";
UINib *ImportDocumentsNib;
@interface HWMTheImportDocumentsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic)UIButton*skipButton;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property(strong,nonatomic)NSMutableArray *allDirAaary;

@property(assign,nonatomic)NSInteger selectIndex;
@property (weak, nonatomic) IBOutlet UIButton *selectFlieButton;

@end

@implementation HWMTheImportDocumentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self defultWhite];
    [self setBackgroundImg:@""];
    self.title=NSLocalizedString(@"导入凭证", nil);
    self.selectIndex=-1;
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.skipButton];
    [self.selectFlieButton setTitle: NSLocalizedString(@"选择文件", nil) forState:UIControlStateNormal];
    [self makeUI];
}
-(void)makeUI{
    ImportDocumentsNib=[UINib nibWithNibName:cellString bundle:nil];
    [self.table registerNib: ImportDocumentsNib forCellReuseIdentifier:cellString];
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.table.rowHeight = 50;
    self.table.delegate =self;
    self.table.dataSource =self;
    self.table.backgroundColor=[UIColor clearColor];
}
-(UIButton *)skipButton{
    if (!_skipButton) {
        _skipButton =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        [_skipButton setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
        [_skipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _skipButton.titleLabel.font=[UIFont systemFontOfSize:14];
        [_skipButton addTarget:self action:@selector(skipVCEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _skipButton;
}
-(void)setCurrentWallet:(FLWallet *)currentWallet{
    _currentWallet=currentWallet;
}
-(void)skipVCEvent{
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HWMImportDocumentsTableViewCell *cell=[ImportDocumentsNib instantiateWithOwner:nil options:nil].firstObject;
    cell.docNameLabel.text=self.allDirAaary[indexPath.row];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (indexPath.row==self.selectIndex) {
        cell.selectImageView.alpha=1.f;
    }else{
        cell.selectImageView.alpha=0.f;
    }
    return cell;
}
-(NSMutableArray *)allDirAaary{
    if (!_allDirAaary) {
        _allDirAaary =[[NSMutableArray alloc]init];

    }
    return _allDirAaary;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectIndex>-1) {
        HWMImportDocumentsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellString forIndexPath:[NSIndexPath indexPathForRow:self.selectIndex inSection:0]];
        cell.selectImageView.alpha=0.f;
    }
    HWMImportDocumentsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellString forIndexPath:indexPath];
          cell.selectImageView.alpha=1.f;
    
    self.selectIndex=indexPath.row;
    
    
    
    
}
- (IBAction)selectFlieEvent:(id)sender {
    HWMallDocumentsListViewController *HWMallDocumentsListVC=[[HWMallDocumentsListViewController alloc]init];
    __weak __typeof__ (self) weakSelf = self;
    HWMallDocumentsListVC.block = ^(NSString * _Nonnull flieName) {
        [weakSelf ParsingJWTFileWithFileName:flieName];
    };
    [self.navigationController pushViewController:HWMallDocumentsListVC animated:YES];
}
-(void)ParsingJWTFileWithFileName:(NSString*)fileName{
    NSString *fileContString=[MyUtil readFlieCommDIDWithFlieName:fileName];
    
    NSDictionary *dicfileCont=[fileContString jsonValueDecoded];
//    if ([dicfileCont[@"credentialSubject"][@"did"] isEqualToString:self.currentWallet.didString]) {
        [MyUtil saveDIDPathWithWalletID:self.currentWallet.masterWalletID withString:fileContString WithFielName:fileName];
//    }else{// 不是自己的
//
//    }
}
@end
