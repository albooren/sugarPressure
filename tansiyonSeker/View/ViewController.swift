//
//  ViewController.swift
//  tansiyonSeker
//
//  Created by Alperen Kişi on 25/02/2021.
//

import UIKit
import Firebase
import FirebaseCore

class ViewController: UIViewController {
    
    @IBOutlet var feedTableView: UITableView!
    @IBOutlet var feedNavigationBar: UINavigationBar!
    @IBOutlet weak var addDataBarButton: UIBarButtonItem!
    
    var tansiyonVeSekerTotalArray = [TansiyonVeSekerModel]()
    var tansiyonBigArray = Array(1...200)
    var tansiyonLittleArray = Array(1...100)
    var heartBeatArray = Array(45...160)
    var sekeractokArray = ["Aç", "Tok"]
    var sekerdegerArray = Array(1...300)
    var buyukTansiyonLabelCounter = 0
    var kucukTansiyonLabelCounter = 0
    var nabizLabelCounter = 0
    var acTokLabelCounter = 0
    var sekerLabelCounter = 0
    var timeCount = Date()
    var sekerOrTansiyonCounter = 0
    var sekerOrTansiyonSavedCounter = 0
    var userDefaults = UserDefaults()
    
    var ref : DatabaseReference!
    let db = Firestore.firestore()
    
    let tansiyonPickerView = UIPickerView()
    let sekerPickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedTableView.dataSource = self
        feedTableView.delegate = self
        feedTableView.register(UINib(nibName: "SaveTableViewCell", bundle: nil), forCellReuseIdentifier: "SaveTableViewCell")
        tansiyonPickerView.delegate = self
        tansiyonPickerView.dataSource = self
        sekerPickerView.delegate = self
        sekerPickerView.dataSource = self
        tansiyonPickerView.tag = 0
        sekerPickerView.tag = 1
        setDefaultValueForTansiyonandSekerPicker()
        ref = Database.database().reference()
        fetchData()
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
//            let model = TansiyonVeSekerModel(bTansiyon: bigTansiyonSaved, ktansiyon: littleTansiyonSaved, nabiz: heartBeatSaved, time: keepTime(date: timeCount))
//            tansiyonVeSekerTotalArray.append(model)
            tansiyonVeSekerTotalArray.removeAll()
            db.collection("tansiyonVeSekerData").addDocument(data: ["kTansiyon" : littleTansiyonSaved,"bTansiyon" : bigTansiyonSaved, "nabiz" : heartBeatSaved, "time" : keepTime(date: timeCount)])

            dismiss(animated: true, completion: nil)
        case 1:
            let sekerAcTokSaved = sekeractokArray[sekerPickerView.selectedRow(inComponent: 0)]
            let sekerDegerSaved = sekerdegerArray[sekerPickerView.selectedRow(inComponent: 1)]
            tansiyonVeSekerTotalArray.removeAll()
             db.collection("tansiyonVeSekerData").addDocument(data: ["acTok" : sekerAcTokSaved,"sekerDeger" : sekerDegerSaved, "time" : keepTime(date: timeCount)])
            sekerOrTansiyonSavedCounter = 0
            dismiss(animated: true, completion: nil)
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
        formatter.dateFormat = "HH:mm dd/MM"
        let time = formatter.string(from: date)
        return time
    }
    
    func fetchData() {
        db.collection("tansiyonVeSekerData").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            for document in documents {
                if let kTansiyon = document.get("kTansiyon") as? Int,let bTansiyon = document.get("bTansiyon") as? Int,let nabiz = document.get("nabiz") as? Int, let time = document.get("time") as? String{
                    let model = TansiyonVeSekerModel(bTansiyon: bTansiyon, ktansiyon: kTansiyon,nabiz: nabiz, time: time)
                    self.tansiyonVeSekerTotalArray.append(model)
                }
                if let acTok = document.get("acTok") as? String,let sekerDeger = document.get("sekerDeger") as? Int,let time = document.get("time") as? String {
                    let model = TansiyonVeSekerModel(actok: acTok, seker: sekerDeger, time: time)
                    self.tansiyonVeSekerTotalArray.append(model)
                }
            }
            self.feedTableView.reloadData()
        }
    }
}


// MARK: - ViewController: UITableViewDataSource, UITableViewDelegate -

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tansiyonVeSekerTotalArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SaveTableViewCell") as? SaveTableViewCell {
            if tansiyonVeSekerTotalArray[indexPath.row].bTansiyon != nil {
                if let buyukTansiyon = tansiyonVeSekerTotalArray[indexPath.row].bTansiyon,let kucukTansiyon = tansiyonVeSekerTotalArray[indexPath.row].ktansiyon, let nabiz = tansiyonVeSekerTotalArray[indexPath.row].nabiz {
                    cell.resultLabel.text = "🩺\(buyukTansiyon)/\(kucukTansiyon) N:\(nabiz)"
                    cell.savetimeLabel.text = "\(tansiyonVeSekerTotalArray[indexPath.row].time ?? "26/02 00:02")"
                }
            } else {
                if let acTok = tansiyonVeSekerTotalArray[indexPath.row].actok,let seker = tansiyonVeSekerTotalArray[indexPath.row].seker  {
                    cell.resultLabel.text = "🩸\(acTok) \(seker)mg/dl"
                    cell.savetimeLabel.text = "\(tansiyonVeSekerTotalArray[indexPath.row].time ?? "26/02 00:02")"
                }
            }
            return cell
        } else {
            let cell = UITableViewCell()
            cell.textLabel?.text = "Patladı"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tansiyonVeSekerTotalArray.remove(at: indexPath.row)
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
                buyukTansiyonLabelCounter += 1
                if buyukTansiyonLabelCounter == 1 {
                    setLabelForComponents(text: ValueClass.bigtansiyonString, xValue: pickerViev.frame.width * 0.20, yValue: pickerViev.frame.height * 0.03)
                }
                return String(tansiyonBigArray[row])
            case 1:
                kucukTansiyonLabelCounter += 1
                if kucukTansiyonLabelCounter == 1 {
                    setLabelForComponents(text: ValueClass.littletansiyonString, xValue: pickerViev.frame.width * 0.55, yValue: pickerViev.frame.height * 0.03)
                }
                return String(tansiyonLittleArray[row])
            case 2 :
                nabizLabelCounter += 1
                if nabizLabelCounter == 1 {
                    setLabelForComponents(text: ValueClass.heartBeatString, xValue: pickerViev.frame.width * 0.90, yValue: pickerViev.frame.height * 0.03)
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
                acTokLabelCounter += 1
                if acTokLabelCounter == 1 {
                    sekerOrTansiyonCounter = 1
                    setLabelForComponents(text: ValueClass.sekerDegerString, xValue: pickerViev.frame.width * 0.95, yValue: pickerViev.frame.height * 0.45)
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
        sekerPickerView.selectRow(74, inComponent: 1, animated: true)
        sekerPickerView.selectedRow(inComponent: 0)
    }
}
