//
//  TapCardView.swift
//  TapCardView
//
//  Created by jinsei shima on 2017/12/31.
//  Copyright © 2017 jinsei shima. All rights reserved.
//

import UIKit

public enum TapPosition {
    case left, right, bottom
}

public protocol TapCardViewDelegate: class {
    func cardView(_ cardView: TapCardView, tappedIn: TapPosition)
}

open class TapCardView: UIView {
    public weak var delegate: TapCardViewDelegate?

    // border of tap position. ratio of width and height. value is 0.0 to 1.0
    public var horizontalBorder: CGFloat = 0.5
    public var verticalBorder: CGFloat = 0.75

    // flip animation settings
    public var flipDegree: Float = 12
    public var flipDuration: TimeInterval = 0.24

    // MARK: Initialize

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture(sender:)))
        addGestureRecognizer(tapGesture)
        layer.isDoubleSided = false
    }

    // MARK: Public function

    @objc
    open func tapGesture(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let tapPoint = sender.location(in: self)
            let tapPosition = getTapPosition(point: tapPoint, size: bounds.size)
            delegate?.cardView(self, tappedIn: tapPosition)
        }
    }

    public func getTapPosition(point: CGPoint, size: CGSize) -> TapPosition {
        if point.y >= size.height * verticalBorder {
            return .bottom
        } else if point.x >= size.width * horizontalBorder {
            return .right
        } else {
            return .left
        }
    }

    public func flipCard(type: TapPosition) {
        if type == .bottom { return }

        // degree of rotation, when left end or right end.
        let radius: Float = (type == .left) ? flipDegree : -flipDegree
        let duration = flipDuration

        UIView.animateKeyframes(withDuration: duration, delay: 0, options: [.allowUserInteraction], animations: {
            var transform = CATransform3DIdentity
            transform.m34 = 1/1000
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: duration/2, animations: {
                self.layer.transform = CATransform3DRotate(transform, self.degree2radian(d: radius), 0, 1, 0)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: duration/2, animations: {
                self.layer.transform = CATransform3DRotate(transform, self.degree2radian(d: 0), 0, 1, 0)
            })
        }, completion: nil)
    }

    // MARK: Private function

    private func degree2radian(d: Float) -> CGFloat {
        let r = Float.pi * d/180
        return CGFloat(r)
    }
}

