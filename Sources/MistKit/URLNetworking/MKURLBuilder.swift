import Foundation

public class MKURLBuilder: MKURLBuilderProtocol {
    
  public let tokenEncoder: MKTokenEncoder?
  public let connection: MKDatabaseConnection
  public let tokenManager: MKTokenManagerProtocol?
  public let includeAPIToken: Bool

  public init(
    tokenEncoder: MKTokenEncoder?,
    connection: MKDatabaseConnection,
    tokenManager: MKTokenManagerProtocol? = nil,
    includeAPIToken: Bool = true
  ) {
    self.tokenEncoder = tokenEncoder
    self.connection = connection
    self.tokenManager = tokenManager
    self.includeAPIToken = includeAPIToken
  }

  public func url(withPathComponents pathComponents: [String]) throws -> URL {
    var url = connection.url
    for path in pathComponents {
      url.appendPathComponent(path)
    }
    let query = queryItems.map {
      [$0.key, $0.value].joined(separator: "=")
    }
    .joined(separator: "&")
    guard let result = URL(
      string: [url.absoluteString, query]
        .joined(separator: "?")
    ) else {
      throw MKError.invalidURLQuery(query)
    }
    return result
  }
}

public extension MKURLBuilder {
  var queryItems: [String: String] {
      
      var parameters: [String: String] = [:]
      
    if includeAPIToken {
      parameters["ckAPIToken"] = connection.apiToken
    }
      
    if let webAuthenticationToken = tokenManager?.webAuthenticationToken,
       let tokenEncoder = tokenEncoder {
      parameters["ckWebAuthToken"] = tokenEncoder.encode(webAuthenticationToken)
      parameters["ckSession"] = tokenEncoder.encode(webAuthenticationToken)
    }
    return parameters
  }
}
