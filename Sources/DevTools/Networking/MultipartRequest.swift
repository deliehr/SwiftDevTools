//
//  File.swift
//
//
//  Created by Dominik Liehr on 25.07.24.
//

import Foundation

public struct MultipartRequest {
    private let boundary = UUID().uuidString
    private let separator = "\r\n"
    private var data = Data()

    public init(with file: MultipartFile) {
        add(file: file)
    }

    private mutating func appendBoundarySeparator() {
        data.append("--\(boundary)\(separator)")
    }

    private mutating func appendSeparator() {
        data.append(separator)
    }

    private func contentDisposition(_ key: String) -> String {
        "Content-Disposition: form-data; name=\"\(key)\""
    }

    public mutating func add(key: String, value: String) {
        appendBoundarySeparator()
        data.append(contentDisposition(key).appending(separator))
        appendSeparator()
        data.append(value.appending(separator))
    }

    public mutating func add(file: MultipartFile) {
        add(key: file.key, name: file.name, mimeType: file.mimeType, content: file.content)
    }

    private mutating func add(key: String, name: String, mimeType: String, content: Data) {
        appendBoundarySeparator()
        data.append(contentDisposition(key).appending("; filename=\"\(name)\"").appending(separator))
        data.append("Content-Type: \(mimeType)".appending(separator).appending(separator))
        data.append(content)
        appendSeparator()
    }

    public var httpContentTypeHeadeValue: String {
        "multipart/form-data; boundary=\(boundary)"
    }

    public var httpBody: Data {
        var bodyData = data
        bodyData.append("--\(boundary)--")
        return bodyData
    }
}
