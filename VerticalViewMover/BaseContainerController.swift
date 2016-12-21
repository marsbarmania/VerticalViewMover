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
    
    lazy var centerY: CGFloat = 0
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
    
    func goToPoint(_ destValue: CGFloat) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.22, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.scrollView.contentOffset.y = destValue
            }, completion: nil)
        }
    }
    
    func rotate(){
        /*UIView.animate(withDuration: 1.0, animations: { () -> Void in
            self.arrow.transform = CGAffineTransform(rotationAngle: CGFloat(180 * M_PI))
            self.arrow.layoutSubviews()
        }) { (succeed) -> Void in
            print("aaaaaaaaaa")
        }*/
        
        var angle:CGFloat = 0
        if self.scDirection == .Down {
            angle = CGFloat(M_PI)
        }else{
            angle = 0
        }
        
        UIView.animate(withDuration: 1.0, animations: {
            self.arrow.transform = CGAffineTransform(rotationAngle: angle)
        })
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
            //print("up")
            self.scDirection = .Up
        } else {
            //print("down")
            self.scDirection = .Down
        }
    }
    
    // スクロールで指が離れたところ
    func scrollViewDidEndDragging(_ scrollView: UIScrollView,willDecelerate decelerate: Bool){
        //print("スクロールで指が離れたところ------>")
        setViewElementsOf(scrollView)
    }
    
    // スクロールストップ
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        setViewElementsOf(scrollView)
    }
    
    func setViewElementsOf(_ sv:UIScrollView) {
        let centerEdge = sv.contentOffset.y
        let stopVerticalY = centerY*2 - 40
        print("centerEdge = \(centerEdge)")
        if displayingView == BaseContainerController.Side.Up {
            print("Upper Upper Upper Upper Upper ")
            if centerEdge >= self.centerY {
                print("Change!!! Up --> down")
                goToPoint(stopVerticalY)
                rotate()
                self.displayingView = BaseContainerController.Side.Low
            }else{
                print("Not change 1")
                goToPoint(0)
            }
        }else{
            print("Lower Lower Lower Lower Lower ")
            if centerEdge < self.centerY {
                print("Change!!! Down --> Up")
                goToPoint(0)
                rotate()
                self.displayingView = BaseContainerController.Side.Up
            }else{
                print("Not change 2")
                goToPoint(stopVerticalY)
            }
        }
    }
}
