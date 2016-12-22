//
//  BaseContainerController.swift
//  VerticalViewMover
//
//  Created by NakashimaHiroki on 2016/12/14.
//  Copyright © 2016年 Marsbarmania. All rights reserved.
//

import UIKit


class BaseContainerController: UIViewController{
    // class stuff
    enum Side: Int {
        case Up = 0
        case Low = 1
    }
    
    lazy var centerY: CGFloat           = 0
    internal var rotateOffset:CGFloat   = CGFloat(120)
    internal var rotateOffset2:CGFloat  = CGFloat(200)
    internal var displayingView = BaseContainerController.Side.Up {
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
    
    internal var scDirection: ScrollDirection = .None
    private var upperView: UpperViewController?
    private var lowerView: LowerViewController?
    
    @IBOutlet weak var arrow: UIImageView!

    @IBOutlet weak var positionDebugView: UIView!
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
            //scrollView.contentSize = CGSize(width: 700, height: 1000)
            //scrollView.minimumZoomScale = 0.03
            //scrollView.maximumZoomScale = 1.0
        }
    }
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var directonContainerViewHeight: NSLayoutConstraint!
    
    
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
    
    func goToPoint(_ destValue: CGFloat) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.22, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.scrollView.contentOffset.y = destValue
            }, completion: nil)
        }
    }
    
    func rotate(_ direction: ScrollDirection){
        
        var angle:CGFloat = 0
        
        switch direction {
        case .Down:
            angle = CGFloat(M_PI)
        case .Up:
            angle = 0
        default:
            angle = 0
        }
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.arrow.transform = CGAffineTransform(rotationAngle: angle)
            self.arrow.layoutSubviews()
        }){ (succeed) -> Void in
            //print("succeed ====> \(succeed)")
        }
    }

}

extension BaseContainerController: UIScrollViewDelegate {
    
    enum ScrollDirection {
        case None
        case Right
        case Left
        case Up
        case Down
        case Crazy
    }

    
    // ----------------------------------------------
    // MARK: - UIScrollViewDelegate
    // スクロールスタート
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) { }
    
    // スクロール中
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if(scrollView.panGestureRecognizer.translation(in: scrollView.superview).y > 0) {
            self.scDirection = .Up
        } else {
            self.scDirection = .Down
        }
        
        let theEdge  = scrollView.contentOffset.y
        let theEdge2 = scrollView.contentOffset.y - rotateOffset2
        
        if self.scDirection == .Up {
            // 上向き
            if theEdge2 <= self.centerY {
                rotate(.Up)
            }else{
                rotate(.Down)
            }
            
        }else{
            // 下向きにスクロール
            if theEdge > self.rotateOffset {
                rotate(.Down)
            }else{
                rotate(.Up)
            }
        }
    }
    
    // スクロールで指が離れたところ
    func scrollViewDidEndDragging(_ scrollView: UIScrollView,willDecelerate decelerate: Bool){
        //print("スクロールで指が離れたところ------>")
        setViewElementsOf(scrollView)
    }
    
    // スクロールストップ
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        // Swipe状態になっている場合は、早めに
        setViewElementsOf(scrollView, swipe: true)
    }
    
    func setViewElementsOf(_ sv:UIScrollView, swipe:Bool = false) {
        let centerEdge = sv.contentOffset.y
        let stopVerticalY = centerY*2 - self.directonContainerViewHeight.constant
        
        var edge = self.centerY
        if swipe {
            edge /= 2
        }
        
        if displayingView == BaseContainerController.Side.Up {
            
            if centerEdge >= edge {
                goToPoint(stopVerticalY)
                self.displayingView = BaseContainerController.Side.Low
            }else{
                goToPoint(0)
            }
        }else{
            if centerEdge < edge {
                goToPoint(0)
                self.displayingView = BaseContainerController.Side.Up
            }else{
                goToPoint(stopVerticalY)
            }
        }
    }
}
