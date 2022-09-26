//
//  HTTPBodyBuilder.swift
//  MMarket
//
//  Created by 조성훈 on 2022/09/25.
//

import Foundation

enum MIMEType {
    case json
    case jpeg
    
    var description: String {
        switch self {
        case .json:
            return "application/json"
        case .jpeg:
            return "image/jpeg"
        }
    }
}

struct RequestDataInfo {
    let name: String
    let fileName: String?
    let type: MIMEType
    let data: Data?
}

final class HTTPBodyBuilder {
    private var data = Data()
    private var boundary: String?
    
    private init(boundary: String? = nil) {
        self.boundary = boundary
    }
    
    static func create(uuid: String? = nil) -> HTTPBodyBuilder {
        return HTTPBodyBuilder(boundary: uuid)
    }
    
    @discardableResult
    func append(_ dataInfo: RequestDataInfo) -> HTTPBodyBuilder {
        guard let requestData = dataInfo.data,
              let jsonData = try? JSONEncoder().encode(requestData)
        else {
            return self
        }
        
        if let boundary = boundary {
            data.appendString("\r\n--\(boundary)\r\n")
            data.appendString("Content-Disposition: form-data; name=\"\(dataInfo.name)\"")
            if let fileName = dataInfo.fileName {
                data.appendString("; filename=\"\(fileName)\"\r\n")
            }
            data.appendString("\r\n")
            data.appendString("Content-Type: \(dataInfo.type.description)\r\n\r\n")
        }
        
        data.append(jsonData)
        
        return self
    }
    
    func append(_ dataInfos: [RequestDataInfo]) -> HTTPBodyBuilder {
        dataInfos.forEach {
            append($0)
        }
        
        return self
    }
    
    func append(_ password: String) -> HTTPBodyBuilder {
        guard let requestData = "{\"secret\": \"\(password)\"}".data(using: .utf8) else { return self }
        data.append(requestData)
        
        return self
    }
    
    func apply() -> Data {
        if let boundary = boundary {
            self.data.appendString("\r\n--\(boundary)--\r\n")
        }
        
        return self.data
    }
}
