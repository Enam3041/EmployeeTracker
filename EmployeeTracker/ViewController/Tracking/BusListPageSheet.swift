//
//  EmployeeListVC.swift
//  EmployeeTracker
//
//  Created by Digital Ride on 03/08/2022.
//

import UIKit

class BusListPageSheet: UIViewController {
   
    @IBOutlet weak var lblCurrentOccupied: UILabel!
    @IBOutlet weak var lblTotalOccupied: UILabel!
    @IBOutlet var headerTapGesture: UITapGestureRecognizer!
    @IBOutlet var tableView         : UITableView!
    var viewModel       : BusListViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = BusListViewModel()
        viewModel.getBuses()
        viewModel.didUpdateBuses = { [unowned self] (buses) in
            self.tableView.reloadData()
        }
    }
}


//MARK: UITableViewDelegate, UITableViewDataSource
extension BusListPageSheet : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfBuses
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellForEmployee(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    // Private functions
    private func cellForEmployee(indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BusCell.reuseIdentifier, for: indexPath) as? BusCell else {
            fatalError("Unexpected Table View Cell")
        }
        
        if let viewModel = viewModel.viewModelForBus(at: indexPath.row) {
            cell.configure(withViewModel: viewModel)
        }
        
        return cell
    }
}
