//
//  HWMCRCCommitteeElectionCollectionViewCell.m
//  elastos wallet
//
//  Created by 韩铭文 on 2019/9/3.
//

#import "HWMCRCCommitteeElectionCollectionViewCell.h"


@interface HWMCRCCommitteeElectionCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *NoIndexLabel;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *VotesAndPercentagesLabel;

@end

@implementation HWMCRCCommitteeElectionCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [[HMWCommView share]makeBordersWithView:self.contentView];
    self.NoIndexLabel.layer.cornerRadius=2.f;
    self.NoIndexLabel.layer.masksToBounds=YES;
}
-(void)setModel:(HWMCRListModel *)model{

    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:@"found_vote_initial_F"]];
    
    self.nickNameLabel.text = model.nickname;
    //  self.theValueOfLabel.text = model.votes;
    NSString *votes =[NSString stringWithFormat:@"%ld %@",(long)[model.votes integerValue],NSLocalizedString(@"票", nil)];
    NSString *voterateString=[NSString stringWithFormat:@" | %@ %@",model.voterate,@"%"];
    
        dispatch_group_t group =  dispatch_group_create();
         __block NSString *locationLabelString;
        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           locationLabelString= [[FLTools share]contryNameTransLateByCode:[model.location intValue]];
         });
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
              self.locationLabel.text= locationLabelString;
             
         });
    self.VotesAndPercentagesLabel.text=[NSString stringWithFormat:@"%@%@",votes,voterateString];
    if ([model.index integerValue]>12) {
        self.NoIndexLabel.text=[NSString stringWithFormat:@"%@",model.index ];
    }else{
        self.NoIndexLabel.text=[NSString stringWithFormat:@"NO.%@",model.index];
    }
    if (self.isEdiet) {
        self.VotesAndPercentagesLabel.alpha=0.f;
        self.SelectedImageView.alpha=1.f;
        self.locationLabel.alpha=0.f;
        if (model.isCellSelected==NO) {
        if (model.isNewCellSelected) {
            self.SelectedImageView.image=[UIImage imageNamed:@"found_vote_select"];
            }else{
          self.SelectedImageView.image=[UIImage imageNamed:@"found_not_select"];
          }
        }else{
           self.SelectedImageView.image=[UIImage imageNamed:@"selected_already"];
        }
    }else{
        self.locationLabel.alpha=1.f;
        self.VotesAndPercentagesLabel.alpha=1.f;
        self.SelectedImageView.alpha=0.f;
    }
    _model = model;
    
}
-(void)setIsEdiet:(BOOL)isEdiet{
    _isEdiet=isEdiet;
}
@end
