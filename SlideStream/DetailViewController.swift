//
//  DetailViewController.swift
//  SlideStream
//
//  Created by 平松　亮介 on 2015/06/30.
//  Copyright (c) 2015年 Ryosuke Hiramatsu. All rights reserved.
//

import UIKit
import SafariServices

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak private var hatenaCommentButton: UIBarButtonItem!
    @IBOutlet weak private var pageProgressView: PageProgressView!
    
    enum TableViewSectionType: Int {
        case Title = 0
        case SlideContent
        
        static func sectionCount() -> Int {
            return 2
        }
        
        static func heightForCell(indexPath: NSIndexPath) -> CGFloat {
            switch indexPath.section {
            case TableViewSectionType.Title.rawValue:
                return 44
            case TableViewSectionType.SlideContent.rawValue:
                return 270
            default:
                return 0
            }
        }
        
    }
    
    @IBOutlet weak private var tableView: UITableView!
    private var slideContents = [String]()
    var slide: Slide?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let slide = slide {
            self.title = slide.title
            tableView.reloadData()
            
            pageProgressView.setCurrentPage(1, totalPage: slide.totalCount)
            
            setUpBookmarkCount()
        }
    }
    
    private func setUpBookmarkCount() {
        hatenaCommentButton.title = "\(slide!.hatebu)users"
    }

    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case TableViewSectionType.Title.rawValue:
            return 1
        case TableViewSectionType.SlideContent.rawValue:
            return slide!.totalCount
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case TableViewSectionType.Title.rawValue:
            let cell = tableView.dequeueReusableCellWithIdentifier("DetailTitleCell") as! DetailTitleCell
            cell.configure(slide!.title)
            return cell
        case TableViewSectionType.SlideContent.rawValue:
            let cell = tableView.dequeueReusableCellWithIdentifier("SlideContentCell") as! SlideContentCell
            if let slideUrl = slide?.slideUrl(indexPath.row) {
                cell.configure(slideUrl)
            }
            return cell
        default:
            fatalError("cell not initialized")
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return TableViewSectionType.heightForCell(indexPath)
    }

    
    // MARK: - ScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        
        if contentOffsetY > 320 {
            pageProgressView.hidden = false
            
            let currentPage = Int((contentOffsetY + 19 + 530) / 270 + 1)
            pageProgressView.setCurrentPage(currentPage, totalPage: slide!.totalCount)
        } else {
            pageProgressView.hidden = true
        }

    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.pageProgressView.showWithAnimation()
    }
    
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * NSEC_PER_SEC))
        dispatch_after(delay, dispatch_get_main_queue()) { () -> Void in
            self.pageProgressView.hideWithAnimation()
        }
    }
    
    // MARK: - Action
    
    @IBAction func backButtonTouched(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction private func actionButtonTouched(sender: AnyObject) {
        let activityView = UIActivityViewController(activityItems: [slide!.link],
            applicationActivities: [])
        self.presentViewController(activityView, animated: true, completion: nil)
    }
    
    @IBAction func hatenaCommentButtonTouched(sender: AnyObject) {
        let hatenaCommentURL = "http://b.hatena.ne.jp/entry/\(slide!.link)"
        if #available(iOS 9.0, *) {
            let safariVC = SFSafariViewController(URL: NSURL(string: hatenaCommentURL)!)
            self.navigationController?.pushViewController(safariVC, animated: true)
        } else {
            UIApplication.sharedApplication().openURL(NSURL(string: hatenaCommentURL)!)
        }

    }
}
