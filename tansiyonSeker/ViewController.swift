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
    
    var savedTansiyonArray = [TansiyonModel]()
    var savedSekerArray = [SekerModel]()
    
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
    var timeCount = Date()
    var sekerOrTansiyonCounter = 0
    var sekerOrTansiyonSavedCounter = 0
    
    let defaults = UserDefaults.standard
  
    let tansiyonPickerView = UIPickerView()
    let sekerPickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedTableView.dataSource = self
        feedTableView.delegate = self
        feedTableView.register(UINib(nibName: "SaveTableViewCell", bundle: nil), forCellReuseIdentifier: "SaveTableViewCell")
        view.isUserInteractionEnabled = true
        tansiyonPickerView.delegate = self
        tansiyonPickerView.dataSource = self
        sekerPickerView.delegate = self
        sekerPickerView.dataSource = self
        tansiyonPickerView.tag = 0
        sekerPickerView.tag = 1
        setDefaultValueForTansiyonandSekerPicker()
        let model = TansiyonModel(bTansiyon: 120, ktansiyon: 20, nabiz: 40, time: "a")
        savedTansiyonArray.append(model)
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
            self.sekerOrTansiyonSavedCounter = 1
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
    
    // TO DO -- Save all collected data in UserDefaults --
    
    @objc func doneTapped() {
        switch sekerOrTansiyonSavedCounter {
        case 0:
            let bigTansiyonSaved = tansiyonBigArray[tansiyonPickerView.selectedRow(inComponent: 0)]
            let littleTansiyonSaved = tansiyonLittleArray[tansiyonPickerView.selectedRow(inComponent: 1)]
            let heartBeatSaved = heartBeatArray[tansiyonPickerView.selectedRow(inComponent: 2)]
            let model = TansiyonModel(bTansiyon: bigTansiyonSaved, ktansiyon: littleTansiyonSaved, nabiz: heartBeatSaved, time: keepTime(date: timeCount))
            savedTansiyonArray.append(model)
            feedTableView.reloadData()
        case 1:
            let sekerAcTokSaved = sekeractokArray[sekerPickerView.selectedRow(inComponent: 0)]
            let sekerDegerSaved = sekerdegerArray[sekerPickerView.selectedRow(inComponent: 1)]
            let model = SekerModel(actok: sekerAcTokSaved, seker: sekerDegerSaved, time: keepTime(date: timeCount))
            savedSekerArray.append(model)
        default:
            print("Error")
        }
    }
    
    @objc func dismissTapped() {
        dismiss(animated: true, completion: nil)
        sekerOrTansiyonSavedCounter = 0
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
            let flewibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let doneButton = UIBarButtonItem(title: ValueClass.saveButtonString, style: .plain, target: self, action: #selector(self.doneTapped))
            let exitButton = UIBarButtonItem(title: "Vazgeç", style: .done, target: self, action: #selector(self.dismissTapped))
            toolbar.setItems([exitButton,flewibleSpace,doneButton], animated: true)
            toolbar.isUserInteractionEnabled = true
            textField.inputView = input
            textField.inputAccessoryView = toolbar
        }
        
        present(alertController, animated: true, completion: nil)
    }
    
    func keepTime(date: Date) -> String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm dd/MM/yyyy"
        let time = formatter.string(from: date)
        return time
    }
}


// MARK: - ViewController: UITableViewDataSource, UITableViewDelegate -

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedTansiyonArray.count
    }
    
    
//    - TO DO-  use sekerOrTansiyonSavedCounter to load tableview --
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SaveTableViewCell") as? SaveTableViewCell {
            cell.resultLabel.text = "B:\(savedTansiyonArray[indexPath.row].bTansiyon ?? 120) K:\(savedTansiyonArray[indexPath.row].ktansiyon ?? 80) \(savedTansiyonArray[indexPath.row].nabiz ?? 60)"
            cell.savetimeLabel.text = "\(savedTansiyonArray[indexPath.row].time ?? "26/02 00:02")"
            return cell
        } else {
            let cell = UITableViewCell()
            cell.textLabel?.text = "Patladı"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            savedTansiyonArray.remove(at: indexPath.row)
            feedTableView.deleteRows(at: [indexPath], with: .bottom)
            feedTableView.reloadData()
            
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
                    setLabelForComponents(text: ValueClass.bigtansiyonString, xValue: pickerViev.frame.width * 0.15, yValue: pickerViev.frame.height * 0.05)
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
                    setLabelForComponents(text: ValueClass.heartBeatString, xValue: pickerViev.frame.width * 0.75, yValue: pickerViev.frame.height * 0.05)
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
                    setLabelForComponents(text: ValueClass.sekerDegerString, xValue: pickerViev.frame.width * 0.85, yValue: pickerViev.frame.height * 0.45)
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
        tansiyonPickerView.selectRow(119, inComponent: 0, animated: true)
        tansiyonPickerView.selectRow(79, inComponent: 1, animated: true)
        tansiyonPickerView.selectRow(15, inComponent: 2, animated: true)
        sekerPickerView.selectRow(0, inComponent: 0, animated: true)
        sekerPickerView.selectRow(69, inComponent: 1, animated: true)
        sekerPickerView.selectedRow(inComponent: 0)
    }
}
