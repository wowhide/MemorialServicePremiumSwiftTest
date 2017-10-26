//
//  OtherFuneralViewController.m
//  MemorialService
//
//  Created by pc131101 on 2014/01/21.
//  Copyright (c) 2014年 DIGITALSPACE WOW. All rights reserved.
//

#import "OtherFuneralViewController.h"
#import "Define.h"

@interface OtherFuneralViewController ()

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@property (weak, nonatomic) IBOutlet UIScrollView *funeralScroll;
@property (weak, nonatomic) IBOutlet UIView *funeralScrollView;

@property (weak, nonatomic) IBOutlet UILabel *morticianNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *morticianPostLabel;
@property (weak, nonatomic) IBOutlet UILabel *morticianAddressLabel;
@property (weak, nonatomic) IBOutlet UIButton *morticianTelButton;

@property (weak, nonatomic) IBOutlet UILabel *morticianPostLabel2;
@property (weak, nonatomic) IBOutlet UILabel *morticianAddressLabel2;
@property (weak, nonatomic) IBOutlet UIButton *morticianTelButton2;

@property (weak, nonatomic) IBOutlet UIButton *morticianUrlButton;

@end

@implementation OtherFuneralViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //解像度に合わせてViewサイズを変更
    [self.view setFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)];
    
    //ツールバーの背景色と文字色を設定
    self.toolBar.barTintColor = [UIColor colorWithRed:TOOLBAR_BG_COLOR_RED green:TOOLBAR_BG_COLOR_GREEN blue:TOOLBAR_BG_COLOR_BLUE alpha:1.0];
    self.toolBar.tintColor = [UIColor colorWithRed:TEXT_COLOR_RED green:TEXT_COLOR_GREEN blue:TEXT_COLOR_BLUE alpha:1.0];
    
    //UIScrollViewのコンテンツサイズを設定
    self.funeralScroll.contentSize = self.funeralScrollView.bounds.size;
    //スクロールバーを表示
    self.funeralScroll.showsVerticalScrollIndicator = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //ラベルに葬儀社情報とプロパティを設定する
    //葬儀社名
    self.morticianNameLabel.text = MORTICIAN_NAME;
    
    //郵便番号
    self.morticianPostLabel.text = MORTICIAN_POST;
    //住所
    self.morticianAddressLabel.text = MORTICIAN_ADDRESS;
    [self.morticianAddressLabel setNumberOfLines:0];
    [self.morticianAddressLabel sizeToFit];
    //電話番号
    [self.morticianTelButton setTitle:MORTICIAN_TEL forState:UIControlStateNormal];
    
    //郵便番号2
    self.morticianPostLabel2.text = MORTICIAN_POST2;
    //住所2
    self.morticianAddressLabel2.text = MORTICIAN_ADDRESS2;
    [self.morticianAddressLabel2 setNumberOfLines:0];
    [self.morticianAddressLabel2 sizeToFit];
    //電話番号2
    [self.morticianTelButton2 setTitle:MORTICIAN_TEL2 forState:UIControlStateNormal];
    
    //URL
    [self.morticianUrlButton setTitle:MORTICIAN_URL forState:UIControlStateNormal];
}

//戻るボタンクリック時
- (IBAction)returnButtonPushed:(id)sender {
    //上の階層に戻る
    [self.navigationController popViewControllerAnimated:YES];
}

//電話番号クリック時
- (IBAction)telButtonPushed:(id)sender {
    //電話番号をタッチした場合
    NSString *tel = [self.morticianTelButton.titleLabel.text stringByReplacingOccurrencesOfString: @"-" withString: @""];
    NSString *telUrl= [NSString stringWithFormat:@"tel:%@", tel];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telUrl]];
}

//電話番号2クリック時
- (IBAction)telButton2Pushed:(id)sender {
    //電話番号2をタッチした場合
    NSString *tel = [self.morticianTelButton2.titleLabel.text stringByReplacingOccurrencesOfString: @"-" withString: @""];
    NSString *telUrl= [NSString stringWithFormat:@"tel:%@", tel];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telUrl]];
}

//URLクリック時
- (IBAction)urlButtonPushed:(id)sender {
    //URLをタッチした場合
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.morticianUrlButton.titleLabel.text]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
