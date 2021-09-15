//
//  MapsViewController.swift
//  CPU_Catalog
//
//  Created by Admin on 07.03.2021.
//

import UIKit
import MapKit
import Firebase

class MapsViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var data : Array<QueryDocumentSnapshot>?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        data = dataService.shared.data
        if data==nil{
            print("Error on segue")
        }
        else{
            fullfillPointData()
        }
    }
    
    func fullfillPointData(){
        var count: Int = 0
        for map_data in data!{
            if !(map_data.data()["latitude"]==nil ||  map_data.data()["longitude"]==nil){
                
                let CPUloc = CPULocation(title: map_data.data()["model"] as? String, subtitle: "", coordinate: CLLocationCoordinate2D(latitude: map_data.data()["latitude"] as! Double, longitude:  map_data.data()["longitude"] as! Double), count: count)
                mapView.addAnnotation(CPUloc)
                
            }
            count = count + 1
        }
    }
    
    func transitionToDetailed(_ detailedData: QueryDocumentSnapshot) {
        
        let detailedViewController = (storyboard?.instantiateViewController(identifier: Constants.Storyboard.detailedViewController) as? DetailedViewController)!
        let tabViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabBarController) as? UITabBarController
        tabViewController?.selectedIndex = 0
        let navViewController = (tabViewController?.selectedViewController) as? UINavigationController
        detailedViewController.data=detailedData
        navViewController?.pushViewController(detailedViewController, animated: true)
        view.window?.rootViewController = tabViewController
        view.window?.makeKeyAndVisible()
    }
}


extension MapsViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? CPULocation else {return nil}
        var viewMarker:MKMarkerAnnotationView
        let idView = "marker"
        if let view = mapView.dequeueReusableAnnotationView(withIdentifier: idView) as? MKMarkerAnnotationView{
            view.annotation = annotation
            viewMarker = view
        }else{
            viewMarker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: idView)
            viewMarker.canShowCallout = true
            viewMarker.calloutOffset = CGPoint(x: 0, y: 6)
            viewMarker.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return viewMarker
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let location = view.annotation as? CPULocation else { return }
        transitionToDetailed(data![location.count])
        return
    }
}

class CPULocation:NSObject,MKAnnotation{
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    let count : Int
    
    init(title: String?,subtitle: String?, coordinate: CLLocationCoordinate2D, count: Int){
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.count = count
        super.init()
    }
}
