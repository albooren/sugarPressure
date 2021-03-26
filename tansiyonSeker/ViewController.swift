//
//  ViewController.swift
//  tansiyonSeker
//
//  Created by Alperen Kişi on 25/02/2021.
//

import UIKit
import MaterialComponents


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate {
    @IBOutlet var feedTableView: UITableView!
    @IBOutlet var feedNavigationBar: UINavigationBar!
    @IBOutlet weak var addDataBarButton: UIBarButtonItem!    
    var containerView = UIView()
    var tansiyonBigArray = Array(1...200)
    var tansiyonLittleArray = Array(1...100)
    var sekerDurumArray = ["Aç","Tok"]
    var sekerStatusArray = Array(1...300)
    
    let tansiyonPickerView = UIPickerView()
    let sekerPickerView = UIPickerView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedTableView.dataSource = self
        feedTableView.delegate = self
        view.isUserInteractionEnabled = true
        tansiyonPickerView.delegate = self
        tansiyonPickerView.dataSource = self
        sekerPickerView.delegate = self
        sekerPickerView.dataSource = self
    }
    
    
    @IBAction func addBarButtonClicked(_ sender: Any) {
        callAddSheet()
        
    }
    func callAddSheet() {
        let chooseSheet = UIAlertController(title: "Girmek istediğin bilgiyi seçiniz!", message: nil, preferredStyle: .actionSheet)
        chooseSheet.addAction(UIAlertAction(title: "Tansiyon", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            self.tansiyonEkle(action: UIAlertAction)
        }))
        chooseSheet.addAction(UIAlertAction(title: "Şeker", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            self.sekerEkle(action: UIAlertAction)
        }))
        chooseSheet.addAction(UIAlertAction(title: "Çık", style: .cancel))
        present(chooseSheet, animated: true)
    }
    func tansiyonEkle(action:UIAlertAction){
        print("Tansiyon butonuna Basıldı")
        makePicker(title: "Tansiyon Ekle!", input: tansiyonPickerView)
    }

    func sekerEkle(action:UIAlertAction){
        print("Şeker butonuna Basıldı")
        makePicker(title: "Şeker Ekle!", input: sekerPickerView)

    }
    @objc func doneTapped(){
     print("Tapped")
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerViev: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            let bigTansiyonLabel = UILabel()
            bigTansiyonLabel.text = "Büyük"
            bigTansiyonLabel.sizeToFit()
            bigTansiyonLabel.frame = CGRect(x: pickerViev.frame.width * 0.20, y: pickerViev.frame.height * 0.20, width: bigTansiyonLabel.frame.width+0.90, height: bigTansiyonLabel.frame.height)
            tansiyonPickerView.addSubview(bigTansiyonLabel)
                return String(tansiyonBigArray[row])
        } else {
            let kucukTansiyonLabel = UILabel()
            kucukTansiyonLabel.text = "Küçük"
            kucukTansiyonLabel.sizeToFit()
            kucukTansiyonLabel.textAlignment = NSTextAlignment.center
            kucukTansiyonLabel.frame = CGRect(x: pickerViev.frame.width * 0.75, y: pickerViev.frame.height * 0.20, width: kucukTansiyonLabel.frame.width+2, height: kucukTansiyonLabel.frame.height)
            tansiyonPickerView.addSubview(kucukTansiyonLabel)

                return String(tansiyonLittleArray[row])
                }
            }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
                    return tansiyonBigArray.count
                }

                else {
                    return tansiyonLittleArray.count
                }
}


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("saveTableViewCell", owner: ViewController.self, options: nil)?.first as! saveTableViewCell
        cell.tansiyonSekerLabel.text = "T:120/85 N:85"
        cell.dateHourLabel.text = "26/02 00:02"
        return cell
    }

    func makePicker(title : String,input : UIPickerView){
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alertController.addTextField { (textField) in

            let toolbar = UIToolbar()
            toolbar.barStyle = .default
            toolbar.isTranslucent = true
            toolbar.tintColor = .black
            toolbar.sizeToFit()
            let doneButton = UIBarButtonItem(title: "Kaydet", style: .plain, target: self, action: #selector(self.doneTapped))
            toolbar.setItems([doneButton], animated: true)
            toolbar.isUserInteractionEnabled = true
            textField.inputView = input
            textField.inputAccessoryView = toolbar
        }
        // - TO DO - handler will be process
        self.present(alertController, animated: true, completion: nil)
    }

    }
    
   
    
    

