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
    var aryCountries = NSMutableArray()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        FillColorofMapArea()
        readJson()
        setPin()
    }
    func FillColorofMapArea()
    {
        let overlays: [Any] = HHLViewController.countriesOverlays()
        objMapView.addOverlays(overlays as! [MKOverlay])
        self.objMapView.delegate = self
        var span = MKCoordinateSpan()
        span.latitudeDelta = 180
        span.longitudeDelta = 360
        let region: MKCoordinateRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(0.0000, 0.0000), span)
        objMapView.setRegion(region, animated: true)
   }
    func setPin()
    {
        var counter = NSInteger()
        for i in 0...aryCountries.count-1
        {
            counter += 1
            if counter >= 2 && counter <= 15
            {
                if counter == 15
                {
                    counter = 0
                }
                continue
            }
            let longitude = (aryCountries.object(at: i) as! NSArray).object(at: 0) as! NSNumber
            let latitude = (aryCountries.object(at: i) as! NSArray).object(at: 1) as! NSNumber
            let info1 = CustomPointAnnotation()
            info1.coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(latitude), CLLocationDegrees(longitude))
            info1.title = "Info\(i)"
            info1.subtitle = "Subtitle\(i)"
            if i % 2 == 0
            {
                info1.imageName = "pin1.png"
            }
            else if i % 3 == 0
            {
                info1.imageName = "pin2.png"
            }else{
                info1.imageName = "pin3.png"
            }
            objMapView.addAnnotation(info1)
        }
    }
    
    func readJson() {
        do {
            if let file = Bundle.main.url(forResource: "countries", withExtension: "json") {
                
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any] {
                    let objArray = [object["features"]][0] as! NSArray
                    let valued = objArray.value(forKeyPath: "geometry.coordinates") as! NSArray
                    aryCountries = NSMutableArray(array: (valued.object(at: 0) as! NSArray).object(at: 0) as! NSArray)
                } else if let object = json as? [Any] {
                    print(object)
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            print("Disclosure Pressed!")
        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        let reuseId = "test"
        var anView = objMapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView?.canShowCallout = true
            
            anView?.rightCalloutAccessoryView = UIButton(type: UIButtonType.infoDark)
            let imageview = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
            imageview.image = #imageLiteral(resourceName: "pin3")
            anView!.leftCalloutAccessoryView = imageview
        }
        else {
            anView?.annotation = annotation
        }
        let cpa = annotation as! CustomPointAnnotation
        anView?.image = UIImage(named:cpa.imageName)
        anView?.backgroundColor = UIColor.brown
        anView?.tintColor = UIColor.brown
        return anView
    }
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        guard let tileOverlay = overlay as? MKTileOverlay else {
            return MKOverlayRenderer(overlay: overlay)
        }
        return MKTileOverlayRenderer(tileOverlay: tileOverlay)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let polygonRenderer = MKPolygonRenderer(overlay: overlay)
        polygonRenderer.fillColor = UIColor.clear
        polygonRenderer.strokeColor = UIColor.black
        polygonRenderer.lineWidth = 3
        return polygonRenderer
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
extension MKMapView {
    
    // delta is the zoom factor
    // 2 will zoom out x2
    // .5 will zoom in by x2
    
    func setZoomByDelta(delta: Double, animated: Bool) {
        var _region = region;
        var _span = region.span;
        _span.latitudeDelta *= delta;
        _span.longitudeDelta *= delta;
        _region.span = _span;
        
        setRegion(_region, animated: animated)
    }
}
class CustomPointAnnotation: MKPointAnnotation {
    var imageName: String!
}

