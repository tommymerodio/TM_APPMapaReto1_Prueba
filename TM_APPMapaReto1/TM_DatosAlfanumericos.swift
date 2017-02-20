//
//  TM_DatosAlfanumericos.swift
//  TM_APPMapaReto1
//
//  Created by cice on 15/2/17.
//  Copyright © 2017 cice. All rights reserved.
//

import UIKit
import CoreLocation

class TM_DatosAlfanumericos: UIViewController {

    
    //MARK: - Variables locales
    
    var locationManager = CLLocationManager()
    
    //MARK: - Iboutlets
    
    @IBOutlet weak var myLatitudLBL: UILabel!
    @IBOutlet weak var myLongitudLBL: UILabel!
    @IBOutlet weak var myRumboLBL: UILabel!
    @IBOutlet weak var myVelocidadLBL: UILabel!
    @IBOutlet weak var myAltitudLBL: UILabel!
    @IBOutlet weak var myDireccionLBL: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        

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


extension TM_DatosAlfanumericos : CLLocationManagerDelegate{

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let userLocation = locations.first{
            //Actualizamos nuestra localizacion
            myLatitudLBL.text = "\(userLocation.coordinate.latitude)"
            myLongitudLBL.text = "\(userLocation.coordinate.longitude)"
            myRumboLBL.text = "\(userLocation.course)"
            myVelocidadLBL.text = "\(userLocation.speed)"
            myAltitudLBL.text = "\(userLocation.altitude)"
            
            //Grupo de geocodificacion inversa
            
            CLGeocoder().reverseGeocodeLocation(userLocation, completionHandler: { (placemarks, error) in
                if error == nil{
                    if let placemarksData = placemarks?[0]{
                        var direccion = ""
                        
                        direccion += self.addInfoIfExists(placemarksData.thoroughfare)
                        direccion += self.addInfoIfExists(placemarksData.subThoroughfare)
                        direccion += self.addInfoIfExists(placemarksData.subLocality)
                        direccion += self.addInfoIfExists(placemarksData.subAdministrativeArea)
                        direccion += self.addInfoIfExists(placemarksData.postalCode)
                        direccion += self.addInfoIfExists(placemarksData.country)
                        direccion += self.addInfoIfExists(placemarksData.locality)
                        
                        self.myDireccionLBL.text = direccion
                    }
                }else{
                
                }
            })
        
        
        
        }
    }
    
    //Creamos una funcion para trabajar mejor la gestion de datos
    
    func addInfoIfExists(_ info : String?) -> String{
        
        if info != nil{
            return "\(info!) \n"
        }else{
            return ""
        }
    
    
    }
    

}



