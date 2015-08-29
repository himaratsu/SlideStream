//
//  ViewController.swift
//  SlideStream
//
//  Created by 平松　亮介 on 2015/06/30.
//  Copyright (c) 2015年 Ryosuke Hiramatsu. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, RoundSearchButtonDelegate,
OverlayTextFieldDelegate {
    
    @IBOutlet weak private var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    private let service = SlideService()
    private var currentMode: Mode = .Latest
    private var currentIndex: Int = 0
    @IBOutlet weak private var roundSearchButton: RoundSearchButton!
    @IBOutlet weak private var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpRefreshControl()
        
        setUpGesture()
        
        roundSearchButton.delegate = self
        
        reload(mode: currentMode)
    }
    
    private func setUpRefreshControl() {
        refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "引っ張って更新")
        tableView.addSubview(refreshControl)
    }
    
    private func setUpGesture() {
        let toLeftGesture = UISwipeGestureRecognizer(target: self, action: "swipeToLeft")
        toLeftGesture.direction = UISwipeGestureRecognizerDirection.Left
        view.addGestureRecognizer(toLeftGesture)
        
        let toRightGesture = UISwipeGestureRecognizer(target: self, action: "swipeToRight")
        toRightGesture.direction = UISwipeGestureRecognizerDirection.Right
        view.addGestureRecognizer(toRightGesture)
    }
    
    private func reload(mode mode: Mode) {
        
        service.requestSlides(mode) { (slides, error) -> Void in
            if let _ = error {
                print("#################### error #####################", appendNewline: false)
            }
            else {
                self.tableView.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated: false)
                self.tableView.reloadData()
            }

            self.refreshControl.endRefreshing()
        }
    }

    private func showSearchView() {
        if let window = UIApplication.sharedApplication().delegate?.window!! {
            let textField = OverlayTextField(frame: window.bounds)
            textField.delegate = self
            window.addSubview(textField)
            
            textField.textField.becomeFirstResponder()
        }
    }
    
    // MARK: - UIRefreshControl
    
    func refresh() {
        reload(mode: currentMode)
    }
    

    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if let count = service.slides[currentMode]?.count {
                return count
            } else {
                return 0
            }
            
        case 1:
            return 1
            
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("SlideCell") as! SlideCell
            let slides = service.slides[currentMode]!
            cell.configureSlide(slides[indexPath.row], index:indexPath.row)
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("LoadingCell") as! LoadingCell
            cell.configure()
            return cell
            
        default:
            fatalError("UITableView not initialized")
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 114
            
        case 1:
            return 74
            
        default:
            return 0
        }

    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let slide = service.slides[currentMode]![indexPath.row]
        self.performSegueWithIdentifier("showDetail", sender: slide)
    }
    
    
    // MARK: - Storyboard
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let destVC = segue.destinationViewController as? DetailViewController {
                destVC.slide = sender as? Slide
            }
        }
    }
    
    
    // MARK: - Action
    
    @IBAction func segmentedControlChanged(sender: UISegmentedControl) {
        let selectIndex = sender.selectedSegmentIndex
        moveToIndex(selectIndex)
    }
    
    private func moveToIndex(index: Int) {
        currentIndex = index
        segmentedControl.selectedSegmentIndex = currentIndex
        let mode = Mode(rawValue: index)
        
        if let mode = mode where currentMode != mode {
            if let isLoad = service.isLoaded[mode] where isLoad {
                currentMode = mode
                tableView.reloadData()
            } else {
                currentMode = mode
                tableView.reloadData()
                reload(mode: mode)
            }
        } else {
            tableView.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated: true)
        }
    }
    
    func swipeToLeft() {
        if let nextMode = Mode(rawValue: currentIndex + 1) {
            moveToIndex(nextMode.rawValue)
        }
    }
    
    func swipeToRight() {
        if let prevMode = Mode(rawValue: currentIndex - 1) {
            moveToIndex(prevMode.rawValue)
        }
    }
    
    
    // MARK: - RoundSearchButtonDelegate
    
    func searchButtonDidTouched() {
        showSearchView()
    }
    
    
    // MARK: - OverlayTextFieldDelegate
    
    func didSearchWithUrl(url: String) {
        service.requestSlide(url) { (slide, error) -> Void in
            if let _ = error {
                print("###### error ######")
            } else {
                self.performSegueWithIdentifier("showDetail", sender: slide)
            }
        }
    }


}


enum Mode: Int {
    case Latest = 0
    case Popular
    case All

    
    var mode: String {
        switch self {
        case .Latest:   return "all"
        case .Popular:  return "this_month"
        case .All:      return "all"
        }
    }
}
