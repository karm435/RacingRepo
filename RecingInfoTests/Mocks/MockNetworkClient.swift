
import Foundation
import Models
import Network

enum ServerError: Error {
  case error(message: String)
}

public class MockNetworkClient: NetworkClientProtocol {
  public var mockReponse: Any? = nil
  
  public func get<Entity: Decodable>(_ urlString: String) async throws -> Entity {
    if mockReponse is Entity {
      return mockReponse as! Entity
    }
    
    if mockReponse is Entity {
      return mockReponse as! Entity
    }
    
    throw ServerError.error(message: "Entity type does match the response")
  }
}

// Error mock
extension MockNetworkClient {
  public static var errorClient: NetworkClientProtocol {
    let mock = MockNetworkClient()
    mock.mockReponse = nil
    return mock
  }
}

// Tasks mock
//extension MockNetworkClient {
//  public static var tasksMockClient: NetworkClientProtocol {
//    let mock = MockNetworkClient()
//    mock.mockReponse = Todo.placeholderTasks
//    return mock
//  }
//}
