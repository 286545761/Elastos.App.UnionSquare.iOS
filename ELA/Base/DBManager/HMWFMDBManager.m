//
//  HMWFMDBManager.m
//  elastos wallet
//
//  Created by  on 2019/1/12.
//

#import "HMWFMDBManager.h"
#import "MyUtil.h"
static HMWFMDBManager * _manager =nil;
@implementation HMWFMDBManager
+(instancetype)sharedManagerType:(FMDatabaseType)type{
    NSString *path =NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    //    NSString *path =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    //    NSString*path= [MyUtil getRootPath];
    
    NSString *dataBaseName;
    NSString *sql;
    
    if ( [[NSFileManager defaultManager] createDirectoryAtPath:[path stringByAppendingPathComponent:dataBaseName] withIntermediateDirectories:NO attributes:nil error:nil]) {
        
    }
    dataBaseName=@"friends.db";
    if (type ==friendsModelType) {
        sql =@"create table if not exists Person(ID integer primary key AUTOINCREMENT,nameString text,address text,mobilePhoneNo text,email text,note text)";
    }else if (type==walletType){
        sql =@"create table if not exists wallet(ID integer primary key AUTOINCREMENT,walletID text,walletAddress text,walletName text)";
        
        
    }else if (type==sideChain){
        sql =@"create table if not exists sideChain(ID integer primary key AUTOINCREMENT,walletID text,sideChainName text,sideChainNameTime text,thePercentageMax text,thePercentageCurr text)";
        
    }else if (type==CRListType){
         sql =@"create table if not exists RMList(ID integer primary key AUTOINCREMENT,walletID text,location text,indexCR text,did text,nickname text,code text,votes text,voterateCR text ,state text ,url text)";
        
    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (_manager ==nil) {
            _manager=[[HMWFMDBManager alloc]initWithPath:[path stringByAppendingString:dataBaseName]];
            [_manager open];
        }
        
    });
    
    
    if (  [_manager executeUpdate:sql]) {
        
    }else{
        
        
        
        
    }
    //    if (type==sideChain){
    //        NSString *thePercentageMaxStr = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ INTEGER",@"sideChain",@"thePercentageMax"];
    //        BOOL worked = [_manager executeUpdate:thePercentageMaxStr];
    //        if(worked){
    //            NSLog(@"thePercentageMax插入成功");
    //        }else{
    //            NSLog(@"thePercentageMax插入失败");
    //        }
    //        NSString *thePercentageCurrStr = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ INTEGER",@"sideChain",@"sideChainNameTime"];
    //        BOOL Currworked = [_manager executeUpdate:thePercentageCurrStr];
    //        if(Currworked){
    //            NSLog(@"thePercentageCurr插入成功");
    //        }else{
    //            NSLog(@"thePercentageCurr插入失败");
    //        }
    
    
    //    }
    
    return _manager;
    
}

-(BOOL)addsideChain:(sideChainInfoModel*)model{
    if ([self selectAddsideChainWithWalletID:model.walletID andWithIconName:model.sideChainName]) {
        return YES;
    }
    NSString *sql =[NSString stringWithFormat: @"insert into sideChain (walletID,sideChainName,sideChainNameTime,thePercentageMax,thePercentageCurr) values (\'%@\',\'%@\',\'%@\',\'%@\',\'%@\');", model.walletID,model.sideChainName,model.sideChainNameTime,model.thePercentageMax,model.thePercentageCurr];
    if ([self  executeUpdate:sql]) {
        return YES;
    }else{
        return NO;
    }
    
    //    NSString *sql =@"insert into sideChain (walletID,sideChainName,sideChainNameTime) values(?,?,?)";
    //   sideChainInfoModel *smodel=[self selectAddsideChainWithWalletID:model.walletID andWithIconName:model.sideChainName];
    //
    //    if(smodel){
    //
    //        [self delectSideChain:model.ID];
    //
    //    }
    //
    //    if ([self executeUpdate:sql,model.walletID,model.sideChainName,model.sideChainNameTime]) {
    //        DLog(@"完成!");
    //        return YES;
    //
    //
    //    }else{
    //        DLog(@"失败!");
    //
    //        return NO;
    //    }
    //
}
//增加

-(BOOL)addRecord:(friendsModel *)person{
    //    nameString text,address text,mobilePhoneNo text,email text,note text
    
    
    
    
    NSString *sql =@"insert into Person (nameString,address,mobilePhoneNo,email,note) values(?,?,?,?,?)";
    if ([self executeUpdate:sql,person.nameString,person.address,person.mobilePhoneNo,person.email,person.note]) {
        //        DLog(@"完成!");
        [[NSNotificationCenter defaultCenter]postNotificationName:myfriendNeedUpdate object:nil];
        return YES;
        
        
    }else{
        //         DLog(@"失败!");
        
        return NO;
    }
    
    
}
//查
-(sideChainInfoModel*)selectAddsideChainWithWalletID:(NSString*)walletID andWithIconName:(NSString*)iconName{
    NSString *sql =[NSString stringWithFormat: @"select * from sideChain where walletID=\'%@\' and sideChainName=\'%@\'" ,walletID,iconName];
    
    FMResultSet *set=[self executeQuery:sql];
    NSMutableArray *allRecords=[[NSMutableArray alloc]init];
    //    一条一条的读取数据 并专程模型
    while (set.next) {
        //        模型
        sideChainInfoModel * p= [[sideChainInfoModel alloc]init];
        //        去出表中存放的内容给person赋值
        p.ID=[set objectForColumn:@"ID"];
        p.walletID=[set objectForColumn:@"walletID"];
        p.sideChainName =[set objectForColumn:@"sideChainName"];
        p.sideChainNameTime=[set objectForColumn:@"sideChainNameTime"];
        p.thePercentageCurr =[set objectForColumn:@"thePercentageCurr"];
        p.thePercentageMax=[set objectForColumn:@"thePercentageMax"];
        if (p.sideChainNameTime.length==0) {
            NSString *sideChainNameTime = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ INTEGER",@"sideChain",@"sideChainNameTime"];
            BOOL worked = [_manager executeUpdate:sideChainNameTime];
            if(worked){
                NSLog(@"sideChainNameTime插入成功");
            }else{
                NSLog(@"sideChainNameTime插入失败");
            }
            p.sideChainNameTime=@"--:--";
        }
        if (p.thePercentageMax.length==0) {
            NSString *thePercentageMax = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ INTEGER",@"sideChain",@"thePercentageMax"];
            BOOL Currworked = [_manager executeUpdate:thePercentageMax];
            if(Currworked){
                NSLog(@"thePercentageMax插入成功");
            }else{
                NSLog(@"thePercentageMax插入失败");
            }
            p.thePercentageMax=@"100";
            
        }
        if (p.thePercentageCurr.length==0) {
            NSString *thePercentageCurr = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ INTEGER",@"sideChain",@"thePercentageCurr"];
            BOOL Currworked = [_manager executeUpdate:thePercentageCurr];
            if(Currworked){
                NSLog(@"thePercentageCurr插入成功");
            }else{
                NSLog(@"thePercentageCurr插入失败");
            }
            p.thePercentageCurr=@"100";
            
        }
        [allRecords addObject:p]; NSLog(@"本地存储==%@===%@==%@==%@====%@",p.walletID,p.sideChainName,p.thePercentageCurr,p.thePercentageMax,p.sideChainNameTime);
        
        
    }
    if (allRecords.count!=1) {
        
        for (sideChainInfoModel *model in allRecords) {
            
            if ([model.sideChainName isEqualToString:iconName]) {
                
                [self delectSideChain:model.walletID withIconName:nil];
                return model;
            }
        }
        
    }else{
        return allRecords.firstObject;
    }
    
    
    
    return nil;
    //        添加到数组中
    //        [allRecords addObject:p];
    //    }
    
    //    return allRecords;
    
}
//查
-(NSArray*)allRecord{
    //数组 ， 这个数据用来存放查询结果转换的模型
    NSMutableArray *allRecords=[[NSMutableArray alloc]init];
    NSString *sql =@"select * from Person";
    FMResultSet *set=[self executeQuery:sql];
    //    一条一条的读取数据 并专程模型
    while (set.next) {
        //        模型
        friendsModel * p= [[friendsModel alloc]init];
        //        去出表中存放的内容给person赋值
        p.ID=[set objectForColumn:@"ID"];
        p.nameString =[set objectForColumn:@"nameString"];
        p.address=[set objectForColumn:@"address"];
        p.mobilePhoneNo=[set objectForColumn:@"mobilePhoneNo"];
        p.email=[set objectForColumn:@"email"];
        p.note=[set objectForColumn:@"note"];
        
        
        //        添加到数组中
        [allRecords addObject:p];
    }
    
    return allRecords;
}
-(BOOL)delectSideChain:(NSString*)ID withIconName:(NSString*)iconName{
    if (iconName.length>0) {
        NSString *sql =@"delete from sideChain where ID = ? and sideChainName=?";
        if ([self executeUpdate:sql,ID,iconName]) {
            
            
            
            return YES;
            
        }else{
            
            return NO;
        }
    }else{
        NSString *sql =@"delete from sideChain where ID = ?";
        if ([self executeUpdate:sql,ID]) {
            return YES;
        }else{
            return NO;
        }
        
    }
    
    
    
}
//删
-(BOOL)delectRecord:(friendsModel *)person{
    
    NSString *sql =@"delete from Person where ID = ?";
    if ([self executeUpdate:sql,person.ID]) {
        
        
        [[NSNotificationCenter defaultCenter]postNotificationName:myfriendNeedUpdate object:nil];
        return YES;
        
    }else{
        
        return NO;
    }
}
//改
-(BOOL)sideChainUpdate:(sideChainInfoModel *)model{
    //    return YES;
    sideChainInfoModel *hasModel=[self selectAddsideChainWithWalletID:model.walletID andWithIconName:model.sideChainName];
    if (hasModel) {
        if ([hasModel.sideChainNameTime isEqualToString:model.sideChainNameTime]) {
            return YES;
        }
        NSString *sql =@"Update sideChain set sideChainNameTime=? ,thePercentageCurr=?,thePercentageMax=? where walletID=? and sideChainName=? ";
        if ( [self executeUpdate:sql,model.sideChainNameTime,model.thePercentageCurr,model.thePercentageMax,model.walletID,model.sideChainName]) {
            NSLog(@"更新==%@===%@==%@==%@====%@",model.walletID,model.sideChainName,model.thePercentageCurr,model.thePercentageMax,model.sideChainNameTime);
            return YES;
        }else{
            NSLog(@"更新失败==%@===%@==%@==%@====%@",model.walletID,model.sideChainName,model.thePercentageCurr,model.thePercentageMax,model.sideChainNameTime);
            return NO;
        };
    }else{
        
        [self addsideChain:model];
    }
    return YES;
    
}
//改
-(BOOL)updateRecord:(friendsModel *)person{
    //nameString,address,mobilePhoneNo,email,note
    
    NSString *Nsql =@"Update Person set nameString=? where ID=? ";
    
    NSString *Asql =@"Update Person set address=? where ID=? ";
    NSString *msql =@"Update Person set mobilePhoneNo=? where ID=? ";
    NSString *esql =@"Update Person set email=? where ID=? ";
    NSString *notesql =@"Update Person set note=? where ID=? ";
    
    if ([self executeUpdate:Nsql,person.nameString,
         //         person.address,person.mobilePhoneNo,person.email,person.note,
         person.ID]&&[self executeUpdate:Asql,person.address,person.ID]&&[self executeUpdate:msql,person.mobilePhoneNo,person.ID]&&[self executeUpdate:msql,person.mobilePhoneNo,person.ID]&&[self executeUpdate:esql,person.email,person.ID]&&[self executeUpdate:notesql,person.note,person.ID]) {
        
        
        [[NSNotificationCenter defaultCenter]postNotificationName:myfriendNeedUpdate object:nil];
        return YES;
    }
    [[FLTools share]showErrorInfo:NSLocalizedString(@"修改失败！", nil)];
    return NO;
}
-(FMDBWalletModel*)selectMastWalletID:(NSString*)walletID{
    NSString *sql =[NSString stringWithFormat: @"select * from sideChain where walletID=\'%@\'",walletID];
    
    FMResultSet *set=[self executeQuery:sql];
    //    一条一条的读取数据 并专程模型
    while (set.next) {
        //        模型
        FMDBWalletModel * p= [[FMDBWalletModel alloc]init];
        //        去出表中存放的内容给person赋值
        p.walletID=[set objectForColumn:@"walletID"];
        p.walletAddress =[set objectForColumn:@"walletAddress"];
        p.walletName =[set objectForColumn:@"walletName"];
        return  p;
    }
    return nil;
    
};
-(void)addWallet:(FMDBWalletModel *)wallet{
    if ([self selectMastWalletID:wallet.walletID]) {
        return;
    }
    /*
     *
     */
    NSString *sql =@"insert into wallet(walletID,walletAddress,walletName) values(?,?,?)";
    if ([self executeUpdate:sql,wallet.walletID,wallet.walletAddress,wallet.walletName]) {
        
    }else{
        
        
    }
    
    
    
    
}
//查
-(NSArray*)allRecordWallet{
    //数组 ， 这个数据用来存放查询结果转换的模型
    NSMutableArray *allRecords=[[NSMutableArray alloc]init];
    NSString *sql =@"select * from wallet";
    FMResultSet *set=[self executeQuery:sql];
    //    一条一条的读取数据 并专程模型
    while (set.next) {
        //        模型
        FMDBWalletModel * p= [[FMDBWalletModel alloc]init];
        //        去出表中存放的内容给person赋值
        p.walletID=[set objectForColumn:@"walletID"];
        p.walletAddress =[set objectForColumn:@"walletAddress"];
        p.walletName =[set objectForColumn:@"walletName"];
        NSLog(@"本地存储钱包==%@==%@", p.walletID, p.walletName);
        //        添加到数组中
        [allRecords addObject:p];
    }
    
    return allRecords;
    
}


//改
-(BOOL)updateRecordWallet:(FMDBWalletModel *)wallet{
    if (wallet.walletAddress.length==0) {
        wallet.walletAddress=@"0";
    }
    NSString *sql =@"Update wallet set walletName=? where walletID=? ";
    
    if ( [self executeUpdate:sql,wallet.walletName,wallet.walletID]) {
        
        return YES;
        
    }else{
        return NO;
    }
}
//删
-(BOOL)delectRecordWallet:(FMDBWalletModel *)wallet{
    
    NSString *sql =@"delete from wallet where walletID = ?";
    if ([self executeUpdate:sql,wallet.walletID]) {
        NSLog(@"成功===删除钱包%@",wallet.walletID);
        [self delectSideChain:wallet.walletID withIconName:nil];
        return YES;
    }else{
        NSLog(@"失败===删除钱包%@",wallet.walletID);
        return NO;
    }
}
//查
-(NSArray*)allSelectCRWithWallID:(NSString*)walletID{
    
    NSMutableArray *allRecords=[[NSMutableArray alloc]init];
        NSString *sql =[NSString stringWithFormat: @"select * from RMList where walletID=\'%@\'" ,walletID];
      FMResultSet *set=[self executeQuery:sql,walletID];
      //    一条一条的读取数据 并专程模型
      while (set.next) {
          //        模型
          HWMCRListModel * p= [[HWMCRListModel alloc]init];
          //        去出表中存放的内容给person赋值
          p.location=[set objectForColumn:@"location"];
          p.index =[set objectForColumn:@"indexCR"];
          p.did =[set objectForColumn:@"did"];
          p.nickname =[set objectForColumn:@"nickname"];
          p.code =[set objectForColumn:@"code"];
          p.votes =[set objectForColumn:@"votes"];
          p.voterate =[set objectForColumn:@"voterateCR"];
          p.state =[set objectForColumn:@"state"];
          p.url =[set objectForColumn:@"url"];
          if ([p.state isEqualToString:@"Active"]) {
                [allRecords addObject:p];
          }

      }
      return allRecords;
}

//增加
-(BOOL)addCR:(HWMCRListModel*)CRModel withWallID:(NSString*)walletID{
  if (CRModel.index.length==0) {
    CRModel.index=@"0";
  }
  if (CRModel.location.length==0) {
      CRModel.location=@"86";
  }
  if (CRModel.nickname.length==0) {
      CRModel.nickname=@"0";
  }
  if (CRModel.code.length==0) {
      CRModel.code=@"0";
  }
  if (CRModel.votes.length==0) {
     CRModel.votes=@"0";
  }
  if (CRModel.voterate.length==0) {
      CRModel.voterate=@"0";
  }
  if (CRModel.state.length==0) {
      CRModel.state=@"0";
  }
  if (CRModel.url.length==0) {
      CRModel.url=@"0";
  }
    if ([self selectCRWithWalletID:walletID andWithDID:CRModel.did]) {
        if ([self updateSelectCR:CRModel WithWalletID:walletID]) {
            return YES;
        }
           return NO;
    }else{
    
    NSString *sql =@"insert into RMList(walletID,location,indexCR,did,nickname,code,votes,voterateCR,state,url) values(?,?,?,?,?,?,?,?,?,?)";
    if ([self executeUpdate:sql,walletID,CRModel.location,CRModel.index,CRModel.did,CRModel.nickname,CRModel.code,CRModel.votes,CRModel.voterate,CRModel.state,CRModel.url]) {
        return YES;
    }
        
    }
    return NO;
}
-(BOOL)selectCRWithWalletID:(NSString*)walletID andWithDID:(NSString*)DID{
    NSString *sql =[NSString stringWithFormat: @"select * from RMList where walletID=\'%@\' and did=\'%@\'",walletID,DID];
    
    
    NSString *thePercentageCurr = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ INTEGER",@"RMList",@"voterateCR"];
         BOOL Currworked = [_manager executeUpdate:thePercentageCurr];
         if(Currworked){
             NSLog(@"voterateCR插入成功");
         }else{
             NSLog(@"voterateCR插入失败");
         }
    
    FMResultSet *set=[self executeQuery:sql];
    
    
    
    //    一条一条的读取数据 并专程模型
    while (set.next) {
        //        模型
        HWMCRListModel * CR= [[HWMCRListModel alloc]init];
        //        去出表中存放的内容给person赋值
       CR.location=[set objectForColumn:@"location"];
       CR.index =[set objectForColumn:@"indexCR"];
       CR.did =[set objectForColumn:@"did"];
       CR.nickname =[set objectForColumn:@"nickname"];
       CR.code =[set objectForColumn:@"code"];
       CR.votes =[set objectForColumn:@"votes"];
       CR.voterate =[set objectForColumn:@"voterateCR"];
       CR.state =[set objectForColumn:@"state"];
       CR.url =[set objectForColumn:@"url"];
        return  YES;
    }
    return NO;
}
//改
-(BOOL)updateSelectCR:(HWMCRListModel *)crModel WithWalletID:(NSString*)walletID{
    if (crModel.index.length==0) {
        crModel.index=@"0";
    }
    if (crModel.location.length==0) {
        crModel.location=@"86";
    }
    if (crModel.nickname.length==0) {
        crModel.nickname=@"0";
    }
    if (crModel.code.length==0) {
        crModel.code=@"0";
    }
    if (crModel.votes.length==0) {
        crModel.votes=@"0";
    }
    if (crModel.voterate.length==0) {
        crModel.voterate=@"0";
    }
    if (crModel.state.length==0) {
        crModel.state=@"0";
    }
    if (crModel.url.length==0) {
        crModel.url=@"0";
    }
    if ([self selectCRWithWalletID:walletID andWithDID:crModel.did]) {
        NSString *sql =@"Update RMList set location=? ,indexCR=?,nickname=? ,code=? ,votes=? ,voterateCR=? ,state=? ,url=? where walletID=? and did=? ";
               if ( [self executeUpdate:sql,crModel.location,crModel.index,crModel.nickname,crModel.code,crModel.votes,crModel.voterate,crModel.state,crModel.url,walletID,crModel.did]) {
                   return YES;
                   
                   
                   
               }
    }

    
    return NO;
}
//删
-(BOOL)delectSelectCR:(HWMCRListModel *)crModel WithWalletID:(NSString*)walletID{
    NSString *sql =@"delete from RMList where walletID = ? and did=?";
    if ([self executeUpdate:sql,walletID,crModel.did]) {
        return YES;
    }else{
        return NO;
    }
}
@end
