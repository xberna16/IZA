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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateform.dateFormat = "dd.MM.yy"
        initializeFetchedResultsController()

        nactiDny()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }
    
    //MARK: - CORE DATA
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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dny.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DenTWC", for: indexPath) as? DenTableViewCell else{
            fatalError("Cell není instance DenTWC")
        }
        let den = dny[indexPath.row]
        guard let datum = den.datum else{
            fatalError("den bez data !!")
        }
        cell.editBtn.setTitle(dateform.string(from: datum), for: .normal)
        // Configure the cell...
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
    //MARK: - smazat
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        dny[indexPath.row].clear()
        if(Calendar.current.dateComponents([.day], from: dny[indexPath.row].datum!, to: Date.init(timeIntervalSinceNow:0)).day!) > 0
        {
            moc!.delete(dny[indexPath.row])
            dny.remove(at:indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            do { try moc!.save() } catch{ fatalError("CannotSave")}
            return
        }
        tableView.reloadRows(at: [indexPath], with: .fade)
        do { try moc!.save() } catch{ fatalError("CannotSave")}
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
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
            
            let den = NSEntityDescription.insertNewObject(forEntityName: "Den", into: moc!) as! Den
            den.datum = createDate
            dny+=[den]
        }
        dny.sort(){$0.datum! < $1.datum!}
        do { try moc!.save() } catch{ fatalError("CannotSave")}
        
        
    }
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
            //tableView.insertRows(at: [IndexPath(row: dny.count-1, section: 0)], with: .automatic)
            
        }
    }
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
