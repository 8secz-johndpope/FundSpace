/*
 Example of how to create a view that has rounded corners and a shadow.
 These cannot be on the same layer because setting the corner radius requires masksToBounds = true.
 When it's true, the shadow is clipped.
 It's possible to add sublayers and set their path with a UIBezierPath(roundedRect...), but this becomes difficult when using AutoLayout.
 Instead, we a containerView for the cornerRadius and the current view for the shadow.
 All subviews should just be added and constrained to the containerView
 */

import UIKit

class RoundShadowView: UIView {
    
    private var shadowLayer: CAShapeLayer!
    private var cornerRadius: CGFloat = 25.0
    private var fillColor: UIColor = .blue // the color applied to the shadowLayer, rather than the view's backgroundColor
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
            shadowLayer.fillColor = fillColor.cgColor
            
            shadowLayer.shadowColor = UIColor.black.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            shadowLayer.shadowOpacity = 0.2
            shadowLayer.shadowRadius = 3
            
            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
}
