
import Foundation
import UIKit
var selectedDate = Date()

class WeeklyViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource
{
    
    var selectedDate2 = Date()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        setCellsView()
        setMonthView()
    }
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var monthLabel: UILabel!
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedDate2 = totalSquares[indexPath.item]
        collectionView.reloadData()
        tableView.reloadData()
        print("SELECTED DATE 2" + selectedDate2.description)
    }
    @IBAction func previousWeek(_ sender: Any) {
        selectedDate2 = CalendarHelper().addDays(date: selectedDate2, days: -7)
        setMonthView()
    }
    
    @IBAction func nextWeek(_ sender: Any) {
        selectedDate2 = CalendarHelper().addDays(date: selectedDate2, days: 7)
        setMonthView()
    }
 
    @IBOutlet weak var tableView: UITableView!
    
    //prevent screen from rotating
    
    override open var shouldAutorotate: Bool
    {
        return false
    }
    
    var totalSquares = [Date]()
    
    func setCellsView()
    {
        let width = (collectionView.frame.size.width - 2) / 8
        let height = (collectionView.frame.size.height - 2) / 8
        
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = CGSize (width: width, height: height )
        
    }
    
    func setMonthView()
    {
        totalSquares.removeAll()
        
        var current = CalendarHelper().sundayForDate(date: selectedDate2)
        let nextSunday = CalendarHelper().addDays(date: current, days: 7)
        
        while(current<nextSunday){
            totalSquares.append(current)
            current = CalendarHelper().addDays(date: current, days: 1)
        }
        
        
        monthLabel.text = CalendarHelper().monthString(date: selectedDate2) + " " + CalendarHelper().yearString(date: selectedDate2)
        collectionView.reloadData()
        tableView.reloadData()
    }
    
    @IBAction func logOutTapped(_ sender: Any) {
        showConfirmLogoutAlert()
    }
    
    
    
    private func showConfirmLogoutAlert() {
        let alertController = UIAlertController(title: "Are you sure you want to Log out of \(User.current?.username ?? "current account")'s Account?", message: nil, preferredStyle: .alert)
        let logOutAction = UIAlertAction(title: "Log out", style: .destructive) { _ in
            NotificationCenter.default.post(name: Notification.Name("logout"), object: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(logOutAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        totalSquares.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calCell", for: indexPath) as! CalendarCell
        let date: Date = totalSquares[indexPath.item]
        cell.dayOfMonth.text = String(CalendarHelper().dayOfMonth(date: totalSquares[indexPath.item]))
        
        if(date == selectedDate2){
            cell.backgroundColor = UIColor.systemGreen
        } else {
            cell.backgroundColor = UIColor.white
        }
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Event().eventsForDate(date: selectedDate2).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID") as! EventCell
        let event = Event().eventsForDate(date: selectedDate2)[indexPath.row]
        cell.eventLabel.text = event.name + " " + CalendarHelper().timeString(date: event.date)
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
}
