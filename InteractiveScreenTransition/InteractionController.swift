//
//  InteractionController.swift
//  InteractiveScreenTransition
//
//  Created by 井上 龍一 on 2016/02/22.
//  Copyright © 2016年 Ryuichi Inoue. All rights reserved.
//

import UIKit

protocol InteractionControllerDelegate: class {
    func interactionBeganAtPoint(point: CGPoint)
    func interactionEnded()
}

class InteractionController:UIPercentDrivenInteractiveTransition {

    weak var delegate: InteractionControllerDelegate?
    var isInteraction = false
    
    var view: UIView! {
        didSet {
            let gesture = UIPanGestureRecognizer(target: self, action: "handleGesture:")
            view.addGestureRecognizer(gesture)
        }
    }
    
    func handleGesture(gesture: UIPanGestureRecognizer){
        switch gesture.state {
        case .Began:
            //viewのパン開始位置を取得
            let point = gesture.locationInView(view)
            //状態を遷移中に変更
            isInteraction = true
            //画面遷移アクションの開始を通知
            delegate?.interactionBeganAtPoint(point)
        case .Changed:
            //viewのサイズを取得
            let viewRect = view.bounds
            //現在のパン位置を取得
            let translation = gesture.translationInView(view)
            //画面の高さとの割合を計算
            let percent = -translation.y / CGRectGetHeight(viewRect)
            //画面遷移の進捗を更新
            updateInteractiveTransition(percent)
        case .Cancelled, .Ended:
            //パンジェスチャーの速度を取得
            let velocity = gesture.velocityInView(view)
            if velocity.y > -50 {
                //上に 50pt/単位時間 未満の速度で動いていたら
                //画面遷移をキャンセルする
                cancelInteractiveTransition()
            } else {
                //そうでない場合画面遷移を継続する
                finishInteractiveTransition()
            }
            isInteraction = false
            //画面遷移の終了を通知
            delegate?.interactionEnded()
        default:
            break
        }
    }
}
