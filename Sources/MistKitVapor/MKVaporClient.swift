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
    public let onHeaderConstruction: ((ClientRequest)->())?

  public init(client: Client, onHeaderConstruction: ((ClientRequest)->())? = nil) {
    self.client = client
    self.onHeaderConstruction = onHeaderConstruction
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
      onHeaderConstruction?(clientRequest)
    }
    return MKVaporClientRequest(client: client, request: clientRequest)
  }
}
