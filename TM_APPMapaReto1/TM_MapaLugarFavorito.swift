//
//  TM_MapaLugarFavorito.swift
//  TM_APPMapaReto1
//
//  Created by cice on 20/2/17.
//  Copyright © 2017 cice. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class TM_MapaLugarFavorito: UIViewController {

    
    //MARK: - Variables
    
    var locationManager = CLLocationManager()
    
    
    //MARK: - IBOUTLETS
    
    @IBOutlet weak var myMapViewLugaresFavoritos: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Gestor de reconocimiento
        
        let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(self.actionCreaChincheta(_ :)))
        longPressGR.minimumPressDuration = 2
        myMapViewLugaresFavoritos.addGestureRecognizer(longPressGR)
        
        //Location manager
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func actionCreaChincheta(_ gesture : UIGestureRecognizer){
        if gesture.state == UIGestureRecognizerState.began{
        
        
            let puntoToque = gesture.location(in: myMapViewLugaresFavoritos)
            let nuevaCoordenada = myMapViewLugaresFavoritos.convert(puntoToque, toCoordinateFrom: myMapViewLugaresFavoritos)
            let customLocation = CLLocation(latitude: nuevaCoordenada.latitude, longitude: nuevaCoordenada.longitude)
            
            
            CLGeocoder().reverseGeocodeLocation(customLocation) { (placemarks, error) in
                var calle = ""
                var numeroCalle = ""
                var customTitle = ""
                
                if let customPlacemarks = placemarks?[0]{
                    if customPlacemarks.thoroughfare != nil{
                        calle = customPlacemarks.thoroughfare!
                    }
                    if customPlacemarks.subThoroughfare != nil{
                        numeroCalle = customPlacemarks.subThoroughfare!
                    }
                    customTitle = "\(calle)  \(numeroCalle)"
                }
                
                if customTitle == ""{
                    customTitle = "Punto añadido el \(Date())"
                }
                
                //Creamos la anotacion
                let anntotation = MKPointAnnotation()
                anntotation.coordinate = nuevaCoordenada
                anntotation.title = customTitle
                self.myMapViewLugaresFavoritos.addAnnotation(anntotation)
                
                
                //Guardamos en nuestro array de diccionarios
                
                customLugares.append(["name": customTitle, "lat": "\(nuevaCoordenada.latitude)", "long": "\(nuevaCoordenada.longitude)"])
                
                
                
                
                }
        }
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

extension TM_MapaLugarFavorito : CLLocationManagerDelegate{

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation = locations[0]
        let latitud = userLocation.coordinate.latitude
        let longitud = userLocation.coordinate.longitude
        
        let location = CLLocationCoordinate2D(latitude: latitud, longitude: longitud)
        let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        myMapViewLugaresFavoritos.setRegion(region, animated: true)
    }

}



