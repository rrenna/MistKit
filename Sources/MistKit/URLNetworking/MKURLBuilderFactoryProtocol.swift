//
//  MKURLBuilderFactoryProtocol.swift
//  
//
//  Created by Ryan Renna on 2022-04-07.
//

import Foundation

public protocol MKURLBuilderFactoryProtocol {
   
    func builder(
      forConnection connection: MKDatabaseConnection,
      withTokenManager tokenManager: MKTokenManagerProtocol?
    ) -> MKURLBuilderProtocol
}
