//
//  File.swift
//  
//
//  Created by karmjit singh on 14/7/2023.
//

import Foundation

public struct ServerError: Decodable, Error {
  public let error: String?
}
