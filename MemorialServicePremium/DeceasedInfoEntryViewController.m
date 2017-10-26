//
//  DeceasedInfoEntryActivity.m
//  MemorialService
//
//  Created by pc131101 on 2014/01/13.
//  Copyright (c) 2014年 DIGITALSPACE WOW. All rights reserved.
//

#import "DeceasedInfoEntryViewController.h"
#import "Common.h"
#import "Define.h"
#import "Deceased.h"
#import "DeceasedDao.h"
#import "InputValidataion.h"
#import "Toast+UIView.h"
#import "PointUser.h"

@interface DeceasedInfoEntryViewController () {
    UIImage *_photoImage;
    UITextField *_textField;
}

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@property (weak, nonatomic) IBOutlet UIScrollView *deceasedScroll;
@property (weak, nonatomic) IBOutlet UIView *deceasedScrollView;

@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UILabel *photoSelectLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *birthdayPicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *deathdayPicker;
@property (weak, nonatomic) IBOutlet UISegmentedControl *deathAgeSeg;
@property (weak, nonatomic) IBOutlet UITextField *deathAgeText;

@end

@implementation DeceasedInfoEntryViewController

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
    
    [self.nameText setDelegate:self];
    [self.deathAgeText setDelegate:self];
    
    //背景をクリックしたらキーボードを隠す
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeSoftKeyboard)];
    [self.deceasedScrollView addGestureRecognizer:gestureRecognizer];
    
    //ツールバーの背景色と文字色を設定
    self.toolBar.barTintColor = [UIColor colorWithRed:TOOLBAR_BG_COLOR_RED green:TOOLBAR_BG_COLOR_GREEN blue:TOOLBAR_BG_COLOR_BLUE alpha:1.0];
    self.toolBar.tintColor = [UIColor colorWithRed:TEXT_COLOR_RED green:TEXT_COLOR_GREEN blue:TEXT_COLOR_BLUE alpha:1.0];
    
    //生年月日の年を70年前に設定する
    NSDate *past60yearsAgo = [Common getPastDateYear:-70];
    [self.birthdayPicker setDate:past60yearsAgo animated:NO];
    
    //命日の年を10年前に設定する
    NSDate *past10yearsAgo = [Common getPastDateYear:-10];
    [self.deathdayPicker setDate:past10yearsAgo animated:NO];
    
    //年齢を計算して設定
    int age = [Common calcAge:self.birthdayPicker.date deathday:self.deathdayPicker.date];
    
    self.deathAgeText.text = [NSString stringWithFormat:@"%d", age];
    
    //年齢のキーボードタイプを指定
    self.deathAgeText.keyboardType = UIKeyboardTypeNumberPad;

    //UIScrollViewのコンテンツサイズを設定
    self.deceasedScroll.contentSize = self.deceasedScrollView.bounds.size;
    //スクロールバーを表示
    self.deceasedScroll.showsVerticalScrollIndicator = YES;
    
    //キーボード閉じるボタン用ツールバーを生成
    UIToolbar *closeBar = [[UIToolbar alloc] init];
    //スタイルの設定
    closeBar.barStyle = UIBarStyleDefault;
    //ツールバーを画面サイズに合わせる
    [closeBar sizeToFit];
    //「完了」ボタンを右端に配置したいためフレキシブルなスペースを作成する。
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    //完了ボタンの生成
    UIBarButtonItem *_commitBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(closeSoftKeyboard)];
    //ボタンをToolbarに設定
    NSArray *toolBarItems = [NSArray arrayWithObjects:spacer, _commitBtn, nil];
    //表示・非表示の設定
    [closeBar setItems:toolBarItems animated:YES];
    //ToolbarをTextViewのinputAccessoryViewに設定
    self.nameText.inputAccessoryView = closeBar;
    self.deathAgeText.inputAccessoryView = closeBar;
    
    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
    // キーボード表示時
    [notification addObserver:self selector:@selector(keyboardWillShow:)
						 name: UIKeyboardWillShowNotification object:nil];
    // キーボード非表示時
	[notification addObserver:self selector:@selector(keyboardWillHide:)
						 name: UIKeyboardWillHideNotification object:nil];
}

//戻るボタンクリック時
- (IBAction)returnButtonPushed:(id)sender {
    //上の階層に戻る
    [self.navigationController popViewControllerAnimated:YES];
}

//登録ボタンクリック時
- (IBAction)entryButtonPushed:(id)sender {
    //　入力チェック
    NSString *errorMessage = [InputValidataion checkDeceasedEntry:self.nameText.text withAge:self.deathAgeText.text withBirthday:self.birthdayPicker.date withDeathday:self.deathdayPicker.date];
    if ([errorMessage length] > 0) {
        //エラーメッセージをダイアログ表示
        [self.view makeToast:errorMessage duration:TOAST_DURATION_ERROR position:@"center"];
    } else {
        //画面上の入力値を取得
        Deceased *deceased  = [[Deceased alloc] init];
        deceased.qr_flg = QR_FLG_NO;
        //故人名は半角を全角に変換して保存
        NSString *name = self.nameText.text;
        NSMutableString *convertedName = [name mutableCopy];
        CFStringTransform((CFMutableStringRef)convertedName, NULL, kCFStringTransformFullwidthHalfwidth, true);
        deceased.deceased_name = convertedName;
         deceased.deceased_birthday = [Common getDateString:@"yyyyMMdd" convDate:self.birthdayPicker.date];
        deceased.deceased_deathday = [Common getDateString:@"yyyyMMdd" convDate:self.deathdayPicker.date];
        //享年行年は、選択されたセグメントにより保存内容を分岐
        switch (self.deathAgeSeg.selectedSegmentIndex) {
            case 0: //享年
                deceased.kyonen_gyonen_flg = KG_FLG_KYONEN;
                break;
            case 1: //行年
                deceased.kyonen_gyonen_flg = KG_FLG_GYONEN;
                break;
            case 2: //満
                deceased.kyonen_gyonen_flg = KG_FLG_MAN;
                break;
            case 3: //なし
                deceased.kyonen_gyonen_flg = KG_FLG_NOTHING;
                break;
            default:
                break;
        }
        deceased.death_age = [self.deathAgeText.text intValue];
        
        //現在日時を文字列で取得
        NSString *now = [Common getDateString:@"yyyyMMddHHmmss"];
        deceased.entry_datetime = now;
        deceased.timestamp = now;
        
        //DBに接続
        DatabaseHelper *databaseHelper = [[DatabaseHelper alloc]init];
        FMDatabase *memorialDatabase = databaseHelper.memorialDatabase;
        DeceasedDao *deceasedDao = [DeceasedDao deceasedDaoWithMemorialDatabase:memorialDatabase];
        
        //次に割り当てられるdeceased_no(AUTO INCREMENT)の値を取得
        NSString *deceasedId = [deceasedDao getNextDeceasedId];
        //IDとして設定
        deceased.deceased_id = deceasedId;
        
        //画像を選択している場合、画像をドキュメントフォルダに保存し、ファイル名をDeceasedに設定する
        if (_photoImage != nil) {
            //ファイル名生成
            NSString *saveFileName = [NSString stringWithFormat:@"%@.jpg",deceasedId];
            //保存先パス生成
            NSString *dataPath = [NSString stringWithFormat:@"%@/%@",DOCUMENTS_FOLDER, saveFileName];
            
            //サイズを調整する
            CGFloat newSize = IMAGE_REDUCTION_SIZE;
            UIImage *resizeImage = [Common resizeImage:_photoImage toSize:newSize];
            
            //保存する
            NSData *data = UIImageJPEGRepresentation(resizeImage, 0.8);
            if ([data writeToFile:dataPath atomically:YES]) {
//                NSLog(@"hozon:OK");
            } else {
//                NSLog(@"hozon:NG");
                //DBを閉じる
                [memorialDatabase close];
                //エラーメッセージをダイアログ表示
                [self.view makeToast:@"登録に失敗しました。\nもう一度登録して下さい。" duration:TOAST_DURATION_ERROR position:@"center"];
                return;
            }
            
            //ファイル名設定
            deceased.deceased_photo_path = saveFileName;
        } else {
            //ファイル名設定
            deceased.deceased_photo_path = @"";
        }
        
        //DBに登録
        if([deceasedDao insertDeceased:deceased]) {
            
            //DBを閉じる
            [memorialDatabase close];

        
            //起動時ポイント自動付与
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];  // 取得
            NSString *userid = [defaults stringForKey:USER_ID];  // USER_IDの内容をNSString型として取得
            
            if ([userid length]) {
                // URL指定、パラメーターを付与
                NSString *urlAsString = POINT_ADD_USER2;
                urlAsString = [urlAsString stringByAppendingString:@"?userId="];
                urlAsString = [urlAsString stringByAppendingString:userid];
                NSURL *url = [NSURL URLWithString:urlAsString];
                
                // GETメソッドのHTTPリクエストを生成
                NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
                [urlRequest setTimeoutInterval:30.0f];
                [urlRequest setHTTPMethod:@"GET"];
                
                // NSOperationQueueオブジェクトを生成
                NSOperationQueue *queue = [NSOperationQueue mainQueue];
                
                //　非同期通信
                // リクエスト実行
                [NSURLConnection
                 sendAsynchronousRequest:urlRequest
                 queue:queue
                 completionHandler:^(NSURLResponse *response,
                                     NSData *data,
                                     NSError *error) {
                     
                     
                 }];
            }
            
            
            

            
            //登録完了をトースト表示
            [self.view makeToast:@"登録が完了しました。" duration:TOAST_DURATION_NOTICE position:@"center"];
            
            //1.5秒後、上の階層に戻る
            [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(popView) userInfo:nil repeats:NO];
        } else {
            //DBを閉じる
            [memorialDatabase close];
            
            //エラーメッセージをダイアログ表示
            [self.view makeToast:@"登録に失敗しました。\nもう一度登録して下さい。" duration:TOAST_DURATION_ERROR position:@"center"];
        }
    }
}

//上の階層に戻る
- (void)popView
{
    [self.navigationController popViewControllerAnimated:YES];
}

//写真選択時、イメージピッカーを表示する
- (IBAction)photoSelectButtonPushed:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = YES;
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
}

//イメージピッカーのイメージ取得時に呼ばれる
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //イメージを取得する
    _photoImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    //ラベルに選択済を設定
    self.photoSelectLabel.text = @"選択済";
    //イメージピッカーを閉じる
    [[picker presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

//イメージピッカーのキャンセル時に呼ばれる
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    //イメージピッカーを閉じる
    [[picker presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

//誕生日ピッカー変更時に呼ばれる
- (IBAction)birthdayPickerChanged:(id)sender {
    //年齢を計算して設定
    int age = [Common calcAge:self.birthdayPicker.date deathday:self.deathdayPicker.date];
    self.deathAgeText.text = [NSString stringWithFormat:@"%d", age];
}

//命日ピッカー変更時に呼ばれる
- (IBAction)deathdayPickerChanged:(id)sender {
    //年齢を計算して設定
    int age = [Common calcAge:self.birthdayPicker.date deathday:self.deathdayPicker.date];
    self.deathAgeText.text = [NSString stringWithFormat:@"%d", age];
}

//編集中のTextFieldを保持
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _textField = textField;
    return YES;
}

//キーボード表示時
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    if([_textField isFirstResponder])
    {
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, CGRectGetHeight(keyboardRect), 0.0);
        self.deceasedScroll.contentInset = contentInsets;
        self.deceasedScroll.scrollIndicatorInsets = contentInsets;

        CGPoint pt = [self.deceasedScroll convertPoint:_textField.frame.origin toView:self.view];
        
        if(CGRectGetMinY(keyboardRect) < pt.y)
        {
            CGPoint scrollPoint = CGPointMake(0.0, pt.y - CGRectGetMinY(keyboardRect) + _textField.frame.size.height);
            [self.deceasedScroll setContentOffset:scrollPoint animated:YES];
        }
    }
}

//キーボード非表示時
- (void)keyboardWillHide:(NSNotification *)notification
{
    if([_textField isFirstResponder])
    {
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
        self.deceasedScroll.contentInset = contentInsets;
        self.deceasedScroll.scrollIndicatorInsets = contentInsets;
    }
}

//テキストフィールドでエンターキーがクリックされた場合にキーボードを隠す
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

// キーボードを隠す処理
- (void)closeSoftKeyboard {
    [self.view endEditing: YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
