//
//  ViewController.swift
//  TM_APPMapaReto1
//
//  Created by cice on 15/2/17.
//  Copyright © 2017 cice. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

enum MapType : Int{
    case standard = 0
    case hybrid = 1
    case satelite = 2
}



class TM_PrimerMapaVC: UIViewController {

    
    //MARK: - Variables
    
    let locationManager = CLLocationManager()
    
    
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var myMapa: MKMapView!
    @IBOutlet weak var myDireccionLBL: UILabel!
    @IBOutlet weak var mySeleccionTipoMapa: UISegmentedControl!
    
    
    //MARK: - IBActions
    
    @IBAction func myTipoMapaCambiadioAction(_ sender: AnyObject) {
        
        let mapType = MapType(rawValue: mySeleccionTipoMapa.selectedSegmentIndex)
        
        switch mapType! {
            
            case .standard:
                myMapa.mapType = .standard
            
            case .hybrid:
                myMapa.mapType = .hybrid
            
            default:
                myMapa.mapType = .satellite
            
        }
        
        
    }
    
    @IBAction func myButtonVerMapa(_ sender: AnyObject) {
        
        //Punto del mapa
        
        let lat = 40.431457
        let long = -3.678216
        
        //Zoom
        
        let latDelta = 0.001
        let longDelta = 0.001
        
        
        //
        let location = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        let region = MKCoordinateRegion(center: location, span: span)
        myMapa.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Esta es mi casa"
        annotation.subtitle = "Estamos en clase de desarrollo iOS"
        myMapa.addAnnotation(annotation)
        
        
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Fase de precision del GPS -> CoreLocation
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        //Gesto de reconocimiento
        
        
        
        let longPressGestureRecognizerCustom = UILongPressGestureRecognizer(target: self, action: #selector(self.actionGestureRecognizer(_ :)))
        longPressGestureRecognizerCustom.minimumPressDuration = 2
        myMapa.addGestureRecognizer(longPressGestureRecognizerCustom)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //MARK: - UTILS
    
    func actionGestureRecognizer(_ gesture : UIGestureRecognizer){
    
    if gesture.state == UIGestureRecognizerState.began{
        
        let puntoToquePantalla = gesture.location(in: myMapa)
        let nuevaCoordenada = myMapa.convert(puntoToquePantalla, toCoordinateFrom: myMapa)
        
        let annotationPunto = MKPointAnnotation()
        annotationPunto.coordinate = nuevaCoordenada
        annotationPunto.title = "Nuevo punto en el mapa"
        annotationPunto.subtitle = "seguimos trabajando en el mapa"
        myMapa.addAnnotation(annotationPunto)
        
        }
        
        
        
    }
    
    func borrarChincheta(_ gesture : UIGestureRecognizer){
    
    
    
    
    }
    
    

}


extension TM_PrimerMapaVC : CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        let userLocation = locations.first!
        
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
        myMapa.setRegion(region, animated: true)
        myDireccionLBL.text = "\(userLocation)"
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = userLocation.coordinate
        annotation.title = "Titulo por defecto"
        annotation.subtitle = "Subtitulo por defecto"
        myMapa.addAnnotation(annotation)
        
        
    }



}




