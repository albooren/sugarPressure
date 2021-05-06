//
//  Model.swift
//  tansiyonSeker
//
//  Created by Alperen Kişi on 04/04/2021.
//

import Foundation

class TansiyonVeSekerModel {
    
    var bTansiyon: Int?
    var ktansiyon: Int?
    var nabiz: Int?
    var actok: String?
    var seker: Int?
    var time: String?
    
    init(bTansiyon: Int? = nil, ktansiyon: Int? = nil, nabiz: Int? = nil, actok: String? = nil, seker: Int? = nil, time: String? = nil) {
        self.bTansiyon = bTansiyon
        self.ktansiyon = ktansiyon
        self.nabiz = nabiz
        self.actok = actok
        self.seker = seker
        self.time = time
    }
}
