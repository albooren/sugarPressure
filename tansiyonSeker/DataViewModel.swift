//
//  DataViewModel.swift
//  tansiyonSeker
//
//  Created by Alperen Kişi on 01/05/2021.

import Foundation
import FirebaseDatabase
import FirebaseFirestore

class DataViewModel {
    @Published var tansiyonSeker = [TansiyonVeSekerModel]()
    private var db = Firestore.firestore()
    
    func fetchData() {
        db.collection("tansiyonVeSekerData").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            for document in documents {
                if let kTansiyon = document.get("kTansiyon") as? Int {
                    print(kTansiyon)
                }
            }
        }
    }
}
