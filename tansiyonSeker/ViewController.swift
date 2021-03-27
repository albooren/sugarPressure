//
//  ViewController.swift
//  tansiyonSeker
//
//  Created by Alperen Kişi on 25/02/2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var feedTableView: UITableView!
    @IBOutlet var feedNavigationBar: UINavigationBar!
    @IBOutlet weak var addDataBarButton: UIBarButtonItem!
    
    var containerView = UIView()
    var tansiyonBigArray = Array(1...200)
    var tansiyonLittleArray = Array(1...100)
    var heartBeatArray = Array(45...160)
    var sekeractokArray = ["Aç", "Tok"]
    var sekerdegerArray = Array(1...300)
    var firstComponentCounter = 0
    var secondComponentCounter = 0
    var thirdComponentCounter = 0
    var fourthComponentCounter = 0
    var fifthComponentCounter = 0
    
    var sekerOrTansiyonCounter = 0
    
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
        tansiyonPickerView.tag = 0
        sekerPickerView.tag = 1
        
        setDefaultValueForTansiyonandSekerPicker()
        
    }
    
    @IBAction func addBarButtonClicked(_ sender: Any) {
        callAddSheet()
    }
    
    func callAddSheet() {
        let chooseSheet = UIAlertController(title: ValueClass.pickValueSheetString , message: nil, preferredStyle: .actionSheet)
        chooseSheet.addAction(UIAlertAction(title: ValueClass.tansiyonString, style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            self.tansiyonEkle(action: UIAlertAction)
        }))
        chooseSheet.addAction(UIAlertAction(title: ValueClass.sekerString, style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            self.sekerEkle(action: UIAlertAction)
        }))
        chooseSheet.addAction(UIAlertAction(title: ValueClass.exitString, style: .cancel))
        present(chooseSheet, animated: true)
    }
    
    func tansiyonEkle(action:UIAlertAction){
        makePicker(title: ValueClass.tansiyonAddString, input: tansiyonPickerView)
    }
    
    func sekerEkle(action:UIAlertAction){
        makePicker(title: ValueClass.sekerString, input: sekerPickerView)
    }
    
    @objc func doneTapped() {
        print("doneTapped")
    }
    
    @objc func dismissTapped() {
        dismiss(animated: true, completion: nil)
    }

    func setLabelForComponents(text: String, xValue: CGFloat, yValue: CGFloat) {
        let label = UILabel()
        label.text = text
        label.sizeToFit()
        label.frame = CGRect(x: xValue, y: yValue, width: label.frame.width + 1.5, height: label.frame.height)
        if sekerOrTansiyonCounter == 0 {
            tansiyonPickerView.addSubview(label)
        } else {
            sekerPickerView.addSubview(label)
        }
    }
   
    func makePicker(title: String ,input: UIPickerView) {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alertController.addTextField { [weak self] (textField) in
            guard let self = self else { return }
            let toolbar = UIToolbar()
            toolbar.barStyle = .default
            toolbar.isTranslucent = true
            toolbar.tintColor = .black
            toolbar.sizeToFit()
            let doneButton = UIBarButtonItem(title: ValueClass.saveButtonString, style: .plain, target: self, action: #selector(self.doneTapped))
            let exitButton = UIBarButtonItem(title: "Vazgeç", style: .done, target: self, action: #selector(self.dismissTapped))
            toolbar.setItems([exitButton, doneButton], animated: true)
            toolbar.isUserInteractionEnabled = true
            textField.inputView = input
            textField.inputAccessoryView = toolbar
        }
        // - TO DO - handler will be process
        present(alertController, animated: true, completion: nil)
    }
}


// MARK: - ViewController: UITableViewDataSource, UITableViewDelegate -

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TO DO: Class name change to "SaveTableViewCell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: "saveTableViewCell") as? saveTableViewCell {
            cell.tansiyonSekerLabel.text = "T:120/85 N:85"
            cell.dateHourLabel.text = "26/02 00:02"
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

// MARK: - ViewController : UIPickerViewDataSource, UIPickerViewDelegate -

extension ViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch pickerView.tag {
        case 0:
            return 3
        case 1:
            return 2
        default:
            return 1
        }
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 0:
            switch component {
                case 0:
                    return tansiyonBigArray.count
                case 1 :
                    return tansiyonLittleArray.count
                case 2:
                    return heartBeatArray.count
            default:
                return 0
            }
        case 1 :
            switch component {
                case 0:
                    return sekeractokArray.count
                case 1 :
                    return sekerdegerArray.count
                default:
                    return 0
            }
        default: return 1
        }
    }
    func pickerView(_ pickerViev: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerViev.tag {
        case 0:
            switch component {
            case 0:
                firstComponentCounter += 1
                if firstComponentCounter == 1 {
                    setLabelForComponents(text: ValueClass.bigtansiyonString, xValue: pickerViev.frame.width * 0.05, yValue: pickerViev.frame.height * 0.05)
                }
                return String(tansiyonBigArray[row])
            case 1:
                secondComponentCounter += 1
                if secondComponentCounter == 1 {
                    setLabelForComponents(text: ValueClass.littletansiyonString, xValue: pickerViev.frame.width * 0.45, yValue: pickerViev.frame.height * 0.05)
                }
                return String(tansiyonLittleArray[row])
            case 2 :
                thirdComponentCounter += 1
                if thirdComponentCounter == 1 {
                    setLabelForComponents(text: ValueClass.heartBeatString, xValue: pickerViev.frame.width * 0.90, yValue: pickerViev.frame.height * 0.05)
                }
                return String(heartBeatArray[row])
            default:
                return ""
            }
        case 1:
            switch component {
            case 0:
                return String(sekeractokArray[row])
            case 1:
                fifthComponentCounter += 1
                if fifthComponentCounter == 1 {
                    sekerOrTansiyonCounter = 1
                    setLabelForComponents(text: ValueClass.sekerDegerString, xValue: pickerViev.frame.width * 1, yValue: pickerViev.frame.height * 0.45)
                    }
                return String(sekerdegerArray[row])
            default:
                return ""
            }
        default:
            return ""
        }
    }
    func setDefaultValueForTansiyonandSekerPicker(){
        tansiyonPickerView.selectRow(220, inComponent: 0, animated: true)
        tansiyonPickerView.selectRow(79, inComponent: 1, animated: true)
        tansiyonPickerView.selectRow(15, inComponent: 2, animated: true)
        sekerPickerView.selectRow(0, inComponent: 0, animated: true)
        sekerPickerView.selectRow(69, inComponent: 1, animated: true)
    }
}
