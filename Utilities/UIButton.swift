//
//  Utilities.swift
//  eung7_Netflix
//
//  Created by 김응철 on 2022/05/06.
//

import UIKit
import Kingfisher

/// Play/Pause Button Custom AnimationType
private enum Animation {
  typealias Element = (
    duration: TimeInterval,
    delay: TimeInterval,
    options: UIView.AnimationOptions,
    scale: CGAffineTransform,
    alpha: CGFloat
  )
  
  case touchDown
  case touchUp
  
  var element: Element {
    switch self {
    case .touchDown:
      return Element(
        duration: 0,
        delay: 0,
        options: .curveLinear,
        scale: .init(scaleX: 1.3, y: 1.3),
        alpha: 0.8
      )
    case .touchUp:
      return Element(
        duration: 0,
        delay: 0,
        options: .curveLinear,
        scale: .identity,
        alpha: 1
      )
    }
  }
}

extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        self.clipsToBounds = true  // add this to maintain corner radius
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.setBackgroundImage(colorImage, for: forState)
        }
    }
}

class AnimationButton: UIButton {
    
    /// isHighlighted 프로퍼티 오버라이드를 해서 didSet 사용
    override var isHighlighted: Bool {
        didSet {
            /// Highlighted가 될 때마다 animationButton Method 실행
            self.animateButton()
        }
    }
    
    /// 애니메이션이 되는 Method
    func animateButton() {
        /// isHighlighted가 true와 false가 될 때마다 element가 새롭게 정의된다.
        let element = self.isHighlighted ? Animation.touchDown.element : Animation.touchUp.element
        
        UIView.animate(
            withDuration: element.duration,
            delay: element.delay,
            options: element.options,
            animations: {
                self.transform = element.scale
                self.alpha = element.alpha
            }
        )
    }
}
