//
//  TestViewController.swift
//  MemorialServicePremium
//
//  Created by yamatohideyoshi on 2017/10/26.
//  Copyright © 2017年 DIGITALSPACE WOW. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    @IBOutlet weak var toolBar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.frame = CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.size.width), height: Int(UIScreen.main.bounds.size.height))
        //ツールバーの背景色と文字色を設定
        self.toolBar.barTintColor = UIColor(red: CGFloat(TOOLBAR_BG_COLOR_RED) , green: CGFloat(TOOLBAR_BG_COLOR_GREEN), blue: CGFloat(TOOLBAR_BG_COLOR_BLUE), alpha: 1.0)
        
        self.toolBar.tintColor = UIColor(red: CGFloat(0), green: CGFloat(0), blue: CGFloat(0), alpha: 1.0)
    
        //インターネットに接続できるかチェック、接続できない場合、エラーメッセージを出す
        let curReach = Reachability.forInternetConnection()
        let netStatus: NetworkStatus = (curReach?.currentReachabilityStatus())!

        if netStatus == NotReachable {
            //インジケーターを閉じる
            IndicatorWindow.close()
            //接続できない場合、エラーメッセージをダイアログ表示
            self.view.makeToast("ネットワークに接続できる環境でダウンロードして下さい。", duration: 1.0, position: "center")
        }
    }

    @IBAction func ruturn_Click(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}