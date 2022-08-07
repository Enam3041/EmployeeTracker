//
//  EmployeeCell.swift
//  EmployeeTracker
//
//  Created by Digital Ride on 04/08/2022.
//

import UIKit

class BusCell: UITableViewCell {
    
    // MARK: - Type Properties
    static let reuseIdentifier = "BusCell"
    
    // MARK: - Properties
    @IBOutlet var containerView: UIView!
    @IBOutlet var lblBusName: UILabel!
    @IBOutlet var lblDepartureTime: UILabel!

    // MARK: - Configuration
    
    override func layoutSubviews() {
        containerView.layer.cornerRadius = 8
        containerView.clipsToBounds = true
    }
    
    func configure(withViewModel viewModel: BusViewModel) {
        lblBusName.text = viewModel.name
        lblDepartureTime.text = viewModel.departureTime
    }
}
