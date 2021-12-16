//
//  assetModel.swift
//  CryptoTrack
//
//  Created by Alexey Sergeev on 14.12.2021.
//

import Foundation

struct Crypto: Codable {
    let assetId: String
    let name: String
    let priceUSD: Float?
    let idIcon: String?
    
    enum CodingKeys: String, CodingKey {
        case assetId = "asset_id"
        case name
        case priceUSD = "price_usd"
        case idIcon = "id_icon"
    }
}
