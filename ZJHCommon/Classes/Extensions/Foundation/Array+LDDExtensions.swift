//
//  Array+LDDExtensions.swift
//  Lian
//
//  Created by zph on 2021/1/14.
//  Copyright © 2021 CS United Data Technology Co.,Ltd. All rights reserved.
//

extension Array {

    /// 数组转json
    var toJSONString: String {
        guard JSONSerialization.isValidJSONObject(self) else {
            print("无法解析出JSONString")
            return ""
        }

        guard let data = try? JSONSerialization.data(withJSONObject: self, options: []) else {
            return ""
        }
        let jsonString = String(data: data, encoding: .utf8)
        return jsonString ?? ""
    }
}

extension Dictionary {
    /// 字典转json
    var toJSONString: String {
        guard JSONSerialization.isValidJSONObject(self) else {
            print("无法解析出JSONString")
            return ""
        }
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: []) else {
            return ""
        }
        let jsonString = String(data: data, encoding: .utf8)
        return jsonString ?? ""
    }
}
