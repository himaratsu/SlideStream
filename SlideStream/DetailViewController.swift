//
//  DetailViewController.swift
//  SlideStream
//
//  Created by 平松　亮介 on 2015/06/30.
//  Copyright (c) 2015年 Ryosuke Hiramatsu. All rights reserved.
//

import UIKit
import SafariServices
import MWPhotoBrowser

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,
MWPhotoBrowserDelegate {

    @IBOutlet weak private var hatenaCommentButton: UIBarButtonItem!
    @IBOutlet weak private var pageProgressView: PageProgressView!
    @IBOutlet weak var serviceIconItem: UIBarButtonItem!
    private var cellHeight: CGFloat = 270
    
    private var slideImages = [MWPhoto]()
    
    enum TableViewSectionType: Int {
        case Title = 0
        case SlideContent
        
        static func sectionCount() -> Int {
            return 2
        }
        
        static func heightForCell(indexPath: NSIndexPath, slideCellHeight: CGFloat) -> CGFloat {
            switch indexPath.section {
            case TableViewSectionType.Title.rawValue:
                return 44
            case TableViewSectionType.SlideContent.rawValue:
                return slideCellHeight
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
            
            calculateImageHeight()
            
            tableView.reloadData()
            
            pageProgressView.setCurrentPage(1, totalPage: slide.totalCount)
            
            setUpBookmarkCount()
            
            setUpServiceIcon()
        }
    }
    
    private func calculateImageHeight() {
        if let imageUrl = slide?.slideThumbUrl(),
            let imageURL = NSURL(string: imageUrl) {
                let imageView = UIImageView()
                imageView.sd_setImageWithURL(imageURL, completed: { (image, error, cacheType, URL) -> Void in
                    if let image = image {
                        let width = image.size.width
                        let height = image.size.height
                        
                        self.cellHeight = (height / width) * (UIScreen.mainScreen().bounds.size.width - 16) + 16
                        self.tableView.reloadData()
                    }
                })
        }
    }
    
    private func setUpBookmarkCount() {
        hatenaCommentButton.title = "\(slide!.hatebu)users"
    }
    
    private func setUpServiceIcon() {
        switch slide!.source {
        case .SlideShare:
            serviceIconItem.image = UIImage(named: "ss_icon")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        case .SpeakerDeck:
            serviceIconItem.image = UIImage(named: "sd_icon")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        default:
            serviceIconItem.image = nil
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
        return TableViewSectionType.heightForCell(indexPath, slideCellHeight: cellHeight)
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch indexPath.section {
        case TableViewSectionType.SlideContent.rawValue:
            showSlideZoom(indexPath.row)
        default: ()
        }
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
        if let URL = NSURL(string: slide!.link) {
            let activityView = UIActivityViewController(activityItems: [URL],
                applicationActivities: [])
            self.presentViewController(activityView, animated: true, completion: nil)
        }
    }
    
    @IBAction func hatenaCommentButtonTouched(sender: AnyObject) {
        let hatenaCommentURL = "http://b.hatena.ne.jp/entry/\(slide!.link)"
        if #available(iOS 9.0, *) {
            let safariVC = SFSafariViewController(URL: NSURL(string: hatenaCommentURL)!)
            safariVC.title = "コメント"
            self.navigationController?.pushViewController(safariVC, animated: true)
        } else {
            UIApplication.sharedApplication().openURL(NSURL(string: hatenaCommentURL)!)
        }

    }
    
    @IBAction func serviceIconItemTouched(sender: AnyObject) {
        if #available(iOS 9.0, *) {
            let safariVC = SFSafariViewController(URL: NSURL(string: slide!.link)!)
            self.navigationController?.pushViewController(safariVC, animated: true)
        } else {
            UIApplication.sharedApplication().openURL(NSURL(string: slide!.link)!)
        }
    }
    
    
    private func showSlideZoom(index: Int) {
        
        guard let slide = slide else {
            return
        }
        
        slideImages = [MWPhoto]()
        
        for index in 0...slide.totalCount {
            if let slideUrl = slide.slideUrl(index) {
                slideImages.append(MWPhoto(URL: NSURL(string: slideUrl)))
            }
        }
        
        let browser = MWPhotoBrowser(delegate: self)
        navigationController?.pushViewController(browser, animated: true)
        browser.setCurrentPhotoIndex(UInt(index))
        
        

//        
//        // Create browser (must be done each time photo browser is
//        // displayed. Photo browser objects cannot be re-used)
//        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
//        
//        // Set options
//        browser.displayActionButton = YES; // Show action button to allow sharing, copying, etc (defaults to YES)
//        browser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
//        browser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
//        browser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
//        browser.alwaysShowControls = NO; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
//        browser.enableGrid = YES; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
//        browser.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
//        browser.autoPlayOnAppear = NO; // Auto-play first video
//        
//        // Customise selection images to change colours if required
//        browser.customImageSelectedIconName = @"ImageSelected.png";
//        browser.customImageSelectedSmallIconName = @"ImageSelectedSmall.png";
//        
//        // Optionally set the current visible photo before displaying
//        [browser setCurrentPhotoIndex:1];
//        
//        // Present
//        [self.navigationController pushViewController:browser animated:YES];
//        
//        // Manipulate
//        [browser showNextPhotoAnimated:YES];
//        [browser showPreviousPhotoAnimated:YES];
//        [browser setCurrentPhotoIndex:10];
    }
    
    // MARK: - MWPhotoBrowserDelegate
    
    func numberOfPhotosInPhotoBrowser(photoBrowser: MWPhotoBrowser!) -> UInt {
        return UInt(slideImages.count)
    }
    
    func photoBrowser(photoBrowser: MWPhotoBrowser!, photoAtIndex index: UInt) -> MWPhotoProtocol! {
        let convertIndex = Int(index)
        if convertIndex < slideImages.count {
            return slideImages[convertIndex]
        } else {
            return nil
        }
    }
}
