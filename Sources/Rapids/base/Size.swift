//
// Created by Jascha MERLE on 06/08/2023.
//

import Foundation

/// Defines a size.
public struct Size: Equatable, Hashable {

    /// A size representing infinity.
    public static let Infinity: Size = Size(Double.infinity, Double.infinity)

    /// The width.
    private let width: Double

    /// The height.
    private let height: Double

    /// Initializes a new instance of the ``Size`` structure.
    /// - Parameters:
    ///   - width: The width.
    ///   - height: The height.
    public init(_ width: Double, _ height: Double) {
        self.width = width
        self.height = height
    }

    /// Gets the aspect ratio of the size.
    public var AspectRatio: Double {
        get {
            width / height
        }
    }

    /// Gets the width.
    public var Width: Double {
        get {
            width
        }
    }

    /// Gets the height.
    public var Height: Double {
        get {
            height
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
        Size(size.Width * scale.X, size.Height * scale.Y)
    }

    /// Scales a size.
    /// - Parameters:
    ///   - size: The size
    ///   - scale: The scaling factor.
    /// - Returns: The scaled size.
    public static func /(_ size: Size, _ scale: Vector) -> Size {
        Size(size.width / scale.X, size.height / scale.Y)
    }

    /// Divides a size by another size to produce a scaling factor.
    /// - Parameters:
    ///   - left: The first size.
    ///   - right: The second size.
    /// - Returns: The scaled size.
    public static func /(_ left: Size, _ right: Size) -> Vector {
        Vector(left.width / right.width, left.height / right.height)
    }

    /// Scales a size.
    /// - Parameters:
    ///   - size: The size
    ///   - scale: The scaling factor.
    /// - Returns: The scaled size.
    public static func *(_ size: Size, _ scale: Double) -> Size {
        Size(size.width * scale, size.height * scale)
    }

    /// Scales a size.
    /// - Parameters:
    ///   - size: The size
    ///   - scale: The scaling factor.
    /// - Returns: The scaled size.
    public static func /(_ size: Size, _ scale: Double) -> Size {
        Size(size.width / scale, size.height / scale)
    }

    /// Adds two sizes (widths and heights are added to each other respectively).
    /// - Parameters:
    ///   - size: The size
    ///   - toAdd: The size to add.
    /// - Returns: The sum of the sizes.
    public static func +(_ size: Size, _ toAdd: Size) -> Size {
        Size(size.width + toAdd.width, size.height + toAdd.height)
    }

    /// Subtracts two sizes (widths and heights are subtracted from each other respectively).
    /// - Parameters:
    ///   - size: The size
    ///   - toSubtract: The size to subtract.
    /// - Returns: The difference of the sizes.
    public static func -(_ size: Size, _ toSubtract: Size) -> Size {
        Size(size.width - toSubtract.width, size.height - toSubtract.height)
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
        let constrainedWidth: Double = min(width, constraint.width)
        let constrainedHeight: Double = min(height, constraint.height)

        return Size(constrainedWidth, constrainedHeight)
    }

    /// Deflates the size by a ``Thickness``
    /// - Parameter thickness: The thickness.
    /// - Returns: The deflated size.
    /// - Remark: The deflated size cannot be less than 0.
    public func deflate(_ thickness: Thickness) -> Size {
        let deflatedWidth: Double = max(0, width - thickness.left - thickness.right)
        let deflatedHeight: Double = max(0, height - thickness.top - thickness.bottom)

        return Size(deflatedWidth, deflatedHeight)
    }

    /// Returns a boolean indicating whether the size is equal to the other given size (bitwise).
    /// - Parameter other: The other size to test equality against.
    /// - Returns: True if this size is equal to other; False otherwise.
    public func equals(_ other: Size) -> Bool {
        other.width == width && other.height == height
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
        areClose(width, other.width) && areClose(height, other.height)
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

        hash = (hash * 23) + width.hashValue
        hash = (hash * 23) + height.hashValue

        return hash
    }

    /// Inflates the size by a ``Thickness``.
    /// - Parameter thickness: The thickness.
    /// - Returns: The inflated size.
    public func inflate(_ thickness: Thickness) -> Size {
        let inflatedWidth: Double = width + thickness.left + thickness.right
        let inflatedHeight: Double = height + thickness.top + thickness.bottom

        return Size(inflatedWidth, inflatedHeight)
    }

    /// Returns a new ``Size``with the same height and specified width.
    /// - Parameter width: The width.
    /// - Returns: The new ``Size``.
    public func withWidth(_ width: Double) -> Size {
        Size(width, height)
    }

    /// Returns a new ``Size``with the same width and specified height.
    /// - Parameter height: The height.
    /// - Returns: The new ``Size``.
    public func withHeight(_ height: Double) -> Size {
        Size(width, height)
    }

    /// Returns the string representation of the size.
    /// - Returns: The string representation of the size.
    public func toString() -> String {
        "\(width), \(height)"
    }

    /// Deconstructs the size into its Width and Height values.
    /// - Parameters:
    ///   - width: The width.
    ///   - height: The height.
    public func deconstruct(width: inout Double, height: inout Double) {
        width = self.width
        height = self.height
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(width)
        hasher.combine(height)
    }
}
