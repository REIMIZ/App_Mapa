//
//  ViewController.swift
//  Mapas
//
//  Created by mac16 on 09/11/21.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var manager = CLLocationManager()
    var latitud: CLLocationDegrees!
    var longitud: CLLocationDegrees!

    @IBOutlet weak var Mapa: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
    }
    
    @IBAction func verCoordenadasBtn(_ sender: UIBarButtonItem) {
        let alerta = UIAlertController(title: "Ubicacion", message: "Las coordenadas son, lat: \(self.latitud!) long: \(self.longitud!)", preferredStyle: .alert )
        let accionAceptar = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
        let accionCancelar = UIAlertAction(title: "Ver mas...", style: .default, handler: nil)
        alerta.addAction(accionAceptar)
        alerta.addAction(accionCancelar)
        present(alerta, animated: true, completion: nil)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            self.latitud = location.coordinate.latitude
            self.longitud = location.coordinate.longitude
        }
        
    }


}

