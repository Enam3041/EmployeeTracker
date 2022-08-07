//  MarkerInfoView.swift
//  Created by Enam on 10/22/18.
//  Copyright © 2021 Digital Ride All rights reserved.
//
import UIKit

class MarkerInfoView: UIView {
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var markerImageView: UIImageView!
    
    override func layoutSubviews() {
        topView.layer.cornerRadius = 5
        topView.clipsToBounds = true
    }

}
