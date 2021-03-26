//
//  ViewController.swift
//  tansiyonSeker
//
//  Created by Alperen Kişi on 25/02/2021.
//

import UIKit


class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet var feedTableView: UITableView!
    @IBOutlet var feedNavigationBar: UINavigationBar!
    @IBOutlet weak var addDataBarButton: UIBarButtonItem!
    
    var containerView = UIView()
    var tansiyonBigArray = Array(1...200)
    var tansiyonLittleArray = Array(1...100)
    var sekerDurumArray = ["Aç","Tok"]
    var sekerStatusArray = Array(1...300)
    var firstComponentCounter = 0
    var secondComponentCounter = 0
    
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
        makePicker(title: "Tansiyon Ekle!", input: tansiyonPickerView)
    }
    
    func sekerEkle(action:UIAlertAction){
        makePicker(title: "Şeker Ekle!", input: sekerPickerView)
    }
    
    @objc func doneTapped(){
        print("Tapped")
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerViev: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            firstComponentCounter += 1
            if firstComponentCounter == 1 {
                let bigTansiyonLabel = UILabel()
                bigTansiyonLabel.text = "Büyük"
                bigTansiyonLabel.sizeToFit()
                bigTansiyonLabel.frame = CGRect(x: pickerViev.frame.width * 0.15, y: pickerViev.frame.height * 0.20, width: bigTansiyonLabel.frame.width + 0.90, height: bigTansiyonLabel.frame.height)
                tansiyonPickerView.addSubview(bigTansiyonLabel)
            }
            return String(tansiyonBigArray[row])
        case 1:
            secondComponentCounter += 1
            if secondComponentCounter == 1 {
                let kucukTansiyonLabel = UILabel()
                kucukTansiyonLabel.text = "Küçük"
                kucukTansiyonLabel.sizeToFit()
                kucukTansiyonLabel.textAlignment = NSTextAlignment.center
                kucukTansiyonLabel.frame = CGRect(x: pickerViev.frame.width * 1, y: pickerViev.frame.height * 0.20, width: kucukTansiyonLabel.frame.width + 2, height: kucukTansiyonLabel.frame.height)
                tansiyonPickerView.addSubview(kucukTansiyonLabel)
            }
            return String(tansiyonLittleArray[row])
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return tansiyonBigArray.count
        } else {
            return tansiyonLittleArray.count
        }
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

// MARK: - ViewController: UITableViewDataSource, UITableViewDelegate -

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("saveTableViewCell", owner: ViewController.self, options: nil)?.first as! saveTableViewCell
        cell.tansiyonSekerLabel.text = "T:120/85 N:85"
        cell.dateHourLabel.text = "26/02 00:02"
        return cell
    }
}
