//
//  AnimationController.swift
//  InteractiveScreenTransition
//
//  Created by 井上 龍一 on 2016/02/22.
//  Copyright © 2016年 Ryuichi Inoue. All rights reserved.
//

import UIKit

class AnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    var isPresenting: Bool!
    
    // This is used for percent driven interactive transitions, as well as for container controllers that have companion animations that might need to
    // synchronize with the main animation.
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    // This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        //遷移元と遷移先のViewを取得
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        
        guard let fromView = fromVC?.view else {
            print("fromView is nil")
            return
        }
        
        guard let toView = toVC?.view else {
            print("toView is nil")
            return
        }
        
        //アニメーションを実行するためのcontainerViewを取得
        guard let containerView = transitionContext.containerView() else {
            print("containerView is nil")
            return
        }
        
        //スライドアニメーション用にinFrame(画面内)とoutFrame(画面外)を計算
        let inFrame = transitionContext.initialFrameForViewController(fromVC!)
        let outFrame = CGRectOffset(inFrame, 0, -CGRectGetHeight(inFrame))
        
        if isPresenting == true {
            //遷移元のViewの上に遷移先のビューを重ねる
            containerView.addSubview(toView)
            
            //Viewの位置を初期化
            fromView.frame = inFrame
            toView.frame = outFrame
            
            //遷移先のViewの不透明度を0.0にする
            toView.alpha = 0.0

            UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
                //遷移元のViewの不透明度を0.0にしていく
                fromView.alpha = 0.0
                //遷移元のViewを縮小
                fromView.transform = CGAffineTransformMakeScale(0.95, 0.95)
                //遷移先のViewを画面内に移動
                toView.frame = inFrame
                //遷移先のViewの不透明度を1.0にしていく
                toView.alpha = 1.0
                }, completion: { (finished) in
                    //画面遷移終了を通知
                    let completed = !transitionContext.transitionWasCancelled()
                    transitionContext.completeTransition(completed)
                    //遷移元のViewの拡大率を元に戻す
                    fromView.transform = CGAffineTransformIdentity
            })
        } else {
            //遷移元のViewの下に遷移先のViewを挿入
            containerView.insertSubview(toView, belowSubview: fromView)
            
            //Viewの位置を初期化
            fromView.frame = inFrame
            toView.frame = inFrame
            
            //遷移先のViewを縮小
            toView.transform = CGAffineTransformMakeScale(0.95, 0.95)

            UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
                //遷移先のViewの不透明度を1.0にしていく
                toView.alpha = 1.0
                //遷移先のViewの拡大率を元に戻す
                toView.transform = CGAffineTransformIdentity

                //遷移元のViewを画面外に移動
                fromView.frame = outFrame
                //遷移元のViewの不透明度を0.0にする
                //fromView.alpha = 0.0
                
                }, completion: { (finished) in
                    //画面遷移終了を通知
                    let completed = !transitionContext.transitionWasCancelled()
                    transitionContext.completeTransition(completed)
            })
        }
    }

}
