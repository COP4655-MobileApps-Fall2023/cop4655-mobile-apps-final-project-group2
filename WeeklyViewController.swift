
import Foundation
import UIKit

class WeeklyViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource
{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCellsView()
        setMonthView()
    }
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var monthLabel: UILabel!

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedDate = totalSquares[indexPath.item]
        collectionView.reloadData()
    }
    @IBAction func previousWeek(_ sender: Any) {
        selectedDate = CalendarHelper().addDays(date: selectedDate, days: -7)
        setMonthView()
    }
    
    @IBAction func nextWeek(_ sender: Any) {
        selectedDate = CalendarHelper().addDays(date: selectedDate, days: 7)
        setMonthView()
    }
 
    
    //prevent screen from rotating
    
    override open var shouldAutorotate: Bool
    {
        return false
    }
    
    var selectedDate = Date()
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
        
        var current = CalendarHelper().sundayForDate(date: selectedDate)
        let nextSunday = CalendarHelper().addDays(date: current, days: 7)
        
        while(current<nextSunday){
            totalSquares.append(current)
            current = CalendarHelper().addDays(date: current, days: 1)
        }
        
        
        monthLabel.text = CalendarHelper().monthString(date: selectedDate) + " " + CalendarHelper().yearString(date: selectedDate)
        collectionView.reloadData()
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
        let date = totalSquares[indexPath.item]
        cell.dayOfMonth.text = String(CalendarHelper().dayOfMonth(date: totalSquares[indexPath.item]))
        
        if(date == selectedDate){
            cell.backgroundColor = UIColor.systemGreen
        } else {
            cell.backgroundColor = UIColor.white
        }
        return cell
    }
}
