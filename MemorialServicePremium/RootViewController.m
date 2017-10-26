//
//  RootViewController.m
//  MemorialService
//
//  Created by pc131101 on 2014/01/08.
//  Copyright (c) 2014年 DIGITALSPACE WOW. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "StartViewController.h"
#import "NoticeMonthDeathdayViewController.h"
#import "NoticeDeathdayViewController.h"
#import "NoticeMemorialdayViewController.h"
#import "NoticeInfoViewController.h"

#import "DatabaseHelper.h"
#import "MorticianDao.h"
#import "Mortician.h"
#import "UserDao.h"
#import "User.h"
#import "DeceasedDao.h"
#import "Deceased.h"
#import "MailInputViewController.h"
#import "MenuTabBarViewController.h"
#import "Define.h"
#import "Common.h"
#import "MemorialReceiveDao.h"
#import "OtherDataTransferViewController.h"

@interface RootViewController () {
    FMDatabase *_memorialDatabase;
}

@end

//RootViewControllerの実装
@implementation RootViewController

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
    StartViewController *startViewController = [[StartViewController alloc] init];
    startViewController.delegate = self;
    [self displayContentController:startViewController];
}

- (void)displayContentController: (UIViewController *) content
{
    [self addChildViewController:content];
    [self.view addSubview:content.view];
    [content didMoveToParentViewController:self];
}

- (void)hideContnentController: (UIViewController *) content
{
    [content willMoveToParentViewController:nil];
    [content.view removeFromSuperview];
    [content removeFromParentViewController];
}

//スタート画面が閉じた後に呼ばれるデリゲート
- (void)hideStartView:(StartViewController*)startViewController
{
//    NSLog(@"RootViewController hideStartView");
    //スタート画面を閉じる
    [self hideContnentController:startViewController];
    //次画面を表示する
    [self dispNextView];
}

//お名前・メールアドレス登録画面が閉じた後に呼ばれるデリゲート
- (void)hideMailInputView:(MailInputViewController*)mailInputViewController
{
//    NSLog(@"RootViewController hideMailInputView");
    //お名前・メールアドレス登録画面を閉じる
    [self hideContnentController:mailInputViewController];
    //次画面を表示する
    [self dispNextView];
}

//月命日通知画面が閉じた後に呼ばれるデリゲート
- (void)hideNoticeMonthDeathdayView:(UIViewController *)noticeMonthDeathdayViewController
{
//    NSLog(@"RootViewController hideNoticeMonthDeathdayView");
    //通知フラグにNOを設定する
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.notice_flg = NO;
    //月命日通知画面を閉じる
    [self hideContnentController:noticeMonthDeathdayViewController];
    //次画面を表示する
    [self dispNextView];
}

//命日通知画面が閉じた後に呼ばれるデリゲート
- (void)hideNoticeDeathdayView:(UIViewController *)noticeDeathdayViewController
{
//    NSLog(@"RootViewController hideNoticeDeathdayView");
    //通知フラグにNOを設定する
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.notice_flg = NO;
    //命日通知画面を閉じる
    [self hideContnentController:noticeDeathdayViewController];
    //次画面を表示する
    [self dispNextView];
}

//法要通知画面が閉じた後に呼ばれるデリゲート
- (void)hideNoticeMemorialdayView:(UIViewController *)noticeMemorialdayViewController
{
//    NSLog(@"RootViewController hideNoticeMemorialdayView");
    //通知フラグにNOを設定する
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.notice_flg = NO;
    //命日通知画面を閉じる
    [self hideContnentController:noticeMemorialdayViewController];
    //次画面を表示する
    [self dispNextView];
}

//データベースの登録状態により表示画面の処理を分岐する
- (void)dispNextView
{
    //DBを開く
    DatabaseHelper *databaseHelper = [[DatabaseHelper alloc]init];
    _memorialDatabase = databaseHelper.memorialDatabase;
    
    //利用者情報を取得
    UserDao *userDao = [UserDao userDaoWithMemorialDatabase:_memorialDatabase];
    User *user = [userDao selectUser];
    
    //DBを閉じる
    [_memorialDatabase close];
    
    if (user != nil) {
        //故人様一覧画面を表示
        MenuTabBarViewController *menuTabBarViewController = [[MenuTabBarViewController alloc] init];
        [self displayContentController:menuTabBarViewController];
        //データ引き継ぎ画面のインスタンスを生成
//        OtherDataTransferViewController *otherDataTransferViewController = [OtherDataTransferViewController new];
//        //データ引き継ぎ画面に遷移
//               [self displayContentController:otherDataTransferViewController];
        
    } else {
        //利用者情報の登録が済んでいない場合、登録画面を表示
        MailInputViewController *mailInputViewController = [[MailInputViewController alloc] init];
        mailInputViewController.delegate = self;
        [self displayContentController:mailInputViewController];
    }

    //通知から起動している場合、通知画面を表示する
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (appDelegate.notice_flg == NOTICE_FLG_MEMORIAL) {
        //法要通知を表示
        //法要通知テーブルから通知済みのレコードを取得して表示
        NSArray* notifications = [self selectMemorialReceive];
        for (Notification* notification in notifications) {
            [self dispMemorial:notification];
        }
        //ローカル通知を一度すべて削除する
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        //法要通知テーブル全レコードを削除する
        [self deleteMemorialReceiveAll];
    } else if (appDelegate.notice_flg == NOTICE_FLG_NOTICE) {
        //通知済みの法要がある場合、表示する
        //法要通知テーブルから通知済みのレコードを取得して表示
        NSArray* notifications = [self selectMemorialReceive];
        for (Notification* notification in notifications) {
            [self dispMemorial:notification];
        }
        //ローカル通知を一度すべて削除する
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        //法要通知テーブル全レコードを削除する
        [self deleteMemorialReceiveAll];

        //お知らせ画面を開く
        //通知Noを元に通知情報を取得してURLを生成する
        //サーバーからお知らせ情報を取得
        NSString *noticeInfo_urlAsString = GET_NOTICE_INFO_TOKEN;
        NSURL *noticeInfo_url = [NSURL URLWithString:noticeInfo_urlAsString];
        //デバイストークンを取得
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *deviceToken = [userDefaults stringForKey:KEY_DEVICE_TOKEN];
        
        //POSTメソッドのHTTPリクエストを生成する
        NSMutableURLRequest *noticeInfo_urlRequest = [NSMutableURLRequest requestWithURL:noticeInfo_url];
        [noticeInfo_urlRequest setHTTPMethod:@"POST"];
        
        //パラメータを付与
        NSString *noticeInfo_body = [NSString stringWithFormat:@"noticeSchedule=%@&deviceToken=%@",appDelegate.notice_schedule, deviceToken];
        [noticeInfo_urlRequest setHTTPBody:[noticeInfo_body dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSHTTPURLResponse *noticeInfo_response;
        NSError *noticeInfo_error = nil;
        
        //HTTP同期通信を実行
        NSData *noticeInfoJsonData = [NSURLConnection sendSynchronousRequest:noticeInfo_urlRequest returningResponse:&noticeInfo_response error:&noticeInfo_error];

        //データを取得してURLを生成
        NSString *noticeInfoUrl;

        if (noticeInfoJsonData && noticeInfo_response.statusCode == 200) {
            //データが存在する場合表示する
            if ((noticeInfoJsonData.length > 0) == YES ) {
                //JSONのデータを読み込む
                NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:noticeInfoJsonData options:NSJSONReadingAllowFragments error:&noticeInfo_error];
                NSDictionary *jsonNoticeInfoObject = [jsonObject objectForKey:@"noticeInfo"];
                
                //取得したお知らせ情報をからURLを生成し、お知らせ画面に設定
                for (NSDictionary *dObj in jsonNoticeInfoObject) {
                    int noticeInfoNo = [[dObj objectForKey:@"notice_info_no"] intValue];
                    int entryMethod = [[dObj objectForKey:@"entry_method"] intValue];
                    NSString *url = [dObj objectForKey:@"url"];
                    NSString *deceasedID = [dObj objectForKey:@"deceased_id"];
                    
                    if (entryMethod == ENTRY_METHOD_INPUT) {
                        noticeInfoUrl = [VIEW_NOTICE_INFO stringByAppendingFormat:@"?nino=%d&deceased_id=%@", noticeInfoNo, deceasedID];
                    } else if (entryMethod == ENTRY_METHOD_URL) {
                        noticeInfoUrl = url;
                    }
                    
                    //お知らせ画面を表示する
                    NoticeInfoViewController *noticeInfoViewController = [[NoticeInfoViewController alloc] init];
                    noticeInfoViewController.url = noticeInfoUrl;
                    noticeInfoViewController.noticeTiming = NOTICE_TIMING_PASSIVE;
                    [self addChildViewController:noticeInfoViewController];
                    [self.view addSubview:noticeInfoViewController.view];
                    [noticeInfoViewController didMoveToParentViewController:self];
                }
            }
        }
    }
    //通知フラグにNOを設定する
    appDelegate.notice_flg = NO;
}

- (void)dispMemorial:(Notification *)notification
{
    if (notification.notice_kind == NOTICE_MONTH_DEATHDAY_BEFORE ||
        notification.notice_kind == NOTICE_MONTH_DEATHDAY) {

        //月命日通知画面を開く
        NoticeMonthDeathdayViewController *noticeMonthDeathdayViewController = [[NoticeMonthDeathdayViewController alloc] init];
        noticeMonthDeathdayViewController.notification = notification;
        noticeMonthDeathdayViewController.noticeTiming = NOTICE_TIMING_PASSIVE;
        [self addChildViewController:noticeMonthDeathdayViewController];
        [self.view addSubview:noticeMonthDeathdayViewController.view];
        [noticeMonthDeathdayViewController didMoveToParentViewController:self];

    } else if (notification.notice_kind == NOTICE_DEATHDAY_1WEEK_BEFORE ||
               notification.notice_kind == NOTICE_DEATHDAY_BEFORE ||
               notification.notice_kind == NOTICE_DEATHDAY) {

        //命日通知画面を開く
        NoticeDeathdayViewController *noticeDeathdayViewController = [[NoticeDeathdayViewController alloc] init];
        noticeDeathdayViewController.notification = notification;
        noticeDeathdayViewController.noticeTiming = NOTICE_TIMING_PASSIVE;
        [self addChildViewController:noticeDeathdayViewController];
        [self.view addSubview:noticeDeathdayViewController.view];
        [noticeDeathdayViewController didMoveToParentViewController:self];
   
    } else if (notification.notice_kind == NOTICE_MEMORIAL_3MONTH_BEFORE ||
               notification.notice_kind == NOTICE_MEMORIAL_1MONTH_BEFORE ||
               notification.notice_kind == NOTICE_MEMORIAL_1WEEK_BEFORE) {

        //法要通知画面を開く
        NoticeMemorialdayViewController *noticeMemorialdayViewController = [[NoticeMemorialdayViewController alloc] init];
        noticeMemorialdayViewController.notification = notification;
        noticeMemorialdayViewController.noticeTiming = NOTICE_TIMING_PASSIVE;
        [self addChildViewController:noticeMemorialdayViewController];
        [self.view addSubview:noticeMemorialdayViewController.view];
        [noticeMemorialdayViewController didMoveToParentViewController:self];

    }
}

- (NSArray *)selectMemorialReceive
{
	//DBに接続する
    DatabaseHelper *databaseHelper = [[DatabaseHelper alloc]init];
    FMDatabase *memorialDatabase = databaseHelper.memorialDatabase;
    //トランザクションを開始する
    [memorialDatabase beginTransaction];
    
    //法要通知テーブルのレコードを全件削除
    MemorialReceiveDao *memorialReceiveDao = [MemorialReceiveDao memorialReceiveDaoWithMemorialDatabase:memorialDatabase];
    
    NSArray *notifications = [memorialReceiveDao selectMemorialReceive];
    
    //DBをコミット
    [memorialDatabase commit];
    //DBを閉じる
    [memorialDatabase close];
    
    return notifications;
}

- (void)deleteMemorialReceiveAll
{
	//DBに接続する
    DatabaseHelper *databaseHelper = [[DatabaseHelper alloc]init];
    FMDatabase *memorialDatabase = databaseHelper.memorialDatabase;
    //トランザクションを開始する
    [memorialDatabase beginTransaction];
    
    //法要通知テーブルのレコードを全件削除
    MemorialReceiveDao *memorialReceiveDao = [MemorialReceiveDao memorialReceiveDaoWithMemorialDatabase:memorialDatabase];
    if (![memorialReceiveDao deleteMemorialReceiveAll]) {
        //DBをロールバック
        [memorialDatabase rollback];
        //DBを閉じる
        [memorialDatabase close];
    }
    
    //DBをコミット
    [memorialDatabase commit];
    //DBを閉じる
    [memorialDatabase close];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
