//
// Created by Jascha MERLE on 07/08/2023.
//

import Foundation

/// Describes the thickness of a frame around a rectangle.
public struct Thickness: Equatable, Hashable {

    /// The left thickness.
    private let _left: Double

    /// The top thickness.
    private let _top: Double

    /// The right thickness.
    private let _right: Double

    /// The bottom thickness.
    private let _bottom: Double

    /// Initializes a new instance of the ``Thickness`` structure.
    /// - Parameter uniformLength: The uniform length (the left, top, right and bottom thicknesses).
    public init(_ uniformLength: Double) {
        _left = uniformLength
        _top = uniformLength
        _right = uniformLength
        _bottom = uniformLength
    }

    /// Initializes a new instance of the ``Thickness`` structure.
    /// - Parameters:
    ///   - horizontal: The horizontal thickness (the left and right thicknesses).
    ///   - vertical: The vertical thickness (the top and bottom thicknesses).
    public init(_ horizontal: Double, _ vertical: Double) {
        _left = horizontal
        _top = vertical
        _right = horizontal
        _bottom = vertical
    }

    /// Initializes a new instance of the ``Thickness`` structure.
    /// - Parameters:
    ///   - left: The left thickness.
    ///   - top: The top thickness.
    ///   - right: The right thickness.
    ///   - bottom: The bottom thickness.
    public init(_ left: Double, _ top: Double, _ right: Double, _ bottom: Double) {
        _left = left
        _top = top
        _right = right
        _bottom = bottom
    }

    /// Gets the left thickness.
    public var left: Double {
        get {
            _left
        }
    }

    /// Gets the top thickness.
    public var top: Double {
        get {
            _top
        }
    }

    /// Gets the right thickness.
    public var right: Double {
        get {
            _right
        }
    }

    /// Gets the bottom thickness.
    public var bottom: Double {
        get {
            _bottom
        }
    }

    /// Gets a value indicating whether the thickness is uniform (the left, top, right and bottom thicknesses are equal).
    public var IsUniform: Bool {
        get {
            _left == _right && _top == _bottom && _right == _bottom
        }
    }

    /// Checks for equality between two ``Thickness`` structs.
    /// - Parameters:
    ///   - left: The first thickness.
    ///   - right: The second thickness.
    /// - Returns: True if the thicknesses are equal; otherwise false.
    public static func ==(_ left: Thickness, _ right: Thickness) -> Bool {
        left.equals(right)
    }

    /// Checks for inequality between two ``Thickness`` structs.
    /// - Parameters:
    ///   - left: The first thickness.
    ///   - right: The second thickness.
    /// - Returns: True if the thicknesses are not equal; otherwise false.
    public static func !=(_ left: Thickness, _ right: Thickness) -> Bool {
        !left.equals(right)
    }

    /// Adds two ``Thickness`` structs.
    /// - Parameters:
    ///   - left: The first thickness.
    ///   - right: The second thickness.
    /// - Returns: The sum of the two thicknesses.
    public static func +(_ left: Thickness, _ right: Thickness) -> Thickness {
        Thickness(left._left + right._left, left._top + right._top, left._right + right._right, left._bottom + right._bottom)
    }

    /// Subtracts two ``Thickness`` structs.
    /// - Parameters:
    ///   - left: The first thickness.
    ///   - right: The second thickness.
    /// - Returns: The difference between the two thicknesses.
    public static func -(_ left: Thickness, _ right: Thickness) -> Thickness {
        Thickness(left._left - right._left, left._top - right._top, left._right - right._right, left._bottom - right._bottom)
    }

    /// Multiplies a ``Thickness`` struct by a scalar.
    /// - Parameters:
    ///   - left: The thickness.
    ///   - right: The scalar.
    /// - Returns: The product of the thickness and the scalar.
    public static func *(_ left: Thickness, _ right: Double) -> Thickness {
        Thickness(left._left * right, left._top * right, left._right * right, left._bottom * right)
    }

    /// Adds a ``Thickness`` to a ``Size``.
    /// - Parameters:
    ///   - left: The thickness.
    ///   - right: The size.
    /// - Returns: The sum of the thickness and the size.
    public static func +(_ left: Thickness, _ right: Size) -> Size {
        Size(left._left + right.Width + left._right, left._top + right.Height + left._bottom)
    }

    /// Subtracts a ``Thickness`` from a ``Size``.
    /// - Parameters:
    ///   - left: The thickness.
    ///   - right: The size.
    /// - Returns: The difference between the thickness and the size.
    public static func -(_ left: Thickness, _ right: Size) -> Size {
        Size(left._left - right.Width - left._right, left._top - right.Height - left._bottom)
    }

    /// Parses a ``Thickness`` string.
    /// - Parameter s: The string to parse.
    /// - Returns: The parsed ``Thickness``.
    /// - Throws: A ``ThicknessSize.invalidSize`` error if the string is not a valid ``Thickness``.
    public static func parse(_ s: String) throws -> Thickness {
        let components = s.components(separatedBy: ", ")
        if components.count == 1 {
            if let uniformLength = Double(components[0]) {
                return Thickness(uniformLength)
            }
        } else if components.count == 2 {
            if let horizontal = Double(components[0]),
               let vertical = Double(components[1]) {
                return Thickness(horizontal, vertical)
            }
        } else if components.count == 4 {
            if let left = Double(components[0]),
               let top = Double(components[1]),
               let right = Double(components[2]),
               let bottom = Double(components[3]) {
                return Thickness(left, top, right, bottom)
            }
        }

        throw ThicknessError.invalidThicknessString
    }

    /// Checks for equality between this ``Thickness`` and another ``Thickness``.
    /// - Parameter other: The other ``Thickness``.
    /// - Returns: True if the thicknesses are equal; otherwise false.
    public func equals(_ other: Thickness) -> Bool {
        _left == other._left && _top == other._top && _right == other._right && _bottom == other._bottom
    }

    /// Checks for equality between this ``Thickness`` and another object.
    /// - Parameter obj: The other object.
    /// - Returns: True if the object is a ``Thickness`` and the thicknesses are equal; otherwise false.
    public func equals(_ obj: Any?) -> Bool {
        if let other = obj as? Thickness {
            return equals(other)
        }
        return false
    }


    public func hash(into hasher: inout Hasher) {
        hasher.combine(_left)
        hasher.combine(_top)
        hasher.combine(_right)
        hasher.combine(_bottom)
    }

    /// Gets the hash code of this ``Thickness``.
    /// - Returns: The hash code.
    public func getHashCode() -> Int {
        var hasher = Hasher()
        hasher.combine(_left)
        hasher.combine(_top)
        hasher.combine(_right)
        hasher.combine(_bottom)
        return hasher.finalize()
    }

    /// Gets a string representation of this ``Thickness``.
    /// - Returns: The string representation.
    public func toString() -> String {
        "\(_left), \(_top), \(_right), \(_bottom)"
    }

    /// Deconstructs this ``Thickness`` into its components.
    /// - Parameters:
    ///   - left: The left thickness.
    ///   - top: The top thickness.
    ///   - right: The right thickness.
    ///   - bottom: The bottom thickness.
    public func deconstruct(_ left: inout Double, _ top: inout Double, _ right: inout Double, _ bottom: inout Double) {
        left = _left
        top = _top
        right = _right
        bottom = _bottom
    }
}
