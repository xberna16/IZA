//
//  FoodViewController.swift
//  jidelnicek
//
//  Created by Hynek Bernard on 11/05/2020.
//  Copyright © 2020 Hynek Bernard. All rights reserved.
//

import UIKit
import CoreData
class FoodViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    var food: Jidlo?
    var typ : typJidla?
    var datum : Date = Date.init(timeIntervalSinceNow: 0)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    

    @IBOutlet weak var jidloLbl: UITextField!
    @IBOutlet weak var typPick: UIPickerView!
    @IBOutlet weak var surovinyLbl: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    var pickerData: [String] = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
        pickerData = [typJidla.Snidane.rawValue,typJidla.Obed.rawValue,typJidla.Vecere.rawValue]
        self.typPick.delegate = self
        self.typPick.dataSource = self

        guard let prnt = self.presentingViewController  else{
            return
        }
        let dejmidatum = prnt as! KalendarTableViewController
        datum = dejmidatum.editDate
        //datum = prnt.datum
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        super.prepare(for: segue, sender: sender)
        guard let button = sender as? UIButton, button === saveBtn else{
                return
        }
        switch typPick.selectedRow(inComponent: 0) {
        case 0: typ = typJidla.Snidane
        case 1: typ = typJidla.Obed
        case 2: typ = typJidla.Vecere
        default:return
        }
        guard let jidlo = jidloLbl.text else {
            return
        }
        guard let suroviny = surovinyLbl.text else {
            return
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let moc = appDelegate.dataController.getMOC()
        food = (NSEntityDescription.insertNewObject(forEntityName:"Jidlo", into:moc) as! Jidlo)
        food!.nazev = jidlo
        food!.suroviny = suroviny
    }

}
