//
//  NSLayoutConstraint+Tweening.swift
//  STween
//
//  Created by Adam Graham on 8/28/16.
//  Copyright © 2016 Adam Graham. All rights reserved.
//

/// An extension to provide tweening animation functionality to `NSLayoutConstraint`.
extension NSLayoutConstraint: Tweenable {

    public func value(of property: NSLayoutConstraintTweenProperty) -> NSLayoutConstraintTweenProperty {
        switch property {
        case .constant:
            return .constant(self.constant)
        }
    }

    public func apply(_ property: NSLayoutConstraintTweenProperty) {
        switch property {
        case let .constant(value):
            self.constant = value
        }
    }
    
}

/// An enum to describe the properties that can be animated with a tween
/// on a `NSLayoutConstraint`.
public enum NSLayoutConstraintTweenProperty: TweenableProperty {

    /// A case to denote the `constant` property of a `NSLayoutConstraint`.
    case constant(CGFloat)

    public static func interpolate(from startValue: NSLayoutConstraintTweenProperty, to endValue: NSLayoutConstraintTweenProperty, with ease: Ease,
                                   elapsed: TimeInterval, duration: TimeInterval) -> NSLayoutConstraintTweenProperty {

        switch (startValue, endValue) {
        case let (.constant(start), .constant(end)):
            return .constant(CGFloat.interpolate(from: start, to: end, with: ease, elapsed: elapsed, duration: duration))
        }
    }

}
