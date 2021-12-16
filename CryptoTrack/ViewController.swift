//
//  ViewController.swift
//  CryptoTrack
//
//  Created by Alexey Sergeev on 14.12.2021.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var cryptos: [Crypto] = []
    
    private var viewModels = [CryptoTableViewCell.ViewModel]()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(CryptoTableViewCell.self, forCellReuseIdentifier: CryptoTableViewCell.identifier)
        return tableView
    }()
    
    static let numberFormatter: NumberFormatter = {
       let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.allowsFloats = true
        formatter.numberStyle = .currency
        formatter.formatterBehavior = .default
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Crypto Tracker"
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        APICaller.shared.getAllCryptoData { [weak self] result in
            switch result {
            case .success(let cryptos):
                self?.cryptos = cryptos
                self?.viewModels = cryptos.compactMap({ crypto in
                    let price = crypto.priceUSD ?? 0
                    let formatter = ViewController.numberFormatter
                    let text =  formatter.string(from: NSNumber(value: price))
                    let iconUrl = URL(string: APICaller.shared.icons.filter({  icon in
                        icon.assetID == crypto.assetId
                    }).first?.url ?? "")
                    return CryptoTableViewCell.ViewModel(name: crypto.name, symbol: crypto.assetId, price: text ?? "N/A", iconUrl: iconUrl)
                })
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CryptoTableViewCell.identifier, for: indexPath)
         as? CryptoTableViewCell else{
            fatalError()
        }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
}
