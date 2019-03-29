//
//  ViewController.swift
//  MoveCompassTest
//
//  Created by Hector de Diego on 19/03/29.
//  Copyright © 2019 hector.dd. All rights reserved.
//

import UIKit
import MapKit

extension MKMapView {
    func getCompassView() -> UIView? {
        return (self.subviews.filter { String(describing:$0).contains("MKCompassView") }.first)
    }
}

class SSMapView: MKMapView {
    
    private var _compassTopValue: CGFloat = 5
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let compassLeftValue = self.frame.width - 33 - 5
        if let compassView = self.getCompassView() {
            compassView.frame = CGRect(x:compassLeftValue, y:_compassTopValue, width:33, height:33)
        }
    }
    
    func setCompassPosition(top: CGFloat, animated: Bool) {
        _compassTopValue = top
        setNeedsLayout()
        
        if animated {
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
                self.layoutIfNeeded()
            }, completion: nil)
        } else {
            self.layoutIfNeeded()
        }
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var mapContainerView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var toggleArrow: UIButton!
    
    var mapView: SSMapView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iconImageView.image = UIImage(named: "dummy")
        iconImageView.isHidden = true
        
        toggleArrow.setTitle("Show arrow", for: .normal)
        toggleArrow.setTitle("Hide arrow", for: .selected)
        
        if mapView?.superview == nil {
            mapView = SSMapView( frame: .zero )
            if let mapView = mapView {
                configureMap(map: mapView)
            }
        }
    }
    
    func configureMap(map: SSMapView) {
        map.delegate = self
        map.translatesAutoresizingMaskIntoConstraints = false
        mapContainerView.addSubview(map)
        map.leftAnchor.constraint(equalTo: mapContainerView.leftAnchor).isActive = true
        map.topAnchor.constraint(equalTo: mapContainerView.topAnchor).isActive = true
        map.rightAnchor.constraint(equalTo: mapContainerView.rightAnchor).isActive = true
        map.bottomAnchor.constraint(equalTo: mapContainerView.bottomAnchor).isActive = true
        map.userTrackingMode = .none
        map.isRotateEnabled = true
    }
    
    @IBAction func toogleArrowAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        iconImageView.isHidden = !sender.isSelected
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        print("regionWillChangeAnimated")
    }
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        print("mapViewDidChangeVisibleRegion")
        guard let mapView = mapView as? SSMapView else { return }
        let compassTopPadding: CGFloat = iconImageView.isHidden ? 5 : 80
        mapView.setCompassPosition(top: compassTopPadding, animated: false)
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("regionDidChangeAnimated")
    }
}
