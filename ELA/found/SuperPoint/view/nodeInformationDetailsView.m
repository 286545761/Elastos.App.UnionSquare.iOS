//
//  nodeInformationDetailsView.m
//  elastos wallet
//
//  Created by 韩铭文 on 2019/6/24.
//

#import "nodeInformationDetailsView.h"

@interface nodeInformationDetailsView()
@property (weak, nonatomic) IBOutlet UIButton *ForInformationButton;
@property (weak, nonatomic) IBOutlet UIButton *IntroductionOfNodeButton;
@property (weak, nonatomic) IBOutlet UIView *ForInformationView;
@property (weak, nonatomic) IBOutlet UIView *IntroductionOfNodeView;
/*
 *<# #>
 */
//@property(strong,nonatomic)UILabel *nodeNameTextLabel;
///*
// *<# #>
// */
//@property(strong,nonatomic)UILabel *nodeNameLabel;
/*
 *<# #>
 */
@property(strong,nonatomic)UILabel *nodeAddressTextLabel;
/*
 *<# #>
 */
@property(strong,nonatomic)UILabel *nodeAddressLabel;
/*
 *<# #>
 */
@property(strong,nonatomic)UILabel *currantVotesTextLabel;
/*
 *<# #>
 */
@property(strong,nonatomic)UILabel *currantVotesLabel;
/*
 *<# #>
 */
@property(strong,nonatomic)UILabel *votePercentageTextLabel;
/*
 *<# #>
 */
@property(strong,nonatomic)UILabel *votePercentageLabel;
/*
 *<# #>
 */
@property(strong,nonatomic)UILabel *countryRegionTextLabel;

@property(strong,nonatomic)UILabel *URLTextLabel;
@property(strong,nonatomic)UILabel *URLLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLable;

@end

@implementation nodeInformationDetailsView
-(instancetype)init{
    self =[super init];
    if (self) {
        self =[[NSBundle mainBundle]loadNibNamed:@"nodeInformationDetailsView" owner:nil options:nil].firstObject;
        [self IntroductionOfNodeAction:nil];
    }
    return self;
    
    
}

- (IBAction)IntroductionOfNodeAction:(id)sender {
    [self seletcButtonState:self.IntroductionOfNodeButton withView:self.IntroductionOfNodeView];
    [self normalButtonState:self.ForInformationButton withView:self.ForInformationView];
    self.infoLable.alpha=0.f;
    self.nodeAddressTextLabel.alpha=1.f;
    self.nodeAddressLabel.alpha=1.f;
    self.currantVotesTextLabel.alpha=1.f;
    self.currantVotesLabel.alpha=1.f;
    self.votePercentageTextLabel.alpha=1.f;
    self.votePercentageLabel.alpha=1.f;
    self.countryRegionTextLabel.alpha=1.f;
    self.URLTextLabel.alpha=1.f;
    self.URLLabel.alpha=1.f;
    self.countryRegionLabel.alpha=1.f;
    self.copURLButton.alpha=1.f;
}

- (IBAction)ForInformationAction:(id)sender {
    [self normalButtonState:self.IntroductionOfNodeButton withView:self.IntroductionOfNodeView];
    [self seletcButtonState:self.ForInformationButton withView:self.ForInformationView];
     self.infoLable.alpha=1.f;
    self.nodeAddressTextLabel.alpha=0.f;
    self.nodeAddressLabel.alpha=0.f;
    self.currantVotesTextLabel.alpha=0.f;
    self.currantVotesLabel.alpha=0.f;
    self.votePercentageTextLabel.alpha=0.f;
    self.votePercentageLabel.alpha=0.f;
    self.countryRegionTextLabel.alpha=0.f;
    self.URLTextLabel.alpha=0.f;
    self.URLLabel.alpha=0.f;
    self.countryRegionLabel.alpha=0.f;
    self.copURLButton.alpha=0.f;
}
-(void)seletcButtonState:(UIButton*)button withView:(UIView*)view{
  [button setTitleColor:RGBA(255, 255, 255, 0.5) forState:UIControlStateNormal];
    view.alpha=1.f;
    
}
-(void)normalButtonState:(UIButton*)button withView:(UIView*)view{
    
       [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     view.alpha=0.f;
    
}
-(UIButton *)copURLButton{
    if (!_copURLButton) {
        _copURLButton =[[UIButton alloc]init];
        [_copURLButton setImage:[UIImage imageNamed:@"asset_transfer_copyW"] forState:UIControlStateNormal];
        [_copURLButton addTarget:self action:@selector(copyURLEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _copURLButton;
}
-(void)makeUI{
    self.nodeAddressTextLabel=[self labeWithTextColor:RGBA(255, 255, 255, 0.5) withText:NSLocalizedString(@"节点公钥", nil) withTextFont:14 withTextAlignment:NSTextAlignmentLeft];
    [self addSubview:self.nodeAddressTextLabel];
    [self.nodeAddressTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(0);
        make.top.equalTo( self.ForInformationButton.mas_bottom).offset(0);
        make.size.mas_equalTo(CGSizeMake(100, 35));
    }];
    self.nodeAddressLabel=[self labeWithTextColor:[UIColor whiteColor] withText:self.model.ownerpublickey withTextFont:14 withTextAlignment:NSTextAlignmentRight];
    [self addSubview:self.nodeAddressLabel];
    [self.nodeAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(0);
        make.centerY.equalTo(self.nodeAddressTextLabel.mas_centerY);
        make.height.mas_equalTo(@60);
        make.left.equalTo(self.nodeAddressTextLabel.mas_right).offset(10);
    }];
    
    self.currantVotesTextLabel=[self labeWithTextColor:RGBA(255, 255, 255, 0.5) withText:NSLocalizedString(@"当前票数", nil) withTextFont:14 withTextAlignment:NSTextAlignmentLeft];
    [self addSubview:self.currantVotesTextLabel];
    [self.currantVotesTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(0);
        make.top.equalTo( self.nodeAddressTextLabel.mas_bottom).offset(30);
        make.size.mas_equalTo(CGSizeMake(100, 15));
    }];
    self.currantVotesLabel=[self labeWithTextColor:[UIColor whiteColor] withText:[NSString stringWithFormat:@"%ld %@",(long)[self.model.votes integerValue],NSLocalizedString(@"票", nil)] withTextFont:14 withTextAlignment:NSTextAlignmentRight];
    [self addSubview:self.currantVotesLabel];
    [self.currantVotesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(0);
        make.centerY.equalTo(self.self.currantVotesTextLabel.mas_centerY);
        make.height.mas_equalTo(@30);
        make.left.equalTo(self.currantVotesTextLabel.mas_right).offset(10);
    }];
    
    
    self.votePercentageTextLabel=[self labeWithTextColor:RGBA(255, 255, 255, 0.5) withText:NSLocalizedString(@"投票占比", nil) withTextFont:14 withTextAlignment:NSTextAlignmentLeft];
    [self addSubview:self.votePercentageTextLabel];
    [self.votePercentageTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(0);
        make.top.equalTo( self.currantVotesTextLabel.mas_bottom).offset(30);
        make.size.mas_equalTo(CGSizeMake(160, 15));
    }];
    self.votePercentageLabel=[self labeWithTextColor:[UIColor whiteColor] withText:[NSString stringWithFormat:@"%.5lf %@",self.model.voterate.doubleValue*100,@"%"] withTextFont:14 withTextAlignment:NSTextAlignmentRight];
    [self addSubview:self.votePercentageLabel];
    [self.votePercentageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(0);
        make.centerY.equalTo(self.votePercentageTextLabel.mas_centerY);
        make.height.mas_equalTo(@30);
        make.left.equalTo(self.votePercentageTextLabel.mas_right).offset(10);
    }];
    
    self.countryRegionTextLabel=[self labeWithTextColor:RGBA(255, 255, 255, 0.5) withText:NSLocalizedString(@"国家/地区", nil) withTextFont:14 withTextAlignment:NSTextAlignmentLeft];
    [self addSubview:self.countryRegionTextLabel];
    [self.countryRegionTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(0);
        make.top.equalTo( self.votePercentageTextLabel.mas_bottom).offset(30);
        make.size.mas_equalTo(CGSizeMake(160, 15));
    }];
    self.countryRegionLabel=[self labeWithTextColor:[UIColor whiteColor] withText:@"--" withTextFont:14 withTextAlignment:NSTextAlignmentRight];
    [self addSubview:self.countryRegionLabel];
    [self.countryRegionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(0);
        make.centerY.equalTo(self.countryRegionTextLabel.mas_centerY);
        make.height.mas_equalTo(@30);
        make.left.equalTo(self.countryRegionTextLabel.mas_right).offset(10);
    }];
    self.URLTextLabel=[self labeWithTextColor:RGBA(255, 255, 255, 0.5) withText:@"URL" withTextFont:14 withTextAlignment:NSTextAlignmentLeft];
    [self addSubview:self.URLTextLabel];
    [self.URLTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(0);
        make.top.equalTo( self.countryRegionTextLabel.mas_bottom).offset(30);
        make.size.mas_equalTo(CGSizeMake(30, 15));
    }];
    self.URLLabel=[self labeWithTextColor:RGB(40, 147, 232) withText:self.model.url withTextFont:14 withTextAlignment:NSTextAlignmentRight];
    [self addSubview:self.URLLabel];
    [self.URLLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-55);
        make.centerY.equalTo(self.URLTextLabel.mas_centerY);
        make.height.mas_equalTo(@30);
        make.left.equalTo(self.URLTextLabel.mas_right).offset(5);
    }];
    
    
    [self addSubview:self.copURLButton];
    [self.copURLButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.centerY.equalTo(self.URLTextLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(46, 46));
    }];
}

-(void)setModel:(FLCoinPointInfoModel *)model
{
    _model = model;
    [self makeUI];
    
}
-(UILabel*)labeWithTextColor:(UIColor*)color withText:(NSString*)text withTextFont:(CGFloat)font withTextAlignment:(NSTextAlignment)TextA{
    UILabel *labe =[[UILabel alloc]init];
    labe.text=text;
    labe.textAlignment=TextA;
    labe.font=[UIFont systemFontOfSize:font];
    labe.numberOfLines=0;
    labe.textColor=color;
    return labe;
}
-(void)layoutSubviews{
   
}

@end