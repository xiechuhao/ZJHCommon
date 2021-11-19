//
//  UIImageView-LDDExtensions.swift
//  Created by HouWan
//

#if canImport(UIKit)
import UIKit
#endif

#if canImport(SDWebImage)
import SDWebImage
#endif

// =============================================================================
// MARK: - LoadingImage
// =============================================================================

/// 封装`SDWebImage`，方便后续如果更换为`Kingfisher`或者其他
extension UIImageView {

    /// Set the imageView `image` with an `url` and placeholder.
    ///
    /// - Parameters:
    ///   - urlString: The url for the image.
    ///   - placeholder: The image to be set initially, until the image request finishes.
    func ldd_setImage(_ urlString: String?, _ placeholder: UIImage? = nil) {
        guard let u = urlString else {
            self.image = placeholder
            return
        }
        self.sd_setImage(with: URL(string: u), placeholderImage: placeholder)
    }

    /// Set the imageView `image` with an `url` and placeholder.
    ///
    /// - Parameters:
    ///   - url: The url for the image.
    ///   - placeholder: The image to be set initially, until the image request finishes.
    func ldd_setImage(_ url: URL?, _ placeholder: UIImage? = nil) {
        guard let u = url else {
            self.image = placeholder
            return
        }
        self.sd_setImage(with: u, placeholderImage: placeholder)
    }

}

// =============================================================================
// MARK: - Others
// =============================================================================
public extension UIImageView {
    /// 创建`UIImageView`的时候，可以直接是`UIImageView(imageName: "logo")`
    convenience init(imageName: String?) {
        if let n = imageName {
            self.init(image: UIImage(named: n))
        } else {
            self.init()
        }
    }
}
