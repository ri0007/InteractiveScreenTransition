//
//  ViewController.swift
//  InteractiveScreenTransition
//
//  Created by 井上 龍一 on 2016/01/23.
//  Copyright © 2016年 Ryuichi Inoue. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIViewControllerTransitioningDelegate, InteractionControllerDelegate {
    
    var interactionController = InteractionController()
    var isInteraction = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        transitioningDelegate = self
        interactionController.delegate = self
        interactionController.view = view
    }
    
    @IBAction func clickedButton(sender: UIButton) {
        let vc = ViewController()
        vc.view.backgroundColor = UIColor.whiteColor()
        vc.view.layer.cornerRadius = 10
        
        let button = UIButton(type: .System)
        button.setTitle("✖︎", forState: .Normal)
        button.titleLabel?.font = UIFont(name: "Helvetica", size: 30.0)
        button.addTarget(self, action: "dismiss:", forControlEvents: .TouchUpInside)
        button.frame.size = CGSize(width: 44, height: 44)
        button.center = view.center
        vc.view.addSubview(button)
        
        presentViewController(vc, animated: true, completion: nil)
    }

    func dismiss(sender:UIButton) {
        isInteraction = false
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - UIViewControllerTransitioningDelegate
    
    //画面表示時（presentViewController()実行時）のアニメーションコントローラを指定
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animatedTransitioning = AnimationController()
        animatedTransitioning.isPresenting = true
        return animatedTransitioning
    }
    
    //画面非表示時（presentViewController()実行時）のアニメーションコントローラを指定
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animatedTransitioning = AnimationController()
        animatedTransitioning.isPresenting = false
        return animatedTransitioning
    }
    
    //画面非表示時（presentViewController()実行時）のインタラクティブコントローラを指定
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if isInteraction == true {
            return interactionController
        } else {
            return nil
        }
    }
    
    //MARK: - InteractionControllerDelegate
    
    //タッチアクション開始を通知するメソッド
    func interactionBeganAtPoint(point: CGPoint) {
        isInteraction = true
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //タッチアクション終了を通知するメソッド
    func interactionEnded() {
        isInteraction = false
    }
}

