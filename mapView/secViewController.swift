//
//  secViewController.swift
//  mapView
//
//  Created by Mehul Solanki on 22/05/17.
//  Copyright © 2017 sufalam. All rights reserved.
//

import UIKit

class secViewController: UIViewController, HACMKMapViewDelegate {

    @IBOutlet weak var mapView: HACMKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.mapDelegate = self
        mapClustering()
        
    }
    func mapClustering()
    {
        let data: [Any] = [[kLatitude: 48.47352, kLongitude: 3.87426, kTitle: "Title 1", kSubtitle: "", kIndex: 0], [kLatitude: 52.59758, kLongitude: -1.93061, kTitle: "Title 2", kSubtitle: "Subtitle 2", kIndex: 1], [kLatitude: 48.41370, kLongitude: 3.43531, kTitle: "Title 3", kSubtitle: "Subtitle 3", kIndex: 2], [kLatitude: 48.31921, kLongitude: 18.10184, kTitle: "Title 4", kSubtitle: "Subtitle 4", kIndex: 3], [kLatitude: 47.84302, kLongitude: 22.81101, kTitle: "Title 5", kSubtitle: "Subtitle 5", kIndex: 4], [kLatitude: 60.88622, kLongitude: 26.83792, kTitle: "Title 6", kSubtitle: "", kIndex: 5]]
        
        mapView.coordinateQuadTree.build(with: data)
        mapView.backgroundAnnotation = UIColor.red
        mapView.borderAnnotation = UIColor.white
        mapView.textAnnotation = UIColor.white
        mapView.compassFrame = CGRect(x: CGFloat(10), y: CGFloat(10), width: CGFloat(25), height: CGFloat(25))
        mapView.legalFrame = CGRect(x: CGFloat(UIScreen.main.bounds.width - 50), y: CGFloat(UIScreen.main.bounds.height - 50), width: CGFloat(50), height: CGFloat(50))
        
        self.view.addSubview(mapView)
    }
    
    func view(for annotationView: HAClusterAnnotationView, annotation: HAClusterAnnotation) {
        if annotation.index % 2 == 0 {
            annotationView.image = #imageLiteral(resourceName: "pin1")
        }
        else {
            annotationView.image = #imageLiteral(resourceName: "pin2")
        }
        let uiview = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        uiview.backgroundColor = UIColor.red
    }
    func didSelectAnnotationView(_ annotationView: HAClusterAnnotation!) {

        print("Tap on annotation")
        
    }
    func didDeselect(_ annotationView: HAClusterAnnotationView!) {
        
        
        print("Tap on didDeselect")
        
    }
   override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
