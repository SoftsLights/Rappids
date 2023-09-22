//
// Created by Jascha MERLE on 06/08/2023.
//

import Foundation

/// Defines a size.
public struct Size: Equatable, Hashable {

    /// A size representing infinity.
    public static let Infinity: Size = Size(Double.infinity, Double.infinity)

    /// The width.
    private let _width: Double

    /// The height.
    private let _height: Double

    /// Initializes a new instance of the ``Size`` structure.
    /// - Parameters:
    ///   - width: The width.
    ///   - height: The height.
    public init(_ width: Double, _ height: Double) {
        _width = width
        _height = height
    }

    /// Gets the aspect ratio of the size.
    public var AspectRatio: Double {
        get {
            _width / _height
        }
    }

    /// Gets the width.
    public var width: Double {
        get {
            _width
        }
    }

    /// Gets the height.
    public var height: Double {
        get {
            _height
        }
    }

    /// Checks for equality between two ``Size`` structs.
    /// - Parameters:
    ///   - left: The first size.
    ///   - right: The second size.
    /// - Returns: True if the sizes are equal; otherwise false.
    public static func ==(_ left: Size, _ right: Size) -> Bool {
        left.equals(right)
    }

    /// Checks for inequality between two ``Size`` structs.
    /// - Parameters:
    ///   - left: The first size.
    ///   - right: The second size.
    /// - Returns: True if the sizes are unequal; otherwise false.
    public static func !=(_ left: Size, _ right: Size) -> Bool {
        !(left == right)
    }

    /// Scales a size.
    /// - Parameters:
    ///   - size: The size
    ///   - scale: The scaling factor.
    /// - Returns: The scaled size.
    public static func *(_ size: Size, _ scale: Vector) -> Size {
        Size(size.width * scale.X, size.height * scale.Y)
    }

    /// Scales a size.
    /// - Parameters:
    ///   - size: The size
    ///   - scale: The scaling factor.
    /// - Returns: The scaled size.
    public static func /(_ size: Size, _ scale: Vector) -> Size {
        Size(size._width / scale.X, size._height / scale.Y)
    }

    /// Divides a size by another size to produce a scaling factor.
    /// - Parameters:
    ///   - left: The first size.
    ///   - right: The second size.
    /// - Returns: The scaled size.
    public static func /(_ left: Size, _ right: Size) -> Vector {
        Vector(left._width / right._width, left._height / right._height)
    }

    /// Scales a size.
    /// - Parameters:
    ///   - size: The size
    ///   - scale: The scaling factor.
    /// - Returns: The scaled size.
    public static func *(_ size: Size, _ scale: Double) -> Size {
        Size(size._width * scale, size._height * scale)
    }

    /// Scales a size.
    /// - Parameters:
    ///   - size: The size
    ///   - scale: The scaling factor.
    /// - Returns: The scaled size.
    public static func /(_ size: Size, _ scale: Double) -> Size {
        Size(size._width / scale, size._height / scale)
    }

    /// Adds two sizes (widths and heights are added to each other respectively).
    /// - Parameters:
    ///   - size: The size
    ///   - toAdd: The size to add.
    /// - Returns: The sum of the sizes.
    public static func +(_ size: Size, _ toAdd: Size) -> Size {
        Size(size._width + toAdd._width, size._height + toAdd._height)
    }

    /// Subtracts two sizes (widths and heights are subtracted from each other respectively).
    /// - Parameters:
    ///   - size: The size
    ///   - toSubtract: The size to subtract.
    /// - Returns: The difference of the sizes.
    public static func -(_ size: Size, _ toSubtract: Size) -> Size {
        Size(size._width - toSubtract._width, size._height - toSubtract._height)
    }

    /// Parses a ``Size`` string.
    /// - Parameter s: The string.
    /// - Returns: The ``Size``.
    public static func parse(_ s: String) throws -> Size {
        let components = s.components(separatedBy: ", ")
        guard components.count == 2,
              let width = Double(components[0]),
              let height = Double(components[1])
        else {
            throw SizeError.invalidSizeString
        }

        return Size(width, height)
    }

    /// Constraints the size.
    /// - Parameters:
    ///   - constraint: The size to constraint to.
    /// - Returns: The constrained size.
    public func constrain(_ constraint: Size) -> Size {
        let constrainedWidth: Double = min(_width, constraint._width)
        let constrainedHeight: Double = min(_height, constraint._height)

        return Size(constrainedWidth, constrainedHeight)
    }

    /// Deflates the size by a ``Thickness``
    /// - Parameter thickness: The thickness.
    /// - Returns: The deflated size.
    /// - Remark: The deflated size cannot be less than 0.
    public func deflate(_ thickness: Thickness) -> Size {
        let deflatedWidth: Double = max(0, _width - thickness.left - thickness.right)
        let deflatedHeight: Double = max(0, _height - thickness.top - thickness.bottom)

        return Size(deflatedWidth, deflatedHeight)
    }

    /// Returns a boolean indicating whether the size is equal to the other given size (bitwise).
    /// - Parameter other: The other size to test equality against.
    /// - Returns: True if this size is equal to other; False otherwise.
    public func equals(_ other: Size) -> Bool {
        other._width == _width && other._height == _height
    }

    /// This function determines if two `Double` values are approximately equal within a certain tolerance.
    /// - Parameters:
    ///   - a: The first `Double` value to be compared.
    ///   - b: The second `Double` value to be compared.
    ///   - tolerance: The margin within which the two numbers can differ but still be considered equal.
    /// By default, this value is the square root of the smallest positive number that can be represented uniquely by a `Double`.
    /// - Returns: A Boolean value indicating whether `a` and `b` are close.
    /// `true` if the difference between `a` and `b` is less than or equal to the `tolerance`, `false` otherwise.
    private func areClose(_ a: Double, _ b: Double, tolerance: Double = .ulpOfOne.squareRoot()) -> Bool {
        abs(a - b) <= tolerance
    }

    /// Returns a boolean indicating whether the size is equal to the other given size (numerically).
    /// - Parameter other: The other size to test equality against.
    /// - Returns: True if this size is equal to other; False otherwise.
    public func nearlyEquals(_ other: Size) -> Bool {
        areClose(_width, other._width) && areClose(_height, other._height)
    }

    /// Checks for equality between a size and an object.
    /// - Parameter obj: The object.
    /// - Returns: True if `obj` is a size that equals the current size.
    public func equals(_ obj: AnyObject?) -> Bool {
        guard let other = obj as? Size else {
            return false
        }

        return equals(other)
    }

    /// Returns a hash code for a `Size`.
    /// - Returns: The hash code.
    public func getHashCode() -> Int {
        var hash: Int = 17

        hash = (hash * 23) + _width.hashValue
        hash = (hash * 23) + _height.hashValue

        return hash
    }

    /// Inflates the size by a ``Thickness``.
    /// - Parameter thickness: The thickness.
    /// - Returns: The inflated size.
    public func inflate(_ thickness: Thickness) -> Size {
        let inflatedWidth: Double = _width + thickness.left + thickness.right
        let inflatedHeight: Double = _height + thickness.top + thickness.bottom

        return Size(inflatedWidth, inflatedHeight)
    }

    /// Returns a new ``Size``with the same height and specified width.
    /// - Parameter width: The width.
    /// - Returns: The new ``Size``.
    public func withWidth(_ width: Double) -> Size {
        Size(width, _height)
    }

    /// Returns a new ``Size``with the same width and specified height.
    /// - Parameter height: The height.
    /// - Returns: The new ``Size``.
    public func withHeight(_ height: Double) -> Size {
        Size(_width, height)
    }

    /// Returns the string representation of the size.
    /// - Returns: The string representation of the size.
    public func toString() -> String {
        "\(_width), \(_height)"
    }

    /// Deconstructs the size into its Width and Height values.
    /// - Parameters:
    ///   - width: The width.
    ///   - height: The height.
    public func deconstruct(width: inout Double, height: inout Double) {
        width = self._width
        height = self._height
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(_width)
        hasher.combine(_height)
    }
}
