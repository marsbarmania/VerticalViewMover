//
//  BaseContainerController.swift
//  VerticalViewMover
//
//  Created by NakashimaHiroki on 2016/12/14.
//  Copyright © 2016年 Marsbarmania. All rights reserved.
//

import UIKit

class BaseContainerController: UIViewController,UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            //scrollView.contentSize = CGSize(width: 700, height: 1000)
            scrollView.delegate = self
            //scrollView.minimumZoomScale = 0.03
            //scrollView.maximumZoomScale = 1.0
            
            let first:FirstViewController = FirstViewController(nibName: "FirstViewController", bundle: nil)
            self.contentView.addSubview(first.view)
            let second: SecondViewController = SecondViewController(nibName: "SecondViewController", bundle: nil)
            self.contentView.addSubview(second.view)
            let frame = first.view.frame
            second.view.frame = CGRect(x: 0, y: frame.size.height,width: second.view.frame.size.width, height: second.view.frame.size.height)
            
        }
    }
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

