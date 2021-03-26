//
//  AddPickerViewController.swift
//  tansiyonSeker
//
//  Created by Alperen Kişi on 10/03/2021.
//

import UIKit

class AddPickerViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource{
 
    @IBOutlet weak var addPicker: UIPickerView!
    
    let acTokArray = ["Aç","Tok"]
    let sekerArray = [1...200]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    

    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sekerArray.count
    }
  
    
    

}
