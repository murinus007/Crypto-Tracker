//
//  IconModel.swift
//  CryptoTrack
//
//  Created by Alexey Sergeev on 15.12.2021.
//

import Foundation

struct Icon: Codable {
    let assetID: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case assetID = "asset_id"
        case url
    }
}

