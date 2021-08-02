//
//  RunViewController.swift
//  Rave Fitness
//
//  Created by liuyang on 7/25/21.
//

import UIKit
import CoreLocation
import MapKit
class RunViewController: UIViewController {
  @IBOutlet weak var stopButton: UIButton!
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var distanceLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var paceLabel: UILabel!
  
  private var run: Run?
  private let locationManager = LocationManager.shared
  private var seconds = 0
  private var timer: Timer?
  private var distance = Measurement(value: 0, unit: UnitLength.meters)
  private var locationList: [CLLocation] = []
  private var latitudes: [Double] = []
  private var longitudes: [Double] = []
    private var coordinate: [CLLocationCoordinate2D] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    startRun()
    Utility.styleFilledButton(stopButton)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    timer?.invalidate()
    locationManager.stopUpdatingLocation()
  }
  
  func eachSecond() {
    seconds += 1
    updateDisplay()
  }
  
  private func updateDisplay() {
    let formattedDistance = DataFormat.distance(distance)
    let formattedTime = DataFormat.time(seconds)
    let formattedPace = DataFormat.pace(distance: distance, seconds: seconds, outputUnit: UnitSpeed.minutesPerMile)
    
    distanceLabel.text = "DISTANCE: \(formattedDistance)"
    timeLabel.text = "TIME: \(formattedTime)"
    paceLabel.text = "PACE: \(formattedPace)"
    loadMap()
  }
  
    private func mapRegion() -> MKCoordinateRegion? {
      guard
        locationList.count > 0
      else
      {
        return nil
      }
      
      
        let center = CLLocationCoordinate2D(latitude: locationList.last?.coordinate.latitude ?? 37, longitude: locationList.last?.coordinate.longitude ?? 37)
      
        let span = MKCoordinateSpan(latitudeDelta: 0.0022, longitudeDelta: 0.0022)
      
      return MKCoordinateRegion(center: center, span: span)
      }
    
    
    private func loadMap() {
      guard
        locationList.count > 0,
        let region = mapRegion()
      else {
       
        return
      }
      let polyline = MKPolyline(coordinates: coordinate, count: coordinate.count)
      mapView.setRegion(region, animated: true)
      mapView.addOverlay(polyline)
      mapView.showsUserLocation = true
    }
    

    
  private func startLocationUpdates() {
    locationManager.delegate = self
    locationManager.activityType = .fitness
    locationManager.distanceFilter = 10
    locationManager.startUpdatingLocation()
  }
  
  private func saveRun() {
    let newRun = Run(context: CoreData.context)
    newRun.distance = distance.value
    newRun.duration = Int16(seconds)
    newRun.timestamp = Date()
    
    for location in locationList {
      let locationObject = Location(context: CoreData.context)
      locationObject.timestamp = location.timestamp
      locationObject.latitude = location.coordinate.latitude
      locationObject.longitude = location.coordinate.longitude
      newRun.addToLocations(locationObject)
    }
    
    CoreData.saveContext()
    
    run = newRun
  }
  
  private func startRun()
  {
    seconds = 0
    distance = Measurement(value: 0, unit: UnitLength.meters)
    locationList.removeAll()
    updateDisplay()
    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
      self.eachSecond()
    }
    startLocationUpdates()
  }
  
  private func stopRun()
  {
    stopButton.isHidden = true
    
    locationManager.stopUpdatingLocation()
  }
  
  @IBAction func stopTapped() {
    let alertController = UIAlertController(title: "End Run?",
                                            message: "End the current run now?",
                                            preferredStyle: .actionSheet)
    alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    
    alertController.addAction(UIAlertAction(title: "Save Run", style: .default) {_ in
      self.stopRun()
      self.saveRun()
      self.performSegue(withIdentifier: .details, sender: nil)
    })
    
    alertController.addAction(UIAlertAction(title: "Discard Run", style: .destructive) {_ in
      self.stopRun()
      _ = self.navigationController?.popToRootViewController(animated: true)
    })
    
    present(alertController, animated: true)
    
  }
  
}

extension RunViewController: SegueHandlerType {
  enum SegueIdentifier: String {
    case details = "SummaryViewController"
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
  switch segueIdentifier(for: segue) {
  case .details:
    let destination = segue.destination as! SummaryViewController
      destination.run = run
    }
  }
}


extension RunViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    for newLocation in locations {
      guard newLocation.horizontalAccuracy < 20 && abs(newLocation.timestamp.timeIntervalSinceNow) < 10 else { continue }
      
      if let lastLocation = locationList.last {
        let delta = newLocation.distance(from: lastLocation)
        distance = distance + Measurement(value: delta, unit: UnitLength.meters)
      }
      
    locationList.append(newLocation)
    latitudes.append(newLocation.coordinate.latitude)
    longitudes.append(newLocation.coordinate.longitude)
    coordinate.append(CLLocationCoordinate2D(latitude: newLocation.coordinate.latitude, longitude: newLocation.coordinate.longitude))
    }
  }
}

extension RunViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    guard let polyline = overlay as? MKPolyline else {
      return MKOverlayRenderer(overlay: overlay)
    }
    let renderer = MKPolylineRenderer(polyline: polyline)
    renderer.strokeColor = .blue
    renderer.lineWidth = 5
    return renderer
  }
}

