//
//  homeCurrencyCell.swift
//  Gmaterial
//
import UIKit
import SnapKit

class homeCurrencyCell: UITableViewCell {
    
    let currencyLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.font = UIFont(name: "Ubuntu-Bold", size: 17)
        label.textColor = UIColor(hexString: "#C55300")
        label.numberOfLines = 0
        return label
    }()
    let valueLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.font = UIFont(name: "Ubuntu-Bold", size: 17)
        label.textColor = UIColor(hexString: "#C55300")
        label.numberOfLines = 0
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupUi()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func setupUi() {
        contentView.backgroundColor = UIColor(hexString: "#FFFDEF")
        let stackView = UIStackView(arrangedSubviews: [currencyLabel, valueLabel])
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        stackView.axis = .horizontal
        stackView.backgroundColor = UIColor(hexString: "#FFFDEF")
        self.contentView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(-15)
            make.right.equalTo(15)
            make.centerY.equalTo(self.contentView)
        }
    }
}
