//
//  AuthorizationViewController.swift
//  HEADS and HANDS Test
//
//  Created by Аметов Асан on 29.06.17.
//  Copyright © 2017 Asan Ametov. All rights reserved.
//

import UIKit
import Bond
import ReactiveKit

class AuthorizationViewController: BaseViewController {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var activityView: UIView!
    
    private let viewModel = AuthorizationViewControllerVM()


    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupRAC()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func setupRAC() {
      
        self.viewModel.login.bidirectionalBind(to: loginTextField.reactive.text)
        self.viewModel.password.bidirectionalBind(to: passwordTextField.reactive.text)
        self.viewModel.validLogin
            .map {$0 ? .black :.red}
            .bind(to: loginTextField.reactive.textColor)
        self.viewModel.validPassword
            .map {$0 ? .black :.red}
            .bind(to: passwordTextField.reactive.textColor)
    
        combineLatest(loginTextField.reactive.text, passwordTextField.reactive.text) { email, pass in
                return (email?.length)! > 0 && (pass?.length)! > 0
            }
            .bind(to: loginButton.reactive.isEnabled)
        
        self.viewModel.weatherInProgress
            .map { !$0 }.bind(to: activityView.reactive.isHidden)

       self.viewModel.weatherInProgress.map { !$0}.bind(to: loginButton.reactive.isEnabled)
 
        _ = viewModel.errorMessages.observeNext {
            [unowned self] error in
             self.showWithError(error: error as NSError)
        }
        _ = viewModel.resultMessages.observeNext {
            [unowned self] result in
            self.showWithTitle(alertTitle: "Погода в Москве", message: result)
        }

    }
    
    @IBAction func loginHandler(_ sender: UIButton) {
        self.viewModel.getWeather()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

