//
//  CustomPopUpVC.swift
//
//

import UIKit
import CoreLocation

final class CustomPopUpVC: UIViewController {
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var amountValue: UILabel!
    @IBOutlet weak var quantityValue: UILabel!
    var onConfirmDoneBlock: ((Bool) -> Void)?
    var amountStr: String = ""
    var quantityStr: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        amountValue.text = amountStr
        quantityValue.text = quantityStr
        popUpView.backgroundColor = UIColor(hexString: "#EEEEEE")
        popUpView.layer.shadowOpacity = 0.1
        popUpView.layer.cornerRadius = 16
        setupBtnShadowLayer()
    }
    
    private func setupBtnShadowLayer() {
        cancelButton.layer.cornerRadius = 20
        cancelButton.layer.borderColor = UIColor.white.cgColor
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        cancelButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        cancelButton.layer.shadowOpacity = 0.8
        cancelButton.layer.shadowRadius = 5.0
        cancelButton.layer.masksToBounds = false
        
        confirmButton.layer.borderColor = UIColor.white.cgColor
        confirmButton.layer.borderWidth = 1
        confirmButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        confirmButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        confirmButton.layer.shadowOpacity = 0.8
        confirmButton.layer.shadowRadius = 5.0
        confirmButton.layer.cornerRadius = 20
        confirmButton.layer.masksToBounds = false
    }
    @IBAction func actionForCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionForConfirm(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        onConfirmDoneBlock?(true)
    }
}
