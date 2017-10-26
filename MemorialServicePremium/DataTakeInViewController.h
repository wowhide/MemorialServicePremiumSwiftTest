//
//  DataTakeInViewController.h
//  MemorialService
//
//  Created by pc131101 on 2014/01/28.
//  Copyright (c) 2014年 DIGITALSPACE WOW. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataTakeInViewController;

@protocol DataTakeInViewDelegate <NSObject>
-(void) hideDataTakeInView:(BOOL)readBool;
@end

@interface DataTakeInViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) id <DataTakeInViewDelegate> delegate;
@end
