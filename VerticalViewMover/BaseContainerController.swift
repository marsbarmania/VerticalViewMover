//
//  BaseContainerController.swift
//  VerticalViewMover
//
//  Created by NakashimaHiroki on 2016/12/14.
//  Copyright © 2016年 Marsbarmania. All rights reserved.
//

import UIKit

class BaseContainerController: UIViewController,UIScrollViewDelegate {
    
    enum Side: Int {
        case Up = 0
        case Low = 1
    }
    
    lazy var centerY: CGFloat = 0
    private var displayingView = BaseContainerController.Side.Up {
        didSet {
            var bgColor = UIColor.clear
            if self.displayingView == BaseContainerController.Side.Up {
                bgColor = UIColor.green
            }else{
                bgColor = UIColor.red
            }
            self.positionDebugView.backgroundColor = bgColor
        }
    }
    private var upperView: UpperViewController?
    private var lowerView: LowerViewController?
    

    @IBOutlet weak var positionDebugView: UIView!
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            //scrollView.contentSize = CGSize(width: 700, height: 1000)
            scrollView.delegate = self
            //scrollView.minimumZoomScale = 0.03
            //scrollView.maximumZoomScale = 1.0
            
        }
    }
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.centerY = self.view.frame.size.height / 2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goToPoint(destValue: CGFloat) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.22, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.scrollView.contentOffset.y = destValue
            }, completion: nil)
        }
    }
    
    
    // ----------------------------------------------
    // MARK: - UIScrollViewDelegate
    // スクロールスタート
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) { }
    
    // スクロール中
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height
        if (bottomEdge >= scrollView.contentSize.height){
            // we are at the end
        }
    }
    
    // スクロールで指が離れたところ
    func scrollViewDidEndDragging(_ scrollView: UIScrollView,willDecelerate decelerate: Bool){
        //print("スクロールで指が離れたところ------>")
        setViewElementsOf(sv: scrollView)
    }
    
    // スクロールストップ
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        setViewElementsOf(sv: scrollView)
    }
    
    func setViewElementsOf(sv:UIScrollView) {
        let centerEdge = sv.contentOffset.y
        print("centerEdge = \(centerEdge)")
        if displayingView == BaseContainerController.Side.Up {
            print("Upper Upper Upper Upper Upper ")
            if centerEdge >= self.centerY {
                print("Change!!! Up --> down")
                goToPoint(destValue: centerY*2)
                self.displayingView = BaseContainerController.Side.Low
            }else{
                print("Not change 1")
                goToPoint(destValue: 0)
            }
        }else{
            print("Lower Lower Lower Lower Lower ")
            if centerEdge < self.centerY {
                print("Change!!! Down --> Up")
                goToPoint(destValue: 0)
                self.displayingView = BaseContainerController.Side.Up
            }else{
                print("Not change 2")
                goToPoint(destValue: centerY*2)
            }
        }
    }


}

