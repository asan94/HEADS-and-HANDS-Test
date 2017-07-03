//
//  AuthorizationViewControllerVM.swift
//  HEADS and HANDS Test
//
//  Created by Аметов Асан on 29.06.17.
//  Copyright © 2017 Asan Ametov. All rights reserved.
//

import UIKit
import Bond
import ReactiveKit

class AuthorizationViewControllerVM {
    
    let login = Observable<String?>("")
    let password = Observable<String?>("")
    let validLogin = Observable<Bool>(false)
    let validPassword = Observable<Bool>(false)
  
    let weatherInProgress = Observable<Bool>(false)
    let errorMessages = PublishSubject<Error, NoError>()
    let resultMessages = PublishSubject<String, NoError>()
    
    init() {
        self.login
            .map { ($0?.isEmail())!}
            .bind(to: validLogin)
        self.password
            .map{ ($0?.isPassword())!}
            .bind(to: validPassword)
 
    }

    func getWeather() {
        guard self.validLogin.value  else {
            let error = NSError().errorWithDescriprionEndErrorCode(errorCode: -10, description: "Некорректный email")
            self.errorMessages.next(error)
            return
                  
        }
         guard self.validPassword.value  else {
            let error = NSError().errorWithDescriprionEndErrorCode(errorCode: -10, description: "Пароль - минимум 6 символов, должен обязательно содержать минимум 1 строчную букву, 1 заглавную и 1 цифру")
            self.errorMessages.next(error)
            return
        }
        self.weatherInProgress.value = true
       API.Weather.GetWeather().responseObject(WeatherData.self) { (weather, error) in
            self.weatherInProgress.value = false
            if error != nil {
                self.errorMessages.next(error!)
            } else {
                let temp: String = String(describing: weather!.weather!.first!.temp!) + " "
                let message = temp + (weather?.weather?.first?.specification?.first?.specification)!
                self.resultMessages.next(message)
            }
        }
    }
    
}
