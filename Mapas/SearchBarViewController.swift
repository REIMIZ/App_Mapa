//
//  SearchBarViewController.swift
//  Mapas
//
//  Created by mac16 on 15/11/21.
//

import UIKit
import MapKit
import CoreLocation

class SearchBarViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var Buscador: UISearchBar!
    @IBOutlet weak var Mapa: MKMapView!
    
    var Manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Buscador.delegate = self
        Manager.delegate = self
        Mapa.delegate = self
        Manager.requestWhenInUseAuthorization()
        Manager.requestLocation()
        
        Manager.desiredAccuracy = kCLLocationAccuracyBest
        
        Manager.startUpdatingLocation()
    }
    
    
    @IBAction func VistaBtn(_ sender: UIBarButtonItem) {
        Mapa.mapType = .satellite
    }
    
    @IBAction func Vista2Btn(_ sender: UIBarButtonItem) {
        Mapa.mapType = .standard
    }
    
    func TrazarRuta(coordenanasDestino: CLLocationCoordinate2D){
        guard let coordOrigen = Manager.location?.coordinate else {return}
        //origen
        let origenPlaceMark = MKPlacemark(coordinate: coordOrigen)
        let destinoPlaceMark = MKPlacemark(coordinate: coordenanasDestino)
        
        //mapkit
        let origenItem = MKMapItem(placemark: origenPlaceMark)
        let destinoItem = MKMapItem(placemark: destinoPlaceMark)
        
        let solicitudDestino = MKDirections.Request()
        solicitudDestino.source = origenItem
        solicitudDestino.destination = destinoItem
        
        //viaje
        solicitudDestino.transportType = .automobile
        solicitudDestino.requestsAlternateRoutes = true
        
        let direcciones = MKDirections(request: solicitudDestino)
        direcciones.calculate { (respuesta, error) in
            //variable
            guard let respuestaSegura = respuesta else{
                if let error = error{
                    print("Error al calcular la ruta \(error.localizedDescription)")
                    
                }
                return
                
            }
            print(respuestaSegura.routes.count)
            let ruta = respuestaSegura.routes[0]
            
            //superposicion
            self.Mapa.addOverlay(ruta.polyline)
            self.Mapa.setVisibleMapRect(ruta.polyline.boundingMapRect, animated: true)
            
        }
        
    }
    //mostrar Ruta
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderizado = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderizado.strokeColor = .purple
        return renderizado
    }
    
    //cllocatioManager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Ubicacion encontrada")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Ubicacion no encontrada")
    }
    


}

extension SearchBarViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let overlays = Mapa.overlays
        
        let annotations = Mapa.annotations
        
        Mapa.removeOverlays(overlays)
        
        Mapa.removeAnnotations(annotations)
        
        
        Buscador.resignFirstResponder()
    
        
        let geocoder = CLGeocoder()
        
        //variable segura
        
        
        
        if let direccion = Buscador.text{
            geocoder.geocodeAddressString(Buscador.text!) { (places: [CLPlacemark]?, error: Error?) in
                
                //crear el destino
                guard let destinoRuta = places?.first?.location else { return }
                
                
                if error == nil{
                    let place = places?.first
                    print("Place: \(places!)")
                    //zoom
                    let anotacion = MKPointAnnotation()
                    anotacion.coordinate = (place?.location?.coordinate)!
                    anotacion.title = self.Buscador.text
                    
                    let span = MKCoordinateSpan(latitudeDelta: 0.06, longitudeDelta: 0.06)
                    let region = MKCoordinateRegion(center: anotacion.coordinate, span: span)
                    
                    self.Mapa.setRegion(region, animated: true)
                    self.Mapa.addAnnotation(anotacion)
                    self.Mapa.selectAnnotation(anotacion, animated: true)
                    
                    self.TrazarRuta(coordenanasDestino: destinoRuta.coordinate )
                    
                    
                } else {
                 print("Fuera del mundo paps")
                }
          
        }
        
    
        }
    }
    
    
}
