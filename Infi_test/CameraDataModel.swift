//
//  CameraDataModel.swift
//  Infi_test
//
//  Created by Frank van der Meulen on 20-01-18.
//  Copyright © 2018 Frank van der Meulen. All rights reserved.
//

struct CameraDataModel {
    let cameraNaam: String!
    let cameraLatitude: String!
    let cameraLongitude: String!
    
    init(cameraNaam: String, cameraLatitude: String, cameraLongitude: String) {
        
        self.cameraNaam = cameraNaam
        self.cameraLatitude = cameraLatitude
        self.cameraLongitude = cameraLongitude
    }
}
