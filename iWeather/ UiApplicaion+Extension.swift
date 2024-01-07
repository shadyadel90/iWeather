//
//   UiApplicaion+Extension.swift
//  iWeather
//
//  Created by Shady Adel on 04/01/2024.
//

import UIKit

extension UIApplication {
    func endEditing(){
        sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
