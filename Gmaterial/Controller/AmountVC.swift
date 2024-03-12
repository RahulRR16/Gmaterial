//
//  AmountVC.swift
//  Gmaterial
//
//

import UIKit
import SnapKit

class AmountVC: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "TOP-UP"
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexString: "#FFFDEF")
        return view
    }()
    
    private let amountTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .decimalPad
        textField.textColor = UIColor(hexString: "#E38B29")
        textField.font = .systemFont(ofSize: 80)
        textField.placeholder = "0.0"
        textField.textAlignment = .natural
        return textField
    }()
    
    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .justified
        label.text = "USD"
        label.font = .boldSystemFont(ofSize: 35)
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()
    
    private let minimumAmountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Minimun amount 0.01 USD"
        label.font = .systemFont(ofSize: 17)
        label.textColor = .systemGray
        label.numberOfLines = 0
        return label
    }()
    
    private let inGramsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "0.0 in grams"
        label.font = .systemFont(ofSize: 17)
        label.textColor = .systemGray
        label.numberOfLines = 0
        return label
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.setTitle("Confirm Payment", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .gray
        return button
    }()
    var confirmButtonState: Bool = false
    var currencyLabelStr: String?
    var selectedAmount: Double = 0.0
    var usdAmount: Double = 0.0
    var amountStr: String = ""
    var quantityStr: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexString: "#FFFDEF")
        setupLayout()
        setupUI()
        hideKeyboardWhenTappedAround()
        confirmButton.addTarget(self, action: #selector(actionForConfirmButton), for: .touchUpInside)
    }
    
    private func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [amountTextField, currencyLabel])
        stackView.alignment = .bottom
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.axis = .horizontal
        stackView.backgroundColor = UIColor(hexString: "#FFFDEF")
        
        self.view.addSubview(titleLabel)
        self.view.addSubview(containerView)
        self.view.addSubview(stackView)
        containerView.addSubview(minimumAmountLabel)
        self.view.addSubview(inGramsLabel)
        self.view.addSubview(confirmButton)
        
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(60)
            make.top.left.right.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        containerView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(titleLabel.snp.bottom).offset(0)
            make.width.equalTo(300)
            make.centerX.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(150)
        }
        
        stackView.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.containerView)
            make.centerY.equalTo(self.containerView)
        }
        amountTextField.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(80)
        }
        
        minimumAmountLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(stackView.snp.bottom).offset(10)
            make.centerX.equalTo(self.containerView)
        }
        
        inGramsLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.containerView.snp.bottom).offset(20)
            make.height.equalTo(24)
            make.centerX.equalTo(self.containerView)
        }
        confirmButton.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.inGramsLabel.snp.bottom).offset(80)
            make.width.equalTo(180)
            make.height.equalTo(50)
        }
    }
    
    private func setupUI() {
        currencyLabel.text = "USD"
        minimumAmountLabel.text = "Minimum amount 0.01 USD"
        confirmBtnShadowSetup()
        amountTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        amountTextField.delegate = self
    }
    private func confirmBtnShadowSetup() {
        confirmButton.layer.cornerRadius = 26
        confirmButton.layer.borderColor = UIColor.white.cgColor
        confirmButton.layer.borderWidth = 1
        confirmButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        confirmButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        confirmButton.layer.shadowOpacity = 0.8
        confirmButton.layer.shadowRadius = 5.0
        confirmButton.layer.masksToBounds = false
    }
    @objc func textDidChange(textField _: UITextField) {
        validateUserInput()
    }
    
    func validateUserInput() {
        let validate = amountTextField.text!.count > 0
        confirmButton.backgroundColor = validate ? UIColor(hexString: "#8C0000") : .gray
        confirmButton.isEnabled = validate ? true : false
        confirmButtonState = validate ? true : false
        toGetAmountInGrams()
    }
    
    @objc func actionForConfirmButton() {
        if confirmButtonState {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "CustomPopUpVC") as! CustomPopUpVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            vc.amountStr = amountStr
            vc.quantityStr = quantityStr
            vc.onConfirmDoneBlock = { _ in
                AlertHelper.showToast(controller: self, message: "Transaction Successful", seconds: 2.0)
                self.view.endEditing(true)
            }
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func toGetAmountInGrams() {
        let gramsAmount = usdAmount / 28.34
        let amount = (Double(amountTextField.text!) ?? 0.0) / gramsAmount
        let roundedValue = (amount * 1000).rounded() / 1000
        inGramsLabel.text = "\(roundedValue) in grams"
        amountStr = amountTextField.text!
        quantityStr = "\(roundedValue) in grams"
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension AmountVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        amountTextField.resignFirstResponder()
        return true
    }
}
