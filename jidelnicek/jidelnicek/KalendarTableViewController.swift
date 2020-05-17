//
//  KalendarTableViewController.swift
//  jidelnicek
//
//  Created by Hynek Bernard on 11/05/2020.
//  Copyright © 2020 Hynek Bernard. All rights reserved.
//

import UIKit
import CoreData


class KalendarTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    let dateform = DateFormatter()
    var editDate = Date.init()
    var dny : [Den] = []
    var moc : NSManagedObjectContext?
    //inicializace dat
    override func viewDidLoad() {
        super.viewDidLoad()
        dateform.dateFormat = "dd.MM.yy"
        initializeFetchedResultsController()

        nactiDny()
    }
    
    //MARK: - CORE DATA FETCH
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    func initializeFetchedResultsController(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Den")
        let dateSort = NSSortDescriptor(key: "datum", ascending: true)
        request.sortDescriptors = [dateSort]
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        moc = appDelegate.dataController.getMOC()
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc!, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError()
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dny.count
    }

    //nastavení labelů a buttonů buněk
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DenTWC", for: indexPath) as? DenTableViewCell else{
            fatalError("Cell není instance DenTWC")
        }
        let den = dny[indexPath.row]
        guard let datum = den.datum else{
            fatalError("den bez data !!")
        }
        cell.editBtn.setTitle(dateform.string(from: datum), for: .normal)
        if let snidane = den.snidane?.nazev{
            cell.snidaneLbl.text = snidane
        }
        else{
            cell.snidaneLbl.text = "Snídaně"
        }
        if let obed = den.obed?.nazev{
            cell.obedLbl.text = obed
        }
        else{
            cell.obedLbl.text = "Oběd"
        }
        
        
        if let vecere = den.vecere?.nazev{
            cell.vecereLbl.text = vecere
        }
        else{
            cell.vecereLbl.text = "Večeře"
        }

        return cell
    }
    //MARK: - smazat záznam 
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        dny[indexPath.row].clear()
		//pokud je záznam starší než dnes, smažu úplně
        if(Calendar.current.dateComponents([.day], from: dny[indexPath.row].datum!, to: Date.init(timeIntervalSinceNow:0)).day!) > 0
        {
            moc!.delete(dny[indexPath.row])
            dny.remove(at:indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            do { try moc!.save() } catch{ fatalError("CannotSave")}
            return
        }
		//pokud je záznam v rozmezí dnes-10dní
        tableView.reloadRows(at: [indexPath], with: .fade)
        do { try moc!.save() } catch{ fatalError("CannotSave")}
    }

    

    // MARK: - Navigation

	//načtení dnů a vygenerování prázdných
    private func nactiDny(){
        let dnyFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Den")
        do {
            dny = try moc?.fetch(dnyFetch) as! [Den]
        }catch{
                fatalError("fail to fetch")
            }
    
        for index in 0...10 {
            let createDate = Date.init(timeIntervalSinceNow: TimeInterval(index * 86400))
            var skip = false
            for den in dny{
                guard let datum = den.datum else{
                    fatalError("den bez data !!")
                }
                if dateform.string(from: createDate) == dateform.string(from: datum){
                    skip = true
                    break
                }
            }
            if skip{
                continue
            }
            //tvorba dnu
            let den = NSEntityDescription.insertNewObject(forEntityName: "Den", into: moc!) as! Den
            den.datum = createDate
            dny+=[den]
        }
		//řazení pro posloupnost
        dny.sort(){$0.datum! < $1.datum!}
        do { try moc!.save() } catch{ fatalError("CannotSave")}
        
        
    }
	//přijetí dat z přidávacího controlleru a přiřazení ke dni
    @IBAction func unwindToFoodList(sender: UIStoryboardSegue){
        if let sourceVC = sender.source as? FoodViewController, let food = sourceVC.food, let foodType = sourceVC.typ{
            if let den = dny.first(where:{ dateform.string(from: $0.datum! ) == dateform.string(from: sourceVC.datum)}){
                switch foodType{
                case typJidla.Snidane: den.snidane = food
                case typJidla.Obed: den.obed = food
                case typJidla.Vecere: den.vecere = food
                }
            }
            do { try moc!.save() } catch{ fatalError("CannotSave")}
            tableView.reloadData()
            
        }
    }
	//nastavení upravovaného data při kliknutí na buňku
    @IBAction func onButtonTap(sender: UIButton){
        guard let btn = sender.currentTitle else {
            return
        }
        guard let datum = dateform.date(from: btn) else{
            return
        }
        editDate = datum
    }
}
