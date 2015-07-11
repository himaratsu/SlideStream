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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reload()
    }
    
    private func reload() {
    
        let service = SlideService()
        service.requestSlides { (slides, error) -> Void in
            
            if let _ = error {
                println("#################### error #####################")
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


}

