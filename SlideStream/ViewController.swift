//
//  ViewController.swift
//  SlideStream
//
//  Created by 平松　亮介 on 2015/06/30.
//  Copyright (c) 2015年 Ryosuke Hiramatsu. All rights reserved.
//

import UIKit
import Alamofire


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak private var tableView: UITableView!
    private var slides = [Slide]()
    
    private var currentMode = Mode.Recently
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reload(mode: currentMode)
    }
    
    private func reload(mode mode: Mode = .All) {
    
        let service = SlideService()
        service.requestSlides(mode) { (slides, error) -> Void in
            if let _ = error {
                print("#################### error #####################")
            }
            else {
                self.slides = slides!
                self.tableView.reloadData()
            }

        }
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

}


enum Mode: String {
    case Recently = "this_week"
    case Popular = "this_month"
    case All = "all"
    
    static func modeWithIndex(index: Int) -> Mode {
        switch index {
        case 0:
            return Mode.Recently
        case 1:
            return Mode.Popular
        case 2:
            return Mode.All
        default:
            return Mode.All
        }
    }
}