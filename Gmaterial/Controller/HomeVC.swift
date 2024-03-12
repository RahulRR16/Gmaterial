//
//  HomeVC.swift
//  Gmaterial
//
//

import UIKit
import SnapKit

class HomeVC: UIViewController {
    struct Objects {
        var sectionCurrency: String!
        var sectionAmount: Double!
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(homeCurrencyCell.self, forCellReuseIdentifier: homeCurrencyCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "GOLD RATE"
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private let currencyContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexString: "#AF2D2D")
        return view
    }()
    
    private let amountContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "#8C0000")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Currency Symbol"
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Amount per ounce"
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    let urlStr = "https://api.qmdev.xyz/api/metals/rates"
    var cellIndentifer = "CurrencyTableViewCell"
    var objectArray = [Objects]()
    var usdValue: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchApiValue()
        view.backgroundColor = UIColor(hexString: "#FFFDEF")
        navigationController?.navigationBar.isHidden = true
        setUpUi()
    }
    
    private func setUpUi() {
        let stackView = UIStackView(arrangedSubviews: [currencyContainerView, amountContainerView])
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        stackView.axis = .horizontal
        stackView.backgroundColor = .white
        self.view.addSubview(titleLabel)
        self.view.addSubview(stackView)
        currencyContainerView.addSubview(currencyLabel)
        amountContainerView.addSubview(amountLabel)
        self.view.addSubview(tableView)
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(60)
            make.top.left.right.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        stackView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(titleLabel.snp.bottom).offset(0)
            make.height.equalTo(80)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide)
        }
        currencyLabel.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(currencyContainerView)
        }
        amountLabel.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(amountContainerView)
        }
        tableView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(stackView.snp.bottom).offset(10)
            make.left.right.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        tableView.backgroundColor = UIColor(hexString: "#FFFDEF")
    }
    
    //MARK: fetch Values from Api
    
    func fetchApiValue() {
        if ServiceHandler().isConnectedToNetwork() {
            ServiceHandler.sharedInstance.getRequestURL(urlStr, isloader: true, success:  {
                [weak self](_,responseData)  -> Void in
                let data = responseData
                let posts = MaterialRatesModel.parse(data: data)
                guard let responseModel = posts else {return}
                if let value = responseModel.data {
                    if let ratesData = value.rates {
                        let result = ratesData.filter( { $0.key.hasPrefix("USD") } )
                        self?.usdValue = result.first?.value ?? 0.0
                        for (key, value) in ratesData {
                            let roundedValue = (value * 1000).rounded() / 1000
                            self?.objectArray.append(Objects(sectionCurrency: key, sectionAmount: roundedValue))
                        }
                    }
                }
                DispatchQueue.main.async {
                    self?.tableView.delegate = self
                    self?.tableView.dataSource = self
                    self?.tableView.reloadData()
                }
            }) {
                (error) -> Void in
                print(error)
                self.showAlertView(title: "Message", message: error.localizedDescription, actions: nil)
            }
        }
    }
    
}

//MARK:- TableView delegate and datasource methods

extension HomeVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: homeCurrencyCell = tableView.dequeueReusableCell(for: indexPath)
        cell.currencyLabel.text = objectArray[indexPath.row].sectionCurrency
        cell.valueLabel.text = "\(objectArray[indexPath.row].sectionAmount ?? 0.0)"
        return cell
    }
    
    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = AmountVC()
        var systemVersion = UIDevice.current.systemVersion
        var systemName = UIDevice.current.systemName
        var check = "\(systemName)"+":"+"\(systemVersion)"
        print("\(check)")
        print("check---\(systemVersion)--\(systemName)")
        
        vc.currencyLabelStr = objectArray[indexPath.row].sectionCurrency
        vc.selectedAmount = objectArray[indexPath.row].sectionAmount
        vc.usdAmount = usdValue
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
