//  ViewController.swift
//  mapView
//  Created by Mehul Solanki on 11/05/17.
//  Copyright © 2017 sufalam. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    
    fileprivate var polygon: MKPolygon? = nil
    @IBOutlet weak var objMapView: MKMapView!
    
    var polyCordinatesArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let overlays: [Any] = HHLViewController.countriesOverlays()
        objMapView.addOverlays(overlays as! [MKOverlay])
        
    }
    func readjson(fileName: String) -> Any{
        do {
            if let file = Bundle.main.url(forResource: fileName, withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                return json
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
        return ""
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let polygonRenderer = MKPolygonRenderer(overlay: overlay)
        polygonRenderer.fillColor = UIColor.red //UIColor.cyan.withAlphaComponent(0.2)
        polygonRenderer.strokeColor = UIColor.black //UIColor.blue.withAlphaComponent(0.7)
        polygonRenderer.lineWidth = 3
        return polygonRenderer
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

///http://stackoverflow.com/questions/22823772/draw-geojson-in-apple-maps-as-overlay
