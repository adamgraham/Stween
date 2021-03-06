//
//  Tweener.swift
//  STween
//
//  Created by Adam Graham on 6/16/16.
//  Copyright © 2016 Adam Graham. All rights reserved.
//

import Foundation
import QuartzCore

/// A factory class to create, queue, and manage `Tween` animations.
public final class Tweener {

    // MARK: Instance

    /// A dictionary to store each instantiated `Tweener` by its identifier.
    private static var tweeners: [String: Tweener] = [:]

    /// The default assigned instance of `Tweener`.
    public static var `default`: Tweener {
        return self.tweeners["default"] ?? self.shared
    }

    /// The main shared instance of `Tweener`.
    public static let shared: Tweener = {
        let setAsDefault = tweeners["default"] == nil
        return Tweener(identifier: "shared", setAsDefault: setAsDefault)
    }()

    /// An instance of `Tweener` where all tweens are manually controlled and updated.
    public static let manual: Tweener = {
        let tweener = Tweener(identifier: "manual")
        tweener.tweenTimer.invalidate()
        tweener.queueTimer.invalidate()
        return tweener
    }()

    /// Returns a reference to a custom `Tweener` instance by its identifier. The `Tweener`
    /// instance is created if it does not already exist.
    /// - parameter identifier: The identifier of the custom `Tweener` instance.
    /// - returns: The custom `Tweener` instance for the given identifier.
    public static func custom(_ identifier: String) -> Tweener {
        let identifier = identifier.lowercased()
        if let tweener = tweeners[identifier] { return tweener }
        return Tweener(identifier: identifier)
    }

    /// The identifier of this `Tweener` instance.
    public let identifier: String

    /// Initializes an instance of `Tweener` with a given identifier.
    /// - parameter identifier: The identifier of the `Tweener` instance.
    /// - parameter setAsDefault: Sets the default `Tweener` instance to this one if `true`.
    private init(identifier: String, setAsDefault: Bool = false) {
        self.identifier = identifier
        Tweener.tweeners[identifier] = self
        if setAsDefault { self.setAsDefault() }
    }

    /// Assigns this instance of `Tweener` as the default instance.
    public func setAsDefault() {
        Tweener.tweeners["default"] = self
    }

    // MARK: Time Properties

    /// The time of the last update event.
    private var lastUpdate = Date()

    /// An array of every instantiated tween.
    private var tweens = [Tween]() {
        didSet {
            let wasPaused = self.tweenTimer.isPaused
            self.tweenTimer.isPaused = self.tweens.isEmpty
            if !self.tweenTimer.isPaused && wasPaused {
                self.lastUpdate = Date()
            }
        }
    }

    /// The timer used to update all active tweens.
    private lazy var tweenTimer: CADisplayLink = {
        let selector = #selector(self.updateTrackedTweens)
        let timer = CADisplayLink(target: self, selector: selector)
        timer.add(to: .main, forMode: RunLoop.Mode.default)
        timer.isPaused = true
        return timer
    }()

    /// An array of every instantiated tween that is waiting to be started.
    private var queuedTweens = [Tween]() {
        didSet {
            self.queueTimer.isPaused = self.queuedTweens.isEmpty
        }
    }

    /// The timer used to start any queued tweens.
    private lazy var queueTimer: CADisplayLink = {
        let selector = #selector(self.startQueuedTweens)
        let timer = CADisplayLink(target: self, selector: selector)
        timer.add(to: .main, forMode: RunLoop.Mode.default)
        timer.isPaused = true
        return timer
    }()

}

public extension Tweener {

    // MARK: Factory Creation

    /// Creates a `Tween` that can be customized to animate properties on a target instance.
    /// - parameter target: The `Tweenable` instance on which properties are animated.
    /// - returns: The `Tween` handle that manages and controls the animation.
    @discardableResult
    func animate<Target: Tweenable>(_ target: Target) -> TweenAnimator<Target> {
        let tween = TweenAnimator(targets: target)
        tween.tweener = self
        track(tween)

        if Defaults.autoStartTweens && self !== Tweener.manual {
            queue(tween)
        }

        return tween
    }

}

public extension Tweener {

    // MARK: Tracking

    /// The number of tweens crrently being tracked.
    var count: Int {
        return self.tweens.count
    }

    /// Checks if a tween is being tracked.
    /// - parameter tween: The `Tween`control to be checked.
    /// - returns: `true` if the tween is contained in the list of tracked tweens.
    func isTracking(_ tween: Tween) -> Bool {
        return self.tweens.contains(where: { $0 === tween })
    }

    /// Adds a tween to the list of tracked tweens.
    /// - parameter tween: The `Tween` control to be added.
    func track(_ tween: Tween) {
        guard self.tweens.firstIndex(where: { $0 === tween }) == nil else {
            return
        }

        self.tweens.append(tween)
    }

    /// Removes a tween from the list of tracked tweens.
    /// - parameter tween: The `Tween` control to be removed.
    func untrack(_ tween: Tween) {
        if let index = self.tweens.firstIndex(where: { $0 === tween }),
            index >= 0 && index < self.tweens.count {
                self.tweens.remove(at: index)
        }

        if let index = self.queuedTweens.firstIndex(where: { $0 === tween }),
            index >= 0 && index < self.queuedTweens.count {
                self.queuedTweens.remove(at: index)
        }
    }

}

internal extension Tweener {

    // MARK: Queueing

    /// The number of tweens currently queued to start.
    var queuedCount: Int {
        return self.queuedTweens.count
    }

    /// Queues a tween to be started.
    ///
    /// Tweens are started one frame after being created in order for all necessarily properties
    /// to be applied before starting.
    ///
    /// - parameter tween: The `Tween` control to be queued.
    func queue(_ tween: Tween) {
        guard self.queuedTweens.firstIndex(where: { $0 === tween }) == nil else {
            return
        }

        self.queuedTweens.append(tween)
    }

    /// Starts all queued tweens by invoking `start` on each one – putting the tweens in an
    /// `active` state and removing them from the list of queued tweens.
    @objc func startQueuedTweens() {
        self.queuedTweens.forEach {
            $0.start()
        }

        self.queuedTweens.removeAll()
    }

}

public extension Tweener {

    // MARK: Global State Control

    /// Updates all tweens
    @objc private func updateTrackedTweens() {
        let now = Date()
        let deltaTime = now.timeIntervalSince(self.lastUpdate)
        updateAll(by: deltaTime)
        self.lastUpdate = now
    }

    /// Invokes `update` on all currently tracked tweens.
    /// - parameter deltaTime: The amount of seconds passed since the last update.
    func updateAll(by deltaTime: TimeInterval) {
        self.tweens.forEach { $0.update(by: deltaTime) }
    }

    /// Invokes `start` on all currently tracked tweens.
    func startAll() {
        self.tweens.forEach { $0.start() }
    }

    /// Invokes `stop` on all currently tracked tweens.
    func stopAll() {
        self.tweens.forEach { $0.stop() }
    }

    /// Invokes `stop` on all currently tracked tweens.
    func restartAll() {
        self.tweens.forEach { $0.restart() }
    }

    /// Invokes `pause` on all currently tracked tweens.
    func pauseAll() {
        self.tweens.forEach { $0.pause() }
    }

    /// Invokes `resume` on all currently tracked tweens.
    func resumeAll() {
        self.tweens.forEach { $0.resume() }
    }

    /// Invokes `complete` on all currently tracked tweens.
    func completeAll() {
        self.tweens.forEach { $0.complete() }
    }

    /// Invokes `kill` on all currently tracked tweens.
    func killAll() {
        self.tweens.forEach { $0.kill() }
    }

}
