//
//  SettingViewController.swift
//  SlideStream
//
//  Created by himara2 on 2015/09/21.
//  Copyright © 2015年 Ryosuke Hiramatsu. All rights reserved.
//

import UIKit
import Social
import HandShake

class SettingViewController: UITableViewController {

    private let service = SlideService()
    private let kAppStoreUrl = "http://yahoo.co.jp"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    private func setUpThreeFingerTouch() {
        let tapGesture = UITapGestureRecognizer(target: self, action: "touchThreeFinger")
        tapGesture.numberOfTapsRequired = 2
        view.addGestureRecognizer(tapGesture)
    }

    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 3
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                cell.accessoryType = .DisclosureIndicator
                cell.textLabel?.text = "ご意見・ご要望"
            case 1:
                cell.accessoryType = .DisclosureIndicator
                cell.textLabel?.text = "よくある質問"
            default: ()
            }
        }
        else {
            switch indexPath.row {
            case 0:
                cell.textLabel!.text = "レビューに協力する"
            case 1:
                cell.textLabel!.text = "友達にシェアする"
            case 2:
                let appVersion = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
                cell.textLabel!.text = "アプリのバージョン: \(appVersion)"
            default: ()
            }
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                HandShake.showCommentViewController(self)
            case 1:
                HandShake.showHelpListViewController(self)
            default: ()
            }
        }
        else {
            switch indexPath.row {
            case 0:
                UIApplication.sharedApplication().openURL(NSURL(string: kAppStoreUrl)!)
            case 1:
                showShareSheet()
            default: ()
            }
        }
    }
    
    private func showShareSheet() {
        
        let shareText = "スライドを縦に並べて見るアプリ #slidestream"
        
        let alertController = UIAlertController(title: "友達にシェアする",
            message: nil,
            preferredStyle: .ActionSheet)
        alertController.addAction(UIAlertAction(title: "Twitter",
            style: .Default,
            handler: { (_) -> Void in
                self.shareTwitter(shareText)
        }))
        alertController.addAction(UIAlertAction(title: "Facebook",
            style: .Default,
            handler: { (_) -> Void in
                self.shareFacebook(shareText)
        }))
        alertController.addAction(UIAlertAction(title: "LINE",
            style: .Default,
            handler: { (_) -> Void in
                self.shareLINE(shareText)
        }))
        alertController.addAction(UIAlertAction(title: "キャンセル", style: .Cancel, handler: nil))
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: - Share SNS
    
    private func composeViewController(serviceType: String, message: String) -> SLComposeViewController {
        let vc = SLComposeViewController(forServiceType: serviceType)
        vc.setInitialText(message)
        vc.addURL(NSURL(string: kAppStoreUrl))
        
        return vc
    }
    
    private func shareTwitter(message: String) {
        let vc = composeViewController(SLServiceTypeTwitter, message:message)
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    private func shareFacebook(message: String) {
        let vc = composeViewController(SLServiceTypeFacebook, message:message)
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    private func shareLINE(message: String) {
        // line
        if UIApplication.sharedApplication().canOpenURL(NSURL(string: "line://")!) {
            let schemeUrl = "line://msg/text/\(message)"
            
            let encodedString = schemeUrl.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            UIApplication.sharedApplication().openURL(NSURL(string: encodedString!)!)
        }
        else {
            let alert = UIAlertView()
            alert.addButtonWithTitle("OK")
            alert.title = "LINEがインストールされていません！"
            alert.message = ""
            alert.show()
        }
    }
    
    @IBAction func closeButtonTouched(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func touchThreeFinger() {
        print("3本指！！！！！")
        let alertController = UIAlertController(title: "開発者モード",
            message: "スライド情報を更新しますか？",
            preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "キャンセル",
            style: .Cancel,
            handler: nil))
        alertController.addAction(UIAlertAction(title: "更新する",
            style: .Default, handler: { (_) -> Void in
                self.refreshSlides()
        }))
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    private func refreshSlides() {
        service.refreshSlideInfo { (isSuccess, error) -> Void in
            print("refreshed")
            let alertController = UIAlertController(title: "Success", message: "更新に成功しました", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
}
