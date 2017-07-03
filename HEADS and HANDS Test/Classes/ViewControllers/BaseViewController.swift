//
//  BaseViewController.swift
//  HEADS and HANDS Test
//
//  Created by Аметов Асан on 29.06.17.
//  Copyright © 2017 Asan Ametov. All rights reserved.
//

import UIKit
import MBProgressHUD
class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func showHUD() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
    }
    
    
    func dismissHUD() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    func showWithTitle(alertTitle: String, message: String) {
        showWhithTitleMessageCancelButtonActions(title: alertTitle, message: message, cancelButtonTitle: "OK")
    }
    
    func showWithError(error: NSError) {
        if error.code == -1009 {
            openSettingsNotificationScreen()
            return
        }
        if error.code == -1001 {
            showWhithTitleMessageCancelButtonActions(title: "Ошибка", message: "Время ожидания истекло, повторите повторно", cancelButtonTitle: "OK")
            return
        }
        showWhithTitleMessageCancelButtonActions(title: "Ошибка", message: error.localizedDescription, cancelButtonTitle: "OK")
    }
    
    func showWhithTitleMessageCancelButtonActions(title: String, message: String, cancelButtonTitle: String) {
        DispatchQueue.main.async {
            
            let alertViewController = UIAlertController(title:title, message: message as String, preferredStyle: .alert)
            let cancel = UIAlertAction(title: cancelButtonTitle, style: .cancel) { (action) -> Void in
                
            }
            alertViewController.addAction(cancel)
            
            if self.presentedViewController == nil {
                self.present(alertViewController, animated: true, completion: nil)
            } else {
                
                self.dismiss(animated: false, completion: {
                    self.present(alertViewController, animated: true, completion: nil)
                })
            }
        }
    }
    func openSettingsNotificationScreen() -> Void {
        let alertController = UIAlertController (title: "Передача данных по сотовой сети выключена", message: "Для доступа к данным включите передачу данных по сотовой сети или используйте Wi-Fi", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Настройки", style: .default) { (_) -> Void in
            
            let settingsUrl = URL(string:"prefs:root=General&path=Network")
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(settingsUrl!, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(settingsUrl!)
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
    }


}
