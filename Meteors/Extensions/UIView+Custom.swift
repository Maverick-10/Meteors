//
//  UIView+Custom.swift
//  Meteors
//
//  Created by bhuvan on 07/08/2021.
//

import UIKit

extension UIView {
    
    /// Update layer's corner radius.
    /// - Parameter radius: Corner radius
    /// - Returns: Returns updated view with the corner radius.
    @discardableResult
    func corner(radius: CGFloat) -> UIView {
        layer.cornerRadius = radius
        layer.masksToBounds = true
        layer.cornerCurve = .continuous
        return self
    }
    
    /// Update layer's border properties.
    /// - Parameter width: The width of the layer’s border.
    /// - Parameter color: The color of the layer’s border.
    /// - Returns: Returns updated view with the new border width and color.
    @discardableResult
    func border(width: CGFloat, color: UIColor) -> UIView {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
        return self
    }
    
    /// Update layer's shadow properties.
    /// - Parameters:
    ///   - radius: The blur radius (in points) used to render the layer’s shadow.
    ///   - color: The color of the layer’s shadow.
    ///   - opacity: The opacity of the layer’s shadow.
    ///   - offset: The offset of the layer’s shadow.
    /// - Returns: Returns updated view with the new shadow radius, opacity, offset and color.
    @discardableResult
    func shadow(radius: CGFloat, color: UIColor = .black, opacity: Float, offset: CGSize) -> UIView {
        layer.masksToBounds = false
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        return self
    }
}
