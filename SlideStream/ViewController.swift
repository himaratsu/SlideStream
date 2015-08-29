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
    private var slides = [Slide]()
    private var currentMode = Mode.Recently
    @IBOutlet weak var roundSearchButton: RoundSearchButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpRefreshControl()
        
        roundSearchButton.delegate = self
        
        reload(mode: currentMode)
    }
    
    private func setUpRefreshControl() {
        refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
    }
    
    private func reload(mode mode: Mode = .All) {
        
        let service = SlideService()
        service.requestSlides(mode) { (slides, error) -> Void in
            if let _ = error {
                print("#################### error #####################", appendNewline: false)
            }
            else {
                self.slides = slides!
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return slides.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SlideCell") as! SlideCell
        cell.configureSlide(slides[indexPath.row], index:indexPath.row)
        return cell
    }
    
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let slide = slides[indexPath.row]
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
        let mode = Mode.modeWithIndex(selectIndex)
        
        if currentMode != mode {
            reload(mode: mode)
            currentMode = mode
        }
        
    }
    
    
    // MARK: - RoundSearchButtonDelegate
    
    func searchButtonDidTouched() {
        showSearchView()
    }
    
    
    // MARK: - OverlayTextFieldDelegate
    
    func didSearchWithUrl(url: String) {
        let service = SlideService()
        service.requestSlide(url) { (slide, error) -> Void in
            if let _ = error {
                print("###### error ######")
            } else {
                print(slide)
            }
        }
    }


}


enum Mode: String {
    case Recently = "recently"
    case Latest = "this_week"
    case Popular = "this_month"
    case All = "all"
    
    static func modeWithIndex(index: Int) -> Mode {
        switch index {
        case 0:
            return Mode.Recently
        case 1:
            return Mode.Latest
        case 2:
            return Mode.Popular
        case 3:
            return Mode.All
        default:
            return Mode.All
        }
    }
}
