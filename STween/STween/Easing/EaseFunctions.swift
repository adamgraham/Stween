//
//  EaseFunctions.swift
//  STween
//
//  Created by Adam Graham on 6/15/16.
//  Copyright © 2016 Adam Graham. All rights reserved.
//

/**
 An enum to hold a collection of easing functions based upon
 [Robert Penner's Easing Functions](http://robertpenner.com/easing/). 
 A visualized cheat-sheet of these functions can be found at
 [easings.net](http://easings.net/).

 Easing functions calculate the value between a starting and ending position at a
 specific point in time. In simpler terms, these functions determine the path/motion used
 to get from point *A* to point *B*.

 * * * * *

 > *The aspect of time is crucial to motion — things change over time. Nothing can move in
 > “zero time”, or be in two places at once. In other words, a position needs time to
 > change, and it can have only one value at a specific point in time.*
 >
 > *Because position and time have this one-to-one relationship, we can say that position
 > is a function of time. This means that, given a specific point in time, we can find one,
 > and only one, corresponding position.*
 > \- [Robert Penner](http://robertpenner.com/easing/penner_chapter7_tweening.pdf)
 
 - Parameters:
    - b: The start value (b = begin).
    - c: The change in value (c = change).
    - t: The amount of time elapsed since the start of the ease (t = time).
    - d: The total amount of time the ease will run (d = duration).

 - Returns: The value at a specific point in time from the start value.
 */
internal enum EaseFunctions {}

/**
 A method to calculate a value between a starting and ending position at a specific point
 in time.

 - Parameters:
    - b: The start value (b = begin).
    - c: The change in value (c = change).
    - t: The amount of time elapsed since the start of the ease (t = time).
    - d: The total amount of time the ease will run (d = duration).

 - Returns: The value at a specific point in time from the start value.
 */
public typealias EaseFunction<Number: InterpolatableNumber> = (
    _ b: Number,
    _ c: Number,
    _ t: Number,
    _ d: Number) -> Number

/// An extension to add the linear easing function.
extension EaseFunctions {

    // MARK: Linear

    /**
     The algorithmic function of a `linear` ease used to calculate a value between a
     starting and ending position at a specific point in time.
     
     - Parameters:
        - b: The start value (b = begin).
        - c: The change in value (c = change).
        - t: The amount of time elapsed since the start of the ease (t = time).
        - d: The total amount of time the ease will run (d = duration).
     
     - Returns: The value at a specific point in time from the start value.
     */
    internal static func linear<Number: InterpolatableNumber>(
        b: Number, c: Number, t: Number, d: Number) -> Number {

        let x = t/d
        return c * x + b
    }

}

/// An extension to add the sinusoidal easing functions.
extension EaseFunctions {

    // MARK: Sinusoidal

    /**
     The algorithmic function of a `sineIn` ease used to calculate a value between a
     starting and ending position at a specific point in time.

     - Parameters:
        - b: The start value (b = begin).
        - c: The change in value (c = change).
        - t: The amount of time elapsed since the start of the ease (t = time).
        - d: The total amount of time the ease will run (d = duration).

     - Returns: The value at a specific point in time from the start value.
     */
    internal static func sineIn<Number: InterpolatableNumber>(
        b: Number, c: Number, t: Number, d: Number) -> Number {

        let x = t/d
        let m = cos(x * Number.pi.half)
        return -c * m + c + b
    }

    /**
     The algorithmic function of a `sineOut` ease used to calculate a value between a
     starting and ending position at a specific point in time.

     - Parameters:
        - b: The start value (b = begin).
        - c: The change in value (c = change).
        - t: The amount of time elapsed since the start of the ease (t = time).
        - d: The total amount of time the ease will run (d = duration).

     - Returns: The value at a specific point in time from the start value.
     */
    internal static func sineOut<Number: InterpolatableNumber>(
        b: Number, c: Number, t: Number, d: Number) -> Number {

        let x = t/d
        let m = sin(x * Number.pi.half)
        return c * m + b
    }

    /**
     The algorithmic function of a `sineInOut` ease used to calculate a value between a
     starting and ending position at a specific point in time.

     - Parameters:
        - b: The start value (b = begin).
        - c: The change in value (c = change).
        - t: The amount of time elapsed since the start of the ease (t = time).
        - d: The total amount of time the ease will run (d = duration).

     - Returns: The value at a specific point in time from the start value.
     */
    internal static func sineInOut<Number: InterpolatableNumber>(
        b: Number, c: Number, t: Number, d: Number) -> Number {

        let x = t/d
        let m = cos(x * Number.pi) - Number.const.one
        return -c.half * m + b
    }

}

/// An extension to add the cubic easing functions.
extension EaseFunctions {

    // MARK: Cubic

    /**
     The algorithmic function of a `cubicIn` ease used to calculate a value between a
     starting and ending position at a specific point in time.

     - Parameters:
        - b: The start value (b = begin).
        - c: The change in value (c = change).
        - t: The amount of time elapsed since the start of the ease (t = time).
        - d: The total amount of time the ease will run (d = duration).

     - Returns: The value at a specific point in time from the start value.
     */
    internal static func cubicIn<Number: InterpolatableNumber>(
        b: Number, c: Number, t: Number, d: Number) -> Number {

        let x = t/d
        let m = x*x*x
        return c * m + b
    }

    /**
     The algorithmic function of a `cubicOut` ease used to calculate a value between a
     starting and ending position at a specific point in time.

     - Parameters:
        - b: The start value (b = begin).
        - c: The change in value (c = change).
        - t: The amount of time elapsed since the start of the ease (t = time).
        - d: The total amount of time the ease will run (d = duration).

     - Returns: The value at a specific point in time from the start value.
     */
    internal static func cubicOut<Number: InterpolatableNumber>(
        b: Number, c: Number, t: Number, d: Number) -> Number {

        let x = (t/d) - Number.const.one
        let m = (x*x*x) + Number.const.one
        return c * m + b
    }

    /**
     The algorithmic function of a `cubicInOut` ease used to calculate a value between a
     starting and ending position at a specific point in time.

     - Parameters:
        - b: The start value (b = begin).
        - c: The change in value (c = change).
        - t: The amount of time elapsed since the start of the ease (t = time).
        - d: The total amount of time the ease will run (d = duration).

     - Returns: The value at a specific point in time from the start value.
     */
    internal static func cubicInOut<Number: InterpolatableNumber>(
        b: Number, c: Number, t: Number, d: Number) -> Number {

        var x = t/(d.half)

        if x < Number.const.one {
            let m = x*x*x
            return c.half * m + b
        }

        x -= Number.const.two
        let m = (x*x*x) + Number.const.two
        return c.half * m + b
    }
    
}

/// An extension to add the quadratic easing functions.
extension EaseFunctions {

    // MARK: Quadratic

    /**
     The algorithmic function of a `quadIn` ease used to calculate a value between a
     starting and ending position at a specific point in time.

     - Parameters:
        - b: The start value (b = begin).
        - c: The change in value (c = change).
        - t: The amount of time elapsed since the start of the ease (t = time).
        - d: The total amount of time the ease will run (d = duration).

     - Returns: The value at a specific point in time from the start value.
     */
    internal static func quadIn<Number: InterpolatableNumber>(
        b: Number, c: Number, t: Number, d: Number) -> Number {

        let x = t/d
        let m = x*x
        return c * m + b
    }

    /**
     The algorithmic function of a `quadOut` ease used to calculate a value between a
     starting and ending position at a specific point in time.

     - Parameters:
        - b: The start value (b = begin).
        - c: The change in value (c = change).
        - t: The amount of time elapsed since the start of the ease (t = time).
        - d: The total amount of time the ease will run (d = duration).

     - Returns: The value at a specific point in time from the start value.
     */
    internal static func quadOut<Number: InterpolatableNumber>(
        b: Number, c: Number, t: Number, d: Number) -> Number {

        let x = t/d
        let m = x*(x - Number.const.two)
        return -c * m + b
    }

    /**
     The algorithmic function of a `quadInOut` ease used to calculate a value between a
     starting and ending position at a specific point in time.

     - Parameters:
        - b: The start value (b = begin).
        - c: The change in value (c = change).
        - t: The amount of time elapsed since the start of the ease (t = time).
        - d: The total amount of time the ease will run (d = duration).

     - Returns: The value at a specific point in time from the start value.
     */
    internal static func quadInOut<Number: InterpolatableNumber>(
        b: Number, c: Number, t: Number, d: Number) -> Number {

        var x = t/(d.half)

        if x < Number.const.one {
            let m = x*x
            return c.half * m + b
        }

        x -= Number.const.one
        let m = x*(x - Number.const.two) - Number.const.one
        return -c.half * m + b
    }
    
}

/// An extension to add the quartic easing functions.
extension EaseFunctions {

    // MARK: Quartic

    /**
     The algorithmic function of a `quartIn` ease used to calculate a value between a
     starting and ending position at a specific point in time.

     - Parameters:
        - b: The start value (b = begin).
        - c: The change in value (c = change).
        - t: The amount of time elapsed since the start of the ease (t = time).
        - d: The total amount of time the ease will run (d = duration).

     - Returns: The value at a specific point in time from the start value.
     */
    internal static func quartIn<Number: InterpolatableNumber>(
        b: Number, c: Number, t: Number, d: Number) -> Number {

        let x = t/d
        let m = x*x*x*x
        return c * m + b
    }

    /**
     The algorithmic function of a `quartOut` ease used to calculate a value between a
     starting and ending position at a specific point in time.

     - Parameters:
        - b: The start value (b = begin).
        - c: The change in value (c = change).
        - t: The amount of time elapsed since the start of the ease (t = time).
        - d: The total amount of time the ease will run (d = duration).

     - Returns: The value at a specific point in time from the start value.
     */
    internal static func quartOut<Number: InterpolatableNumber>(
        b: Number, c: Number, t: Number, d: Number) -> Number {

        let x = (t/d) - Number.const.one
        let m = (x*x*x*x) - Number.const.one
        return -c * m + b
    }

    /**
     The algorithmic function of a `quartInOut` ease used to calculate a value between a
     starting and ending position at a specific point in time.

     - Parameters:
        - b: The start value (b = begin).
        - c: The change in value (c = change).
        - t: The amount of time elapsed since the start of the ease (t = time).
        - d: The total amount of time the ease will run (d = duration).

     - Returns: The value at a specific point in time from the start value.
     */
    internal static func quartInOut<Number: InterpolatableNumber>(
        b: Number, c: Number, t: Number, d: Number) -> Number {

        var x = t/(d.half)

        if x < Number.const.one {
            let m = x*x*x*x
            return c.half * m + b
        }

        x -= Number.const.two
        let m = (x*x*x*x) - Number.const.two
        return -c.half * m + b
    }
    
}

/// An extension to add the quintic easing functions.
extension EaseFunctions {

    // MARK: Quintic

    /**
     The algorithmic function of a `quintIn` ease used to calculate a value between a
     starting and ending position at a specific point in time.

     - Parameters:
        - b: The start value (b = begin).
        - c: The change in value (c = change).
        - t: The amount of time elapsed since the start of the ease (t = time).
        - d: The total amount of time the ease will run (d = duration).

     - Returns: The value at a specific point in time from the start value.
     */
    internal static func quintIn<Number: InterpolatableNumber>(
        b: Number, c: Number, t: Number, d: Number) -> Number {

        let x = t/d
        let m = x*x*x*x*x
        return c * m + b
    }

    /**
     The algorithmic function of a `quintOut` ease used to calculate a value between a
     starting and ending position at a specific point in time.

     - Parameters:
        - b: The start value (b = begin).
        - c: The change in value (c = change).
        - t: The amount of time elapsed since the start of the ease (t = time).
        - d: The total amount of time the ease will run (d = duration).

     - Returns: The value at a specific point in time from the start value.
     */
    internal static func quintOut<Number: InterpolatableNumber>(
        b: Number, c: Number, t: Number, d: Number) -> Number {

        let x = (t/d) - Number.const.one
        let m = (x*x*x*x*x) + Number.const.one
        return c * m + b
    }

    /**
     The algorithmic function of a `quintInOut` ease used to calculate a value between a
     starting and ending position at a specific point in time.

     - Parameters:
        - b: The start value (b = begin).
        - c: The change in value (c = change).
        - t: The amount of time elapsed since the start of the ease (t = time).
        - d: The total amount of time the ease will run (d = duration).

     - Returns: The value at a specific point in time from the start value.
     */
    internal static func quintInOut<Number: InterpolatableNumber>(
        b: Number, c: Number, t: Number, d: Number) -> Number {

        var x = t/(d.half)

        if x < Number.const.one {
            let m = x*x*x*x*x
            return c.half * m + b
        }

        x -= Number.const.two
        let m = (x*x*x*x*x) + Number.const.two
        return c.half * m + b
    }
    
}

/// An extension to add the exponential easing functions.
extension EaseFunctions {

    // MARK: Exponential

    /**
     The algorithmic function of an `expoIn` ease used to calculate a value between a
     starting and ending position at a specific point in time.

     - Parameters:
        - b: The start value (b = begin).
        - c: The change in value (c = change).
        - t: The amount of time elapsed since the start of the ease (t = time).
        - d: The total amount of time the ease will run (d = duration).

     - Returns: The value at a specific point in time from the start value.
     */
    internal static func expoIn<Number: InterpolatableNumber>(
        b: Number, c: Number, t: Number, d: Number) -> Number {

        if t.isZero {
            return b
        }

        let x = t/d
        let e = Number.const.ten * (x - Number.const.one)
        let m = pow(Number.const.two, e)
        return c * m + b
    }

    /**
     The algorithmic function of an `expoOut` ease used to calculate a value between a
     starting and ending position at a specific point in time.

     - Parameters:
        - b: The start value (b = begin).
        - c: The change in value (c = change).
        - t: The amount of time elapsed since the start of the ease (t = time).
        - d: The total amount of time the ease will run (d = duration).

     - Returns: The value at a specific point in time from the start value.
     */
    internal static func expoOut<Number: InterpolatableNumber>(
        b: Number, c: Number, t: Number, d: Number) -> Number {

        if t == d {
            return b + c
        }

        let x = t/d
        let e = -Number.const.ten * x
        let m = -pow(Number.const.two, e) + Number.const.one
        return c * m + b
    }

    /**
     The algorithmic function of an `expoInOut` ease used to calculate a value between a
     starting and ending position at a specific point in time.

     - Parameters:
        - b: The start value (b = begin).
        - c: The change in value (c = change).
        - t: The amount of time elapsed since the start of the ease (t = time).
        - d: The total amount of time the ease will run (d = duration).

     - Returns: The value at a specific point in time from the start value.
     */
    internal static func expoInOut<Number: InterpolatableNumber>(
        b: Number, c: Number, t: Number, d: Number) -> Number {

        if t.isZero {
            return b
        } else if t == d {
            return b + c
        }

        var x = t/(d.half)

        if x < Number.const.one {
            let e = Number.const.ten * (x - Number.const.one)
            let m = pow(Number.const.two, e)
            return c.half * m + b
        }

        x -= Number.const.one
        let e = -Number.const.ten * x
        let m = -pow(Number.const.two, e) + Number.const.two
        return c.half * m + b
    }
    
}

/// An extension to add the circular easing functions.
extension EaseFunctions {

    // MARK: Circular

    /**
     The algorithmic function of a `circIn` ease used to calculate a value between a
     starting and ending position at a specific point in time.

     - Parameters:
        - b: The start value (b = begin).
        - c: The change in value (c = change).
        - t: The amount of time elapsed since the start of the ease (t = time).
        - d: The total amount of time the ease will run (d = duration).

     - Returns: The value at a specific point in time from the start value.
     */
    internal static func circIn<Number: InterpolatableNumber>(
        b: Number, c: Number, t: Number, d: Number) -> Number {

        let x = t/d
        let m = sqrt(Number.const.one - (x*x)) - Number.const.one
        return -c * m + b
    }

    /**
     The algorithmic function of a `circOut` ease used to calculate a value between a
     starting and ending position at a specific point in time.

     - Parameters:
        - b: The start value (b = begin).
        - c: The change in value (c = change).
        - t: The amount of time elapsed since the start of the ease (t = time).
        - d: The total amount of time the ease will run (d = duration).

     - Returns: The value at a specific point in time from the start value.
     */
    internal static func circOut<Number: InterpolatableNumber>(
        b: Number, c: Number, t: Number, d: Number) -> Number {

        let x = (t/d) - Number.const.one
        let m = sqrt(Number.const.one - (x*x))
        return c * m + b
    }

    /**
     The algorithmic function of a `circInOut` ease used to calculate a value between a
     starting and ending position at a specific point in time.

     - Parameters:
        - b: The start value (b = begin).
        - c: The change in value (c = change).
        - t: The amount of time elapsed since the start of the ease (t = time).
        - d: The total amount of time the ease will run (d = duration).

     - Returns: The value at a specific point in time from the start value.
     */
    internal static func circInOut<Number: InterpolatableNumber>(
        b: Number, c: Number, t: Number, d: Number) -> Number {

        var x = t/(d.half)

        if x < Number.const.one {
            let m = sqrt(Number.const.one - (x*x)) - Number.const.one
            return -c.half * m + b
        }

        x -= Number.const.two
        let m = sqrt(Number.const.one - (x*x)) + Number.const.one
        return c.half * m + b
    }
    
}

/// An extension to add the back easing functions.
extension EaseFunctions {

    // MARK: Back

    /**
     The algorithmic function of a `backIn` ease used to calculate a value between a
     starting and ending position at a specific point in time.

     - Parameters:
        - b: The start value (b = begin).
        - c: The change in value (c = change).
        - t: The amount of time elapsed since the start of the ease (t = time).
        - d: The total amount of time the ease will run (d = duration).

     - Returns: The value at a specific point in time from the start value.
     */
    internal static func backIn<Number: InterpolatableNumber>(
        b: Number, c: Number, t: Number, d: Number) -> Number {

        let s = Number(Defaults.overshoot)
        let x = t/d
        let e = ((s + Number.const.one) * x) - s
        let m = x*x*e
        return c * m + b
    }

    /**
     The algorithmic function of a `backOut` ease used to calculate a value between a
     starting and ending position at a specific point in time.

     - Parameters:
        - b: The start value (b = begin).
        - c: The change in value (c = change).
        - t: The amount of time elapsed since the start of the ease (t = time).
        - d: The total amount of time the ease will run (d = duration).

     - Returns: The value at a specific point in time from the start value.
     */
    internal static func backOut<Number: InterpolatableNumber>(
        b: Number, c: Number, t: Number, d: Number) -> Number {

        let s = Number(Defaults.overshoot)
        let x = (t/d) - Number.const.one
        let e = ((s + Number.const.one) * x) + s
        let m = (x*x*e) + Number.const.one
        return c * m + b
    }

    /**
     The algorithmic function of a `backInOut` ease used to calculate a value between a
     starting and ending position at a specific point in time.

     - Parameters:
        - b: The start value (b = begin).
        - c: The change in value (c = change).
        - t: The amount of time elapsed since the start of the ease (t = time).
        - d: The total amount of time the ease will run (d = duration).

     - Returns: The value at a specific point in time from the start value.
     */
    internal static func backInOut<Number: InterpolatableNumber>(
        b: Number, c: Number, t: Number, d: Number) -> Number {

        let s = Number(Defaults.overshoot * 1.525)
        var x = t/(d.half)

        if x < Number.const.one {
            let e = ((s + Number.const.one) * x) - s
            let m = x*x*e
            return c.half * m + b
        }

        x -= Number.const.two
        let e = ((s + Number.const.one) * x) + s
        let m = (x*x*e) + Number.const.two
        return c.half * m + b
    }
    
}

/// An extension to add the elastic easing functions.
extension EaseFunctions {

    // MARK: Elastic

    /**
     The algorithmic function of an `elasticIn` ease used to calculate a value between a
     starting and ending position at a specific point in time.

     - Parameters:
        - b: The start value (b = begin).
        - c: The change in value (c = change).
        - t: The amount of time elapsed since the start of the ease (t = time).
        - d: The total amount of time the ease will run (d = duration).

     - Returns: The value at a specific point in time from the start value.
     */
    internal static func elasticIn<Number: InterpolatableNumber>(
        b: Number, c: Number, t: Number, d: Number) -> Number {

        var x = t/d

        if t.isZero {
            return b
        } else if x == Number.const.one {
            return b + c
        }

        let p = d * Number(0.3) // period
        let a = c // amplitude
        let s = p * Number.const.¼
        x -= Number.const.one

        let e1 = Number.const.ten * x
        let m1 = a * pow(Number.const.two, e1)

        let e2 = (x*d) - s
        let m2 = sin(e2 * Number.const.tau / p)

        return -(m1 * m2) + b
    }

    /**
     The algorithmic function of an `elasticOut` ease used to calculate a value between a
     starting and ending position at a specific point in time.

     - Parameters:
        - b: The start value (b = begin).
        - c: The change in value (c = change).
        - t: The amount of time elapsed since the start of the ease (t = time).
        - d: The total amount of time the ease will run (d = duration).

     - Returns: The value at a specific point in time from the start value.
     */
    internal static func elasticOut<Number: InterpolatableNumber>(
        b: Number, c: Number, t: Number, d: Number) -> Number {

        let x = t/d

        if t.isZero {
            return b
        } else if x == Number.const.one {
            return b + c
        }

        let p = d * Number(0.3) // period
        let a = c // amplitude
        let s = p * Number.const.¼

        let e1 = -Number.const.ten * x
        let m1 = a * pow(Number.const.two, e1)

        let e2 = (x*d) - s
        let m2 = sin(e2 * Number.const.tau / p)

        return c + (m1 * m2) + b
    }

    /**
     The algorithmic function of an `elasticInOut` ease used to calculate a value between a
     starting and ending position at a specific point in time.

     - Parameters:
        - b: The start value (b = begin).
        - c: The change in value (c = change).
        - t: The amount of time elapsed since the start of the ease (t = time).
        - d: The total amount of time the ease will run (d = duration).

     - Returns: The value at a specific point in time from the start value.
     */
    internal static func elasticInOut<Number: InterpolatableNumber>(
        b: Number, c: Number, t: Number, d: Number) -> Number {

        var x = t/(d.half)

        if t.isZero {
            return b
        } else if x == Number.const.two {
            return b + c
        }

        let p = d * Number(0.45) // period
        let a = c // amplitude
        let s = p * Number.const.¼

        if x < Number.const.one {
            x -= Number.const.one

            let e1 = Number.const.ten * x
            let m1 = a * pow(Number.const.two, e1)

            let e2 = (x*d) - s
            let m2 = sin(e2 * Number.const.tau / p)

            return -(m1 * m2).half + b
        }

        x -= Number.const.one

        let e1 = -Number.const.ten * x
        let m1 = a * pow(Number.const.two, e1)

        let e2 = (x*d) - s
        let m2 = sin(e2 * Number.const.tau / p)

        return c + (m1 * m2).half + b
    }
    
}

/// An extension to add the bounce easing functions.
extension EaseFunctions {

    // MARK: Bounce

    /**
     The algorithmic function of a `bounceIn` ease used to calculate a value between a
     starting and ending position at a specific point in time.

     - Parameters:
        - b: The start value (b = begin).
        - c: The change in value (c = change).
        - t: The amount of time elapsed since the start of the ease (t = time).
        - d: The total amount of time the ease will run (d = duration).

     - Returns: The value at a specific point in time from the start value.
     */
    internal static func bounceIn<Number: InterpolatableNumber>(
        b: Number, c: Number, t: Number, d: Number) -> Number {

        let m = EaseFunctions.bounceOut(b: Number.const.zero, c: c, t: d-t, d: d)
        return c - m + b
    }

    /**
     The algorithmic function of a `bounceOut` ease used to calculate a value between a
     starting and ending position at a specific point in time.

     - Parameters:
        - b: The start value (b = begin).
        - c: The change in value (c = change).
        - t: The amount of time elapsed since the start of the ease (t = time).
        - d: The total amount of time the ease will run (d = duration).

     - Returns: The value at a specific point in time from the start value.
     */
    internal static func bounceOut<Number: InterpolatableNumber>(
        b: Number, c: Number, t: Number, d: Number) -> Number {

        var x = t/d
        let e: Number

        if x < Number(1.0 / 2.75) {
            e = Number.const.zero
        } else if x < Number(2.0 / 2.75) {
            x -= Number(1.5 / 2.75)
            e = Number.const.¾
        } else if x < Number(2.5 / 2.75) {
            x -= Number(2.25 / 2.75)
            e = Number(0.9375)
        } else {
            x -= Number(2.625 / 2.75)
            e = Number(0.984375)
        }

        let m = (Number(7.5625) * (x*x)) + e
        return c * m + b
    }

    /**
     The algorithmic function of a `bounceInOut` ease used to calculate a value between a
     starting and ending position at a specific point in time.

     - Parameters:
        - b: The start value (b = begin).
        - c: The change in value (c = change).
        - t: The amount of time elapsed since the start of the ease (t = time).
        - d: The total amount of time the ease will run (d = duration).

     - Returns: The value at a specific point in time from the start value.
     */
    internal static func bounceInOut<Number: InterpolatableNumber>(
        b: Number, c: Number, t: Number, d: Number) -> Number {

        if t < (d.half) {
            let m = EaseFunctions.bounceIn(b: Number.const.zero, c: c, t: t.double, d: d).half
            return m + b
        }

        let m = (EaseFunctions.bounceOut(b: Number.const.zero, c: c, t: (t.double)-d, d: d).half) + c.half
        return m + b
    }
    
}
