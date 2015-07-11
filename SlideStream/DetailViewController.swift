//
//  DetailViewController.swift
//  SlideStream
//
//  Created by 平松　亮介 on 2015/06/30.
//  Copyright (c) 2015年 Ryosuke Hiramatsu. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

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
        }
        
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
    
    
    // MARK: - Action
    
    @IBAction private func actionButtonTouched(sender: AnyObject) {
        
        if UIApplication.sharedApplication().canOpenURL(NSURL(string: slide!.link)!) {
            UIApplication.sharedApplication().openURL(NSURL(string: slide!.link)!)
        }
        
    }
}
