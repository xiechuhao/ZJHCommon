//
//  UIKit-DotSyntax.swift
//  Created by HouWan
//
//  扩展`点`语法糖
//
//  ________          __   _________             __
//  \______ \   _____/  |_/   _____/__.__. _____/  |______  ___  ___
//   |    |  \ /  _ \   __\_____  <   |  |/    \   __\__  \ \  \/  /
//   |    `   (  <_> )  | /        \___  |   |  \  |  / __ \_>    <
//  /_______  /\____/|__|/_______  / ____|___|  /__| (____  /__/\_ \
//          \/                   \/\/         \/          \/      \/

#if canImport(UIKit)
import UIKit
#endif

// =============================================================================
// MARK: - UIView
// =============================================================================

public extension UIView {
    /// UIView.backgroundColor = backgroundColor
    @discardableResult
    func bgColor(_ color: UIColor?) -> Self {
        self.backgroundColor = color
        return self
    }

    /// UIView.isHidden = hidden
    @discardableResult
    func hidden(_ hiddenValue: Bool) -> Self {
        self.isHidden = hiddenValue
        return self
    }

    /// UIView.alpha = alpha
    @discardableResult
    func alpha(_ alpha: CGFloat) -> Self {
        self.alpha = alpha
        return self
    }

    /// 圆角 rounded corners, see: `layer.cornerRadius`
    @discardableResult
    func radius(_ radius: CGFloat) -> Self {
        layer.cornerRadius = radius
        return self
    }

    /// `UIImageView.contentMode` = contentMode
    @discardableResult
    func contentMode(_ mode: UIView.ContentMode) -> Self {
        self.contentMode = mode
        return self
    }

    /// 设置边框颜色和边框宽度, 颜色不用CGColor
    @discardableResult
    func borderColor(_ color: UIColor?, width: CGFloat) -> Self {
        layer.borderColor = color?.cgColor
        layer.borderWidth = width
        return self
    }
}

// =============================================================================
// MARK: - UIButton
// =============================================================================

public extension UIButton {
    /// UIButton -> titleLabel?.font = font
    @discardableResult
    func font(_ font: UIFont) -> Self {
        titleLabel?.font = font
        return self
    }

    /// Same as `[self setTitle:title forState:UIControlStateNormal];`
    @discardableResult
    func titleN(_ title: String?) -> Self {
        setTitle(title, for: .normal)
        return self
    }

    /// Same as `[self setTitle:title forState:UIControlStateHighlighted];`
    @discardableResult
    func titleH(_ title: String?) -> Self {
        setTitle(title, for: .highlighted)
        return self
    }

    /// Same as `[self setTitle:title forState:UIControlStateSelected];`
    @discardableResult
    func titleS(_ title: String?) -> Self {
        setTitle(title, for: .selected)
        return self
    }

    /// Same as `[self setImage:xx forState:(UIControlStateNormal)];`
    @discardableResult
    func imageN(_ image: UIImage?) -> Self {
        setImage(image, for: .normal)
        return self
    }

    /// Same as `[self setImage:xx forState:(UIControlStateSelected)];`
    @discardableResult
    func imageS(_ image: UIImage?) -> Self {
        setImage(image, for: .selected)
        return self
    }

    /// Same as `[self setImage:xx forState:(UIControlStateHighlighted)];`
    @discardableResult
    func imageH(_ image: UIImage?) -> Self {
        setImage(image, for: .highlighted)
        return self
    }
}

// =============================================================================
// MARK: - UIImageView
// =============================================================================

public extension UIImageView {
    /// `UIImageView.image` = image
    @discardableResult
    func image(_ image: UIImage?) -> Self {
        self.image = image
        return self
    }

    /// `UIImageView.image` = image
    @discardableResult
    func imageName(_ imageName: String?) -> Self {
        if let name = imageName {
            self.image = UIImage(named: name)
        } else {
            self.image = nil
        }
        return self
    }
}

// =============================================================================
// MARK: - UILabel
// =============================================================================

public extension UILabel {
    /// UILabel.font = font
    @discardableResult
    func font(_ font: UIFont!) -> Self {
        self.font = font
        return self
    }

    /// UILabel.textColor = textColor
    @discardableResult
    func textColor(_ textColor: UIColor!) -> Self {
        self.textColor = textColor
        return self
    }

    /// UILabel.numberOfLines = numberOfLines
    @discardableResult
    func lines(_ numberOfLines: Int) -> Self {
        self.numberOfLines = numberOfLines
        return self
    }

    /// UILabel.textAlignment = textAlignment
    @discardableResult
    func align(_ textAlignment: NSTextAlignment) -> Self {
        self.textAlignment = textAlignment
        return self
    }

    /// UILabel.text = text
    @discardableResult
    func text_(_ text: String?) -> Self {
        self.text = text
        return self
    }
}
