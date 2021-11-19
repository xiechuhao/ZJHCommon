//
//  NSAttributedString-LDDExtension.swif
//  Created by HouWan
//

//  需要注意的是: `lineBreakMode`会影响计算结果，比如设置 NSLineBreakByTruncatingTail |
//  NSLineBreakByTruncatingHead | NSLineBreakByTruncatingMiddle 在计算高度的时候 会被系统默认成单行

import Foundation

/// 富文本的计算
public extension NSAttributedString {
    /// 计算`NSAttributedString`的size，(用一个很大的范围去限定的)
    /// - Returns: size
    func ldd_size() -> CGSize {
        guard !self.string.isEmpty else { return CGSize.zero }

        let size = CGSize(width: 80000, height: 80000)
        let rect = boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)

        return CGSize(width: CGFloat(ceilf(Float(rect.size.width))),
                      height: CGFloat(ceilf(Float(rect.size.height))))
    }

    /// 计算`NSAttributedString`的宽度，(用一个很大的范围去限定的)
    /// - Returns: width
    func ldd_widthWith(_ height: CGFloat) -> CGFloat {
        guard !self.string.isEmpty else { return 0 }

        let size = CGSize(width: 80000, height: height)
        let rect = boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)

        return CGFloat(ceilf(Float(rect.size.width)))
    }

    /// 计算`NSAttributedString`的高度
    /// - Parameter width: 限定的宽度
    /// - Returns: height
    func ldd_heightWith(_ width: CGFloat) -> CGFloat {
        guard !self.string.isEmpty else { return 0 }

        let size = CGSize(width: width, height: 80000)
        let rect = boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)

        return CGFloat(ceilf(Float(rect.size.height)))
    }
}

extension NSAttributedString {

    class func ph_CustomAttributedString(_ title: String, _ font: UIFont, _ foregroundColor: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)) -> NSAttributedString {
        let attri: NSAttributedString = NSAttributedString(string: title, attributes: [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: foregroundColor
        ])
        return attri
    }
}

extension NSMutableAttributedString {

    func ph_CustomParagraphStyle(_ lineSpacing: CGFloat, _ alignment: NSTextAlignment) {
        let para: NSMutableParagraphStyle = NSMutableParagraphStyle()
        para.lineSpacing = lineSpacing
        para.alignment = alignment
        self.addAttributes([NSAttributedString.Key.paragraphStyle: para], range: NSRange(location: 0, length: self.length))
    }

    func appendAttrStringList(_ list: [NSAttributedString]) {
        for attrString in list {
            append(attrString)
        }
    }
}
