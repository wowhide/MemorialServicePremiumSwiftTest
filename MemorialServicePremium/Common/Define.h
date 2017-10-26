//
//  Define.h
//  MemorialService
//
//  Created by pc131101 on 2014/01/11.
//  Copyright (c) 2014年 DIGITALSPACE WOW. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]



#define TOAST_DURATION_NOTICE 1.5
#define TOAST_DURATION_ERROR 2.0

#define CAMERA_RESTART_DURATION 0.4

#define QR_READ_VIEW_FROM_INITIAL_SETTING 1
#define QR_READ_VIEW_FROM_DECEASED_LIST 2

#define QR_FLG_YES 1
#define QR_FLG_NO -1

#define NOTICE_YES 1
#define NOTICE_NO -1

#define NOTICE_TIMING_ACTIVE 1
#define NOTICE_TIMING_PASSIVE 2

#define KG_FLG_NOTHING 0
#define KG_FLG_KYONEN 1
#define KG_FLG_GYONEN 2
#define KG_FLG_MAN 3

#define IMAGE_REDUCTION_SIZE 800

//通知種別
#define NOTICE_MONTH_DEATHDAY_BEFORE 1
#define NOTICE_MONTH_DEATHDAY 2
#define NOTICE_DEATHDAY_1WEEK_BEFORE 3
#define NOTICE_DEATHDAY_BEFORE 4
#define NOTICE_DEATHDAY 5
#define NOTICE_MEMORIAL_3MONTH_BEFORE 6
#define NOTICE_MEMORIAL_1MONTH_BEFORE 7
#define NOTICE_MEMORIAL_1WEEK_BEFORE 8

//通知フラグ
#define NOTICE_FLG_MEMORIAL 1
#define NOTICE_FLG_NOTICE 2
#define NOTICE_FLG_NO -1

//葬儀社情報
#define MORTICIAN_NO 3

//通知情報登録方法
#define ENTRY_METHOD_INPUT 1
#define ENTRY_METHOD_URL 2

//画面部品の色
extern const float TITLE_BG_COLOR_RED;
extern const float TITLE_BG_COLOR_GREEN;
extern const float TITLE_BG_COLOR_BLUE;

extern const float TOOLBAR_BG_COLOR_RED;
extern const float TOOLBAR_BG_COLOR_GREEN;
extern const float TOOLBAR_BG_COLOR_BLUE;

extern const float MENU_BG_COLOR_RED;
extern const float MENU_BG_COLOR_GREEN;
extern const float MENU_BG_COLOR_BLUE;

extern const float TEXTVIEW_BG_COLOR_RED;
extern const float TEXTVIEW_BG_COLOR_GREEN;
extern const float TEXTVIEW_BG_COLOR_BLUE;

extern const float TEXT_COLOR_RED;
extern const float TEXT_COLOR_GREEN;
extern const float TEXT_COLOR_BLUE;

@interface Define : NSObject

//KEY
extern NSString * const KEY_DEVICE_TOKEN;

//Localizeファイル名
extern NSString * const LOCALIZE_FILE;

//Notification名
extern NSString * const NOTICE_BARCODE_DOWNLOADED;

//EC機能フラグ
extern const bool IS_EC_ACTIVE;

//ポイント機能フラグ
extern const bool IS_POINT_ACTIVE;

//葬儀社情報
extern NSString * const MORTICIAN_NAME;
extern NSString * const MORTICIAN_POST;
extern NSString * const MORTICIAN_ADDRESS;
extern NSString * const MORTICIAN_TEL;
extern NSString * const MORTICIAN_POST2;
extern NSString * const MORTICIAN_ADDRESS2;
extern NSString * const MORTICIAN_TEL2;
extern NSString * const MORTICIAN_URL;

//法要アプリWeb-API URL
extern NSString * const SAVE_DEVICE_TOKEN;
extern NSString * const SAVE_DEVICE_TOKEN_AND_DECEASED_ID;
extern NSString * const GET_NOTICE_INFO;
extern NSString * const GET_NOTICE_INFO_TOKEN;
extern NSString * const VIEW_NOTICE_INFO;
extern NSString * const READ_TRANSFER_DATA;
extern NSString * const DOWNLOAD_PHOTO;
extern NSString * const SEND_DATA_KEY_MAIL;
extern NSString * const GET_NOTICE_INFO_DELIVERED;
extern NSString * const GET_NOTICE_INFO_DELIVERED_TOKEN;
extern NSString * const SEND_MEMORIAL_MAIL;
extern NSString * const SAVE_TRANSFER_DATA;
extern NSString * const UP_PHOTO;
extern NSString * const SYUKATSU;
extern NSString * const READ_DECEASED_DATA;

//ポイント機能Web-API URL
extern NSString * const POINT_ADD_USER;
extern NSString * const POINT_ADD_USER1;
extern NSString * const POINT_ADD_USER2;
extern NSString * const POINT_UPDATE_USER;
extern NSString * const POINT_GET_USER;
extern NSString * const SEARCH_ADDRESS;
extern NSString * const GET_BARCODE;

@end
