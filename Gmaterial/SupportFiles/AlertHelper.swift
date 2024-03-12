//
//  AlertHelper.swift
//
//

import UIKit

class AlertHelper {
    public static func showToast(controller: UIViewController, message: String, seconds: Double) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.alpha = 1.0
        alert.view.layer.cornerRadius = 15

        controller.present(alert, animated: false)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: false)
        }
    }

    public static func showOkCancelAlert(controller: UIViewController,
                                         title: String? = nil,
                                         okayText: String? = nil,
                                         cancelText: String? = nil,
                                         showCancel: Bool = true,
                                         message: String,
                                         positiveAction: (() -> Void)? = nil,
                                         negativeAction: (() -> Void)? = nil) {
        let alertDialog = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let ok = UIAlertAction(title: (okayText != nil) ? okayText : "yes", style: .default) { _ in
            positiveAction?()
        }

        let cancel = UIAlertAction(title: (cancelText != nil) ? cancelText : "cancel", style: .cancel) { _ in
            negativeAction?()
        }
        if showCancel {
            alertDialog.addAction(cancel)
        }
        alertDialog.addAction(ok)

        controller.present(alertDialog, animated: true, completion: nil)
    }
}
