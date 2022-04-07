import MistKit
import Vapor

public struct MKVaporClient: MKHttpClient {
  public let client: Client

  public init(client: Client) {
    self.client = client
  }

  public func request(
    fromConfiguration configuration: RequestConfiguration
  ) -> MKVaporClientRequest {
    var clientRequest = ClientRequest()
    clientRequest.url = URI(string: configuration.url.absoluteString)
    if let data = configuration.data {
      clientRequest.body = ByteBuffer(data: data)
      clientRequest.method = .POST
      clientRequest.headers.add(name: .contentType, value: "application/json")
    }
    return MKVaporClientRequest(client: client, request: clientRequest)
  }
}

public struct MKVaporServerToServerClient: MKHttpClient {
    public let client: Client
    public let headersForConfigurationBlock: ((RequestConfiguration)->([String:String]))?

  public init(client: Client, headersForConfigurationBlock: ((RequestConfiguration)->([String:String]))? = nil) {
    self.client = client
    self.headersForConfigurationBlock = headersForConfigurationBlock
  }

  public func request(
    fromConfiguration configuration: RequestConfiguration
  ) -> MKVaporClientRequest {
    var clientRequest = ClientRequest()
    clientRequest.url = URI(string: configuration.url.absoluteString)
    if let data = configuration.data {
        
      let headers = headersForConfigurationBlock?(configuration) ?? [:]
      clientRequest.body = ByteBuffer(data: data)
      clientRequest.method = .POST
      clientRequest.headers.add(name: .contentType, value: "application/json")
      headers.forEach { clientRequest.headers.add(name: $0, value: $1) }
    }
    return MKVaporClientRequest(client: client, request: clientRequest)
  }
}
