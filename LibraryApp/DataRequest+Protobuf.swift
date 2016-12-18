//
//  DataRequest+Protobuf.swift
//  LibraryApp
//
//  Created by Anders Carling on 16-12-18.
//  Copyright © 2016 Example. All rights reserved.
//

import Foundation

import Alamofire
import Protobuf


extension DataRequest {
    @discardableResult
    func responseProtobuf<T: GPBMessage>(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        let responseSerializer = DataResponseSerializer<T> { request, response, data, error in
            if let error = error {
                return .failure(error)
            }

            let result = Request.serializeResponseData(response: response, data: data, error: nil)
            guard case let .success(validData) = result else {
                return .failure(result.error!)
            }

            do {
                let responseObject = try T(data: validData)
                return .success(responseObject)
            } catch {
                return .failure(error)
            }
        }

        return response(queue: queue, responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}

enum ProtobufEncodingError: Error {
    case failure
}

struct ProtobufEncoding: ParameterEncoding {
    let message: GPBMessage

    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()

        guard let data = message.data() else {
            throw ProtobufEncodingError.failure
        }

        urlRequest.setValue("application/x-protobuf", forHTTPHeaderField: "Content-Type")

        let protoName = message.descriptor().name.replacingOccurrences(of: "_", with: ".")
        urlRequest.setValue(protoName, forHTTPHeaderField: "X-Message-Class")

        urlRequest.httpBody = data

        return urlRequest

    }
}
