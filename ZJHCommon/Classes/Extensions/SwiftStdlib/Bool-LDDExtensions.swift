//
//  Bool-LDDExtensions.swift
//  Created by HouWan
//

import Foundation

extension Bool {

    /// 根据`Bool`返回1和0，真是1，假是0
    /// 根据`Bool`返回`true`和`false`，直接调用`Bool.description`即可
    var int: Int { self ? 1 : 0 }
}
