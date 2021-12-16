//
//  APICaller.swift
//  CryptoTrack
//
//  Created by Alexey Sergeev on 14.12.2021.
//

import Foundation


final class APICaller {
    static let shared = APICaller()
    
    public var icons: [Icon] = []
    private var whenReadyBlock: ((Result<[Crypto], Error>) -> Void)?
    
    private struct Constants {
        static let apiKey = "2365EB53-C1D2-4765-A671-1111698437C0"
        static let assetsEndpoint = "https://rest.coinapi.io/v1/assets/"
        static let iconsEndpoint = "https://rest.coinapi.io/v1/assets/icons/55"
    }
    
    private init() {}
    
    public func getAllCryptoData(
        completion: @escaping (Result<[Crypto], Error>) -> Void ) {
            
            guard !icons.isEmpty else {
                whenReadyBlock = completion
                return
            }
            
            guard let url = URL(string: Constants.assetsEndpoint + "?apikey=" + Constants.apiKey)
            else {
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                
                do {
                    let cryptos = try JSONDecoder().decode([Crypto].self, from: data)
                    
                    completion(.success(cryptos.sorted {
                        return $0.priceUSD ?? 0 > $1.priceUSD ?? 0
                    }))
                }
                
                catch {
                    completion(.failure(error))
                }
                
            }
            task.resume()
        }
    
    public func getAllIcons() {
            guard let url = URL(string: Constants.iconsEndpoint + "?apikey=" + Constants.apiKey)
            else {
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                
                do {
                    self?.icons = try JSONDecoder().decode([Icon].self, from: data)
                    if let completion = self?.whenReadyBlock {
                        
                        self?.getAllCryptoData(completion: completion)
                    }
                }
                
                catch {
                    print(error)
                }
                
            }
            task.resume()
        }
}
