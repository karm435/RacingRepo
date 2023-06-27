import Foundation

public enum NetworkError: Error {
  case invalidUrl(_ url: String)
  case invalidServerResponse
}

public class NetworkClient {
  let urlSession: URLSession
  
  public init() {
    urlSession = URLSession.shared
  }
  
  public func get<Entity: Decodable>(_ urlString: String) async throws -> Entity {
    guard let url = URL(string: urlString) else {
      throw NetworkError.invalidUrl(urlString)
    }
    
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = "GET"
    
    let (data, httpResponse) = try await urlSession.data(for: urlRequest)
    
    guard let httpResponse = httpResponse as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
      throw NetworkError.invalidServerResponse
    }
    let jsonDecoder = JSONDecoder()
    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    
    let result = try jsonDecoder.decode(Entity.self, from: data)
    
    
    
    return result
  }
}
