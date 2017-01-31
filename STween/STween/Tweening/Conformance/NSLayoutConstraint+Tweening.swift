//
//  NSLayoutConstraint+Tweening.swift
//  STween
//
//  Created by Adam Graham on 8/28/16.
//  Copyright © 2016 Adam Graham. All rights reserved.
//

/// An extension to provide tweening animation functionality to `NSLayoutConstraint`.
extension NSLayoutConstraint: Tweenable {

    /// An enum to describe the properties that can be animated with a tween
    /// on a `NSLayoutConstraint`.
    public enum TweenProperty: TweenableProperty {

        /// A case to denote the `constant` property of a `NSLayoutConstraint`.
        case constant(CGFloat)
        /// A case to denote the `priority` property of a `NSLayoutConstraint`.
        case priority(UILayoutPriority)

        public func value<T: Tweenable>(from object: T) throws -> TweenProperty {
            guard let constraint = object as? NSLayoutConstraint else {
                throw TweenError.objectNotConvertible(object, to: NSLayoutConstraint.self)
            }

            switch self {
            case .constant:
                return .constant(constraint.constant)
            case .priority:
                return .priority(constraint.priority)
            }
        }

        public func apply<T: Tweenable>(to object: T) throws {
            guard let constraint = object as? NSLayoutConstraint else {
                throw TweenError.objectNotConvertible(object, to: NSLayoutConstraint.self)
            }

            switch self {
            case let .constant(value):
                constraint.constant = value
            case let .priority(value):
                constraint.priority = value
            }
        }

        public static func interpolate(_ startValue: TweenProperty, to endValue: TweenProperty, with ease: Ease,
                                       elapsed: TimeInterval, duration: TimeInterval) -> TweenProperty {

            switch (startValue, endValue) {
            case let (.constant(start), .constant(end)):
                return .constant(CGFloat.interpolate(start, to: end, with: ease, elapsed: elapsed, duration: duration))
            case let (.priority(start), .priority(end)):
                return .priority(UILayoutPriority.interpolate(start, to: end, with: ease, elapsed: elapsed, duration: duration))
            default:
                return startValue
            }
        }

    }
    
}
