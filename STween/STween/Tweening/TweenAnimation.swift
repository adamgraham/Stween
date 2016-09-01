//
//  TweenAnimation.swift
//  STween
//
//  Created by Adam Graham on 6/16/16.
//  Copyright © 2016 Adam Graham. All rights reserved.
//

/**
 A class to animate properties on a `Tweenable` object via interpolation 
 and easing algorithms.
 */
internal final class TweenAnimation<TweenableTarget: Tweenable>: Tween {

    // MARK: Core Properties

    /// The object or data structure that properties are animated on.
    internal let target: TweenableTarget

    /// The array of properties being animated.
    internal let targetProperties: [TweenableTarget.PropertyType]

    /// An array of data needed to interpolate each property every update cycle.
    fileprivate var tweeningData = [TweenInterpolationData]()

    /// A dictionary storing the callbacks for each change of state.
    fileprivate var callbacks = [TweenStateChange: Callback?]()

    // MARK: Animation & State Properties

    internal var ease = Defaults.ease

    internal var reversed = Defaults.reversed
    
    internal fileprivate(set) var state = TweenState.new

    // MARK: Time Properties

    /**
     The internal timer of `self` used to keep track of total elapsed time and 
     fire update cycles. The rate at which the timer updates is based on
     `FrameRate.targetFrameRate`.
     */
    fileprivate lazy var timer: TweenTimer = TweenTimer(delegate: self)
    
    internal var delay = Defaults.delay

    internal var duration: Foundation.TimeInterval

    internal var elapsed: Foundation.TimeInterval {
        return self.state == .completed ? self.duration : self.timer.elapsed
    }

    // MARK: Initialization

    /**
     An initializer to create a `TweenAnimation` with a target object or data 
     structure, an array of properties to be animated, and a duration.
     
     - Parameters:
        - target: The object or data structure that properties are updated on.
        - properties: An array of properties to be animated on the `target`.
        - duration: The total amount of time, in seconds, the animation will run.
     */
    internal init(target: TweenableTarget,
                  properties: [TweenableTarget.PropertyType],
                  duration: Foundation.TimeInterval) {

        self.target = target
        self.duration = duration
        self.targetProperties = properties
    }

}

// MARK: - Tweening

extension TweenAnimation {

    /**
     A method to update all of `self`'s target properties by interpolating
     new values. `self` will be completed if its elapsed time has
     reached or exceeded its duration.

     **Note:** `self` can only be updated if in an active state.
     
     - Parameters:
        - completion: An optional callback invoked if `self` is updated
                      successfully.
     
     - Returns: `true` if `self` is updated successfully.
     */
    @discardableResult internal func update(_ completion: Callback? = nil) -> Swift.Bool {
        guard self.state.canUpdate else {
            return false
        }

        if self.elapsed < self.duration {
            updateProperties()
            callback(invoke: .update)
        } else {
            callback(invoke: .update)
            complete()
        }

        completion?()

        return true
    }

    /**
     A method to interpolate all of `self`'s target properties, based on its
     current state, and assign the interpolated values to the target.
     */
    fileprivate func updateProperties() {
        let elapsed = self.elapsed

        do {
            for data in self.tweeningData {
                guard let property = data.property as? TweenableTarget.PropertyType else {
                    continue
                }

                let interpolatedValue = try data.startValue.interpolate(with: self.ease,
                                                                        endValue: data.endValue,
                                                                        elapsed: elapsed,
                                                                        duration: self.duration)


                try self.target.tweenableValue(set: property, newValue: interpolatedValue)
            }
        } catch {
            // ignore exceptions
        }
    }

    /**
     A method to store all the necessary data needed to interpolate each
     target property. If `self` is reversed, the start and end value will be
     flipped with each other.
     */
    fileprivate func storeStartingAndEndingValues() {
        self.tweeningData.removeAll()

        for property in self.targetProperties {
            guard let tweenableProperty = property as? TweenableProperty else {
                continue
            }

            let startValue = self.target.tweenableValue(get: property)
            let data: TweenInterpolationData

            if !self.reversed {
                data = TweenInterpolationData(property: tweenableProperty,
                                              startValue: startValue,
                                              endValue: tweenableProperty.interpolationValue)
            } else {
                data = TweenInterpolationData(property: tweenableProperty,
                                              startValue: tweenableProperty.interpolationValue,
                                              endValue: startValue)
            }
            
            self.tweeningData.append(data)
        }
    }

}

// MARK: - State Control

extension TweenAnimation {

    /**
     A method to set `self` as active, starting from its beginning values.

     **Note:** `self` can only be started if in a new or inactive state.

     - Parameters:
        - completion: An optional callback invoked if `self` is started
                      successfully.
     
     - Returns: `true` if `self` is started successfully.
     */
    @discardableResult internal func start(_ completion: Callback? = nil) -> Swift.Bool {
        guard self.state.canStart else {
            return false
        }

        // Store property values
        storeStartingAndEndingValues()

        // Set state
        self.state = .active

        // Update timer
        self.timer.reset()
        self.timer.start()

        // Callback event
        callback(invoke: .start)

        // Completion
        completion?()

        return true
    }

    /**
     A method to set `self` as inactive, resetting to its beginning values.

     **Note:** `self` can only be stopped if in an active or paused state.

     - Parameters:
        - completion: An optional callback invoked if `self` is stopped
                      successfully.
     
     - Returns: `true` if `self` is stopped successfully.
     */
    @discardableResult internal func stop(_ completion: Callback? = nil) -> Swift.Bool {
        guard self.state.canStop else {
            return false
        }

        // Set state
        self.state = .inactive

        // Update timer
        self.timer.stop()
        self.timer.reset()

        // Callback event
        callback(invoke: .stop)

        // Completion
        completion?()

        return true
    }

    /**
     A method to stop `self`, then immediately start `self` from its beginning
     values.

     **Note:** `self` can only be restarted if in an active, paused, or completed 
     state.

     - Parameters:
        - completion: An optional callback invoked if `self` is restarted
                      successfully.
     
     - Returns: `true` if `self` is restarted successfully.
     */
    @discardableResult internal func restart(_ completion: Callback? = nil) -> Swift.Bool {
        guard self.state.canRestart else {
            return false
        }

        stop()

        // Callback event
        callback(invoke: .restart)

        start()

        // Completion
        completion?()

        return true
    }

    /**
     A method to set `self` as paused, maintaining its current values.

     **Note:** `self` can only be paused if in an active state.

     - Parameters:
        - completion: An optional callback invoked if `self` is paused
                      successfully.
     
     - Returns: `true` if `self` is paused successfully.
     */
    @discardableResult internal func pause(_ completion: Callback? = nil) -> Swift.Bool {
        guard self.state.canPause else {
            return false
        }

        // Update state
        self.state = .paused

        // Update timer
        self.timer.stop()

        // Callback event
        callback(invoke: .pause)

        // Completion
        completion?()

        return true
    }

    /**
     A method to set `self` as active, maintaining its values from when it was
     paused.

     **Note:** `self` can only be resumed if in a paused state.

     - Parameters:
        - completion: An optional callback invoked if `self` is resumed
                      successfully.
     
     - Returns: `true` if `self` is resumed successfully.
     */
    @discardableResult internal func resume(_ completion: Callback? = nil) -> Swift.Bool {
        guard self.state.canResume else {
            return false
        }

        // Update state
        self.state = .active

        // Update timer
        self.timer.start()

        // Callback event
        callback(invoke: .resume)

        // Completion
        completion?()

        return true
    }

    /**
     A method to set `self` as completed, jumping to its ending values. `self`
     will be killed if `Defaults.autoKillCompletedTweens` is `true`.

     **Note:** `self` can only be completed if in an active or paused state.

     - Parameters:
        - completion: An optional callback invoked if `self` is completed
                      successfully.
     
     - Returns: `true` if `self` is completed successfully.
     */
    @discardableResult internal func complete(_ completion: Callback? = nil) -> Swift.Bool {
        guard self.state.canComplete else {
            return false
        }

        // Set state
        self.state = .completed

        // Update timer
        self.timer.stop()
        self.timer.elapsed = self.duration

        // Update properties
        updateProperties()

        // Callback event
        callback(invoke: .complete)

        // Kill, if necessary
        if Defaults.autoKillCompletedTweens {
            kill()
        }

        // Completion
        completion?()

        return true
    }

    /**
     A method to set `self` as killed, haulting at its current values, and
     remove it from `Tweener`'s list of tracked tweens.

     **Note:** `self` can only be killed if *not* already in a killed state.

     - Parameters:
        - completion: An optional callback invoked if `self` is killed
                      successfully.
     
     - Returns: `true` if `self` is killed successfully.
     */
    @discardableResult internal func kill(_ completion: Callback? = nil) -> Swift.Bool {
        guard self.state.canKill else {
            return false
        }

        // Set state
        self.state = .killed

        // Update timer
        self.timer.stop()

        // Remove from Tweener
        Tweener.remove(self)

        // Callback event
        callback(invoke: .kill)

        // Completion
        completion?()

        return true
    }

    /**
     A method to set `self` as new, resetting all properties to their default
     values, and re-adding `self` to `Tweener`'s list of tracked tweens. This is
     the only way to revive a killed `self`.

     **Note:** `self` can only be reset if *not* already in a new state.

     - Parameters:
        - completion: An optional callback invoked if `self` is reset
                      successfully.
     
     - Returns: `true` if `self` is reset successfully.
     */
    @discardableResult internal func reset(_ completion: Callback? = nil) -> Swift.Bool {
        guard self.state.canReset else {
            return false
        }

        // Set state
        self.state = .new

        // Default properties
        self.tweeningData = []
        self.reversed = false
        self.ease = Defaults.ease
        self.delay = Defaults.delay
        
        // Update timer
        self.timer.stop()
        self.timer.reset()
        
        // Add to Tweener
        Tweener.add(self)
        
        // Callback event
        callback(invoke: .reset)
        self.callbacks.removeAll()
        
        // Completion
        completion?()

        return true
    }

}

// MARK: - Invocation

extension TweenAnimation {

    internal func invoke(_ stateChange: TweenStateChange) -> Swift.Bool {
        return invoke(stateChange, completion: nil)
    }

    internal func invoke(_ stateChange: TweenStateChange, completion: Callback? = nil) -> Swift.Bool {
        switch stateChange {
        case .start:
            return start(completion)
        case .stop:
            return stop(completion)
        case .restart:
            return restart(completion)
        case .pause:
            return pause(completion)
        case .resume:
            return resume(completion)
        case .complete:
            return complete(completion)
        case .kill:
            return kill(completion)
        case .reset:
            return reset(completion)
        case .update:
            return update(completion)
        }
    }

}

// MARK: - Callbacks

extension TweenAnimation {

    internal func callback(get stateChange: TweenStateChange) -> Callback? {
        return self.callbacks[stateChange] ?? nil
    }

    internal func callback(set stateChange: TweenStateChange, value: Callback?) {
        self.callbacks[stateChange] = value
    }

    internal func callback(clear stateChange: TweenStateChange) {
        callback(set: stateChange, value: nil)
    }

    /**
     A method to invoke the callback assigned to a change of state.

     - Parameters:
        - stateChange: The change of state to which its callback will be
                       invoked.
     */
    fileprivate func callback(invoke stateChange: TweenStateChange) {
        callback(get: stateChange)?()
    }
    
}

// MARK: - TweenTimerDelegate

extension TweenAnimation: TweenTimerDelegate {

    internal func tweenTimer(_ timer: TweenTimer, didUpdateWithElapsedTime elapsed: Foundation.TimeInterval) {
        update()
    }

}

// MARK: - TweenInterpolationData Declaration

internal struct TweenInterpolationData {

    /// The property being interpolated.
    internal let property: TweenableProperty
    /// The start value of the property.
    internal let startValue: InterpolationValue
    /// The end value of the property.
    internal let endValue: InterpolationValue

}
