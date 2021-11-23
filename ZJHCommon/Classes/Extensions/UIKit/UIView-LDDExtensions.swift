//
//  UIView-LDDExtensions.swift
//  Created by HouWan
//

#if canImport(UIKit)
import UIKit
#endif

#if canImport(Foundation)
import Foundation
#endif

// =============================================================================
// MARK: - Properties
// =============================================================================
extension UIView {
    /// x origin of view.
    public var x: CGFloat {
        get { frame.origin.x }
        set { frame.origin.x = newValue }
    }

    /// y origin of view.
    public var y: CGFloat {
        get { frame.origin.y }
        set { frame.origin.y = newValue }
    }

    /// Width of view.
    public var width: CGFloat {
        get { frame.size.width }
        set { frame.size.width = newValue }
    }

    /// Height of view.
    public var height: CGFloat {
        get { frame.size.height }
        set { frame.size.height = newValue }
    }

    /// Size of view.
    public var size: CGSize {
        get { frame.size }
        set { frame.size = newValue }
    }

    /// Origin of view.
    public var origin: CGPoint {
        get { frame.origin }
        set { frame.origin = newValue }
    }

    /// CenterX of view.
    public var centerX: CGFloat {
        get { center.x }
        set { center.x = newValue }
    }

    /// CenterY of view.
    public var centerY: CGFloat {
        get { center.y }
        set { center.y = newValue }
    }

    /// Bottom of view.
    public var maxY: CGFloat { frame.maxY }

    /// Right of view.
    public var maxX: CGFloat { frame.maxX }

    /// Middle of view.
    public var midY: CGFloat { frame.midY }

    /// Middle of view.
    public var midX: CGFloat { frame.midX }

    /// Returns the view's view controller (may be nil).
    public var viewController: UIViewController? {
        weak var sv = UIView?.some(self)
        while let tempView = sv {
            if tempView.next is UIViewController {
                return tempView.next as? UIViewController
            }
            sv = sv?.superview
        }
        return nil
    }

    /// 圆角 rounded corners, see: `layer.cornerRadius`
    public var cornerRadius: CGFloat {
        get { layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }

    /// Is it displayed on the screen? (注意: 判断`UIWindow`可能是不准的)
    /// - note: 发现如果AView在屏幕上，但是BView的Frame比较大全部盖住了AView，此时屏幕上看不到AView
    ///   但是结果依旧是`true`，如果真处理这里，将会十分麻烦，比如BView的透明度如果是0.5，也能看到AView，此时
    ///   AView算不算在屏幕上? 如果AView上有N层View呢?
    public var isDisplayedInScreen: Bool {
        guard !self.isHidden else { return false }
        guard self.height > 0 else { return false }
        guard self.width > 0 else { return false }
        guard self.alpha > 0 else { return false }
        if self.superview == nil && !(self is UIWindow) { return false }

        // 转换view对应window的Rect
        let rect = self.convert(self.bounds, to: nil)
        if rect.isEmpty || rect.isNull { return false }
        if rect.size == CGSize.zero { return false }

        // 获取 该view与window 交叉的 Rect
        let screenRect = UIScreen.main.bounds
        let intersectionRect = self.frame.intersection(screenRect)

        if intersectionRect.isEmpty || intersectionRect.isNull { return false }
        return true
    }
}

// =============================================================================
// MARK: - InstanceMethods
// =============================================================================
extension UIView {

    private struct LDDAssociatedKey {
        /// 三个是添加点击手势所需AssociatedKey
        static var LDD_TAPGESTURE_KEY: Void?
        static var LDD_TAPGESTURECLOSURE_KEY: Void?
        static var LDD_TAPGESTUREEFFECT_KEY: Void?

        /// 菊花指示器View所需AssociatedKey
        static var LDD_ACTIVITYIND_KEY: Void?
    }

    /// Shake directions of a view.
    enum ShakeDirection {
        /// Shake left and right.
        case horizontal
        /// Shake up and down.
        case vertical
    }

    /// Shake animations types.
    enum ShakeAnimationType {
        /// linear animation.
        case linear
        /// easeIn animation.
        case easeIn
        /// easeOut animation.
        case easeOut
        /// easeInOut animation.
        case easeInOut
    }

    /// 一次性添加多个子View
    func ldd_addSubviews(_ views: [UIView]) {
        views.forEach { self.addSubview($0) }
    }

    /// Remove all subviews in view.
    func ldd_removeAllSubviews() {
        subviews.forEach({ $0.removeFromSuperview() })
    }

    /// Remove all gesture recognizers from view.
    func ldd_removeAllGestureRecognizers() {
        gestureRecognizers?.forEach(removeGestureRecognizer)
    }

    ///  Shake view.
    ///
    /// - Parameters:
    ///   - direction: shake direction (horizontal or vertical), (default is .horizontal)
    ///   - duration: animation duration in seconds (default is 1 second).
    ///   - animationType: shake animation type (default is .easeOut).
    ///   - completion: optional completion handler to run with animation finishes (default is nil).
    func ldd_shake(direction: ShakeDirection = .horizontal, duration: TimeInterval = 1, animationType: ShakeAnimationType = .linear, completion:(() -> Void)? = nil) {
        layer.removeAnimation(forKey: "ldd_view_shake")

        CATransaction.begin()
        let animation: CAKeyframeAnimation
        switch direction {
        case .horizontal:
            animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        case .vertical:
            animation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        }
        switch animationType {
        case .linear:
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        case .easeIn:
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        case .easeOut:
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        case .easeInOut:
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        }
        CATransaction.setCompletionBlock(completion)
        animation.duration = duration
        animation.values = [-8.0, 5.0, -8.0, 5.0, -4.0, 4.0, -2.0, 2.0, 0.0]
        layer.add(animation, forKey: "ldd_view_shake")
        CATransaction.commit()
    }

    // MARK: TapGesture

    /// Add a tap gesture to `view` and use `closure` callback event.
    /// - Parameter effect: Is there a click effect?
    func ldd_addTapGestureRecognizer(effect: Bool = false, _ callback: @escaping (UIView?) -> Void) {
        objc_setAssociatedObject(self, &LDDAssociatedKey.LDD_TAPGESTUREEFFECT_KEY,
                                 effect, .OBJC_ASSOCIATION_ASSIGN)

        objc_setAssociatedObject(self, &LDDAssociatedKey.LDD_TAPGESTURECLOSURE_KEY,
                                 callback, .OBJC_ASSOCIATION_COPY_NONATOMIC)

        let tap = UITapGestureRecognizer(target: self, action: #selector(ldd_tap(_:)))
        tap.numberOfTouchesRequired = 1
        tap.numberOfTapsRequired = 1
        addGestureRecognizer(tap)

        objc_setAssociatedObject(self, &LDDAssociatedKey.LDD_TAPGESTURE_KEY,
                                 tap, .OBJC_ASSOCIATION_ASSIGN)
    }

    /// private UITapGestureRecognizer
    @objc private func ldd_tap(_ tap: UITapGestureRecognizer) {
        guard tap.state == .ended else { return }
        guard alpha > 0 || !isHidden else { return }

        let tapEffect = objc_getAssociatedObject(self, &LDDAssociatedKey.LDD_TAPGESTUREEFFECT_KEY) as? Bool ?? false

        if tapEffect, let bgColor = self.backgroundColor {
            var r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0
            bgColor.getRed(&r, green: &g, blue: &b, alpha: &a)
            r -= 0.08
            g -= 0.08
            b -= 0.08
            r = r < 0 ? 0 : r
            g = g < 0 ? 0 : g
            b = b < 0 ? 0 : b
            let animate = CABasicAnimation(keyPath: "backgroundColor")
            animate.duration = 0.3
            animate.fromValue = UIColor(red: r, green: g, blue: b, alpha: a).cgColor
            animate.toValue = bgColor.cgColor
            layer.removeAnimation(forKey: "TapGestureEffect")
            layer.add(animate, forKey: "TapGestureEffect")
        }

        if let closure = objc_getAssociatedObject(self, &LDDAssociatedKey.LDD_TAPGESTURECLOSURE_KEY) as? (UIView?) -> Void {
            closure(self)
        }
    }

    /// Remove tap gesture recognizer.
    /// It can only be useful for gestures added by the above two methods.
    func ldd_removeTapGestureRecognizer() {
        if let tap = objc_getAssociatedObject(self, &LDDAssociatedKey.LDD_TAPGESTURE_KEY) as? UITapGestureRecognizer {
            removeGestureRecognizer(tap)
        }

        objc_setAssociatedObject(self, &LDDAssociatedKey.LDD_TAPGESTURE_KEY,
        nil, .OBJC_ASSOCIATION_ASSIGN)

        objc_setAssociatedObject(self, &LDDAssociatedKey.LDD_TAPGESTUREEFFECT_KEY,
                                   false, .OBJC_ASSOCIATION_ASSIGN)

        objc_setAssociatedObject(self, &LDDAssociatedKey.LDD_TAPGESTURECLOSURE_KEY,
                                   nil, .OBJC_ASSOCIATION_COPY_NONATOMIC)
    }

    // MARK: RoundedCorners

    /// 设置部分圆角(绝对布局frame)，(由于用到了bounds，所以先设置过frame)
    ///
    /// - Parameters:
    ///   - corners: array of corners to change (example: [.bottomLeft, .topRight]).
    ///   - radius: radius for selected corners. eg.CGSize(20, 20)
    func ldd_addRoundedCorners(_ corners: UIRectCorner, radii: CGSize) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: radii)
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        layer.mask = shape
    }

    /// 设置部分圆角(相对布局Constraint)，(由于用到了bounds，所以需要给rect)
    ///
    /// - Parameters:
    ///   - corners: array of corners to change (example: [.bottomLeft, .topRight]).
    ///   - radius: radius for selected corners. eg.CGSize(20, 20)
    ///   - rect: View's size range
    func ldd_addRoundedCorners(_ corners: UIRectCorner, radii: CGSize, rect: CGRect) {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: radii)
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        layer.mask = shape
    }

    /// 创建一个`activityIndicatorView`，并开始动画(菊花转圈), default style: UIActivityIndicatorViewStyleGray
    /// - note: `activityIndicatorView`是使用AutoLayout布局的，并且使用了`transform`缩放了 1.5 倍，当然为了方便自定义
    /// 返回了此`activityIndicatorView`的引用.
    @discardableResult
    func ldd_startAnimating(_ style: UIActivityIndicatorView.Style = .gray) -> UIActivityIndicatorView {
        if let aiv = ldd_activityIndicator() {
            aiv.activityIndicatorViewStyle = style
            aiv.startAnimating()
            return aiv
        }

        let aiv = UIActivityIndicatorView(activityIndicatorStyle: style)
        aiv.hidesWhenStopped = true
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        addSubview(aiv)
        aiv .startAnimating()

        let xc = NSLayoutConstraint(item: aiv, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let yc = NSLayoutConstraint(item: aiv, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        xc.isActive = true
        yc.isActive = true
        addConstraints([xc, yc])

        objc_setAssociatedObject(self, &LDDAssociatedKey.LDD_ACTIVITYIND_KEY, aiv, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return aiv
    }

    /// Get `activityIndicatorView`, The premise is that method `[ldd_startAnimating]` has been called.
    /// 方便自己设置`UIActivityIndicatorView`的一些属性
    func ldd_activityIndicator() -> UIActivityIndicatorView? {
        return objc_getAssociatedObject(self, &LDDAssociatedKey.LDD_ACTIVITYIND_KEY) as? UIActivityIndicatorView
    }

    /// 停止菊花转圈: [UIActivityIndicatorView stopAnimating]
    func ldd_stopAnimating() {
        if let aiv = ldd_activityIndicator() {
            aiv.stopAnimating()
        }
    }

    /// Create a snapshot image of the complete view hierarchy.
    /// 这个跟下面那个截图使用的方法不一样
    func ldd_snapshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, isOpaque, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }

    /// Create a snapshot image of the complete view hierarchy.
    /// - note: It's faster than "snapshotImage", but may cause screen updates.
    /// See -[UIView drawViewHierarchyInRect:afterScreenUpdates:] for more information.
    func ldd_snapshot(_ afterUpdates: Bool) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, isOpaque, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        self.drawHierarchy(in: layer.bounds, afterScreenUpdates: afterUpdates)
        return UIGraphicsGetImageFromCurrentImageContext()
    }

}

// =============================================================================
// MARK: - ClassMethods
// =============================================================================

extension UIView {
    /// Create a `UIView` and set the background color.
    convenience public init(bgColor: UIColor?) {
        self.init()
        self.backgroundColor = bgColor
    }

    /// Load view from nib.
    ///
    /// - Parameters:
    ///   - name: nib name.
    ///   - bundle: bundle of nib (default is nil).
    /// - Returns: optional UIView (if applicable).
    class func loadFromNib(named name: String, bundle: Bundle? = nil) -> UIView? {
        return UINib(nibName: name, bundle: bundle).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
}

extension UITableViewCell {

    func initNone() {
        selectionStyle = .none
        backgroundColor = .white
    }
}
