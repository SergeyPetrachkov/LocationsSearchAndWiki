//
//  APIEndpoint.swift
//  
//
//  Created by Sergey Petrachkov
//

import Foundation

/// An entity describing what's needed to call an endpoint
public struct APIEndpoint<T> {
    /// endpoint path
    let path: String
    /// method
    let method: HTTPMethod
    /// query parameters
    let parameters: [String: Any]?
    /// http body
    let body: Data?
    /// any custom headers if needed
    let customHeaders: [String: String]?

    /// Initialize the APIEndpoint with path, method (GET by default), custom headers if needed and query params or body
    public init(path: String,
                method: HTTPMethod = .get,
                customHeaders: [String: String]?,
                parameters: [String: Any]? = nil,
                body: Data? = nil) {
        self.path = path
        self.method = method
        self.customHeaders = customHeaders
        self.parameters = parameters
        self.body = body
    }
}

// MARK: - URLRequestConvertible
extension APIEndpoint {

    /// Computed property to get URL object out of the `path` property
    public var url: URL {
        // swiftlint:disable:next force_cast
        return URL(string: self.path)!
    }

    /// Convert self to URLRequest respecting body, params, headers, etc
    public func asURLRequest(contentType: ContentType? = nil) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = self.method.rawValue
        urlRequest.encodeParameters(self.parameters)

        if let customHeaders = self.customHeaders {
            customHeaders.forEach { key, value in
                if urlRequest.value(forHTTPHeaderField: key) == nil {
                    urlRequest.setValue(value, forHTTPHeaderField: key)
                }
            }
        }

        if urlRequest.value(forHTTPHeaderField: HttpRequestHeaderKeys.contentType.rawValue) == nil {
            urlRequest.setValue(contentType?.rawValue ?? ContentType.applicationJson.rawValue,
                                forHTTPHeaderField: HttpRequestHeaderKeys.contentType.rawValue)
        }
        if urlRequest.value(forHTTPHeaderField: HttpRequestHeaderKeys.accept.rawValue) == nil {
            urlRequest.setValue(contentType?.rawValue ?? ContentType.applicationJson.rawValue,
                                forHTTPHeaderField: HttpRequestHeaderKeys.accept.rawValue)
        }
        if let body = self.body {
            urlRequest.httpBody = body
        }

        return urlRequest
    }
}

private extension URLRequest {
    mutating func encodeParameters(_ parameters: [String: Any]?) {
        guard let parameters = parameters,
              parameters.isEmpty == false,
              let url = url else {
            return
        }

        func encode(_ value: Any) -> String {
            func percentEncode(_ string: String) -> String {
                return string.addingPercentEncoding(withAllowedCharacters: .afURLQueryAllowed) ?? string
            }
            switch value {
            case let intValue as Int:
                return percentEncode(String(intValue))
            case let stringValue as String:
                return percentEncode(stringValue)
            default:
                fatalError("Could not encode \(value)")
            }
        }

        func query(_ parameters: [String: Any]) -> String {
            return parameters.sorted { $0.key < $1.key }.map { "\(encode($0))=\(encode($1))" }.joined(separator: "&")
        }

        if self.httpMethod == HTTPMethod.get.rawValue {
            let newQueryToAppend = query(parameters)
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
            let existingQuery = urlComponents?.percentEncodedQuery.map { $0 + "&" } ?? ""
            urlComponents?.percentEncodedQuery = existingQuery + newQueryToAppend
            self.url = urlComponents?.url
        } else {
            if value(forHTTPHeaderField: HttpRequestHeaderKeys.contentType.rawValue) == nil {
                setValue("application/x-www-form-urlencoded; charset=utf-8",
                         forHTTPHeaderField: HttpRequestHeaderKeys.contentType.rawValue)
            }

            httpBody = query(parameters).data(using: .utf8, allowLossyConversion: false)
        }
    }
}

/// URLQueryAllowed CharacterSet extracted from Alamofire
/// https://github.com/Alamofire/Alamofire
private extension CharacterSet {
    /// Creates a CharacterSet from RFC 3986 allowed characters.
    ///
    /// RFC 3986 states that the following characters are "reserved" characters.
    ///
    /// - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
    /// - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="
    ///
    /// In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
    /// query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
    /// should be percent-escaped in the query string.
    static let afURLQueryAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        let encodableDelimiters = CharacterSet(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")

        return CharacterSet.urlQueryAllowed.subtracting(encodableDelimiters)
    }()
}
