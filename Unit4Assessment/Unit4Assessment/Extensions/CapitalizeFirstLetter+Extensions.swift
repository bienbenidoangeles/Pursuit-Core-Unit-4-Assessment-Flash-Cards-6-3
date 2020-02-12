//
//  CapitalizeFirstLetter+Extensions.swift
//  Unit4Assessment
//
//  Created by Bienbenido Angeles on 2/12/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
       return prefix(1).uppercased() + self.lowercased().dropFirst()
     }

     mutating func capitalizeFirstLetter() {
       self = self.capitalizingFirstLetter()
     }
}
