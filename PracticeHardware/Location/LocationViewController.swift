import UIKit
import MapKit
import SnapKit



class LocationViewController: UIViewController {
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        view.backgroundColor = .white
        
        checkDeviceLocationAuthorization()

    }
    

}

extension LocationViewController: CLLocationManagerDelegate {
    // 1. 권한 요청 전 폰 위치 서비스 활성화 여부 체크
    func checkDeviceLocationAuthorization() {
        DispatchQueue.global().async {
            
            if CLLocationManager.locationServicesEnabled() {
                // 현재 사용자 위치 권한 상태 확인
                let authorization: CLAuthorizationStatus
                
                if #available(iOS 14.0, *) {
                    authorization = self.locationManager.authorizationStatus
                } else {
                    authorization = CLLocationManager.authorizationStatus()
                }
                
                DispatchQueue.main.async {
                    self.checkCurrentLocationAuthorization(status: authorization)
                }
            }
        }
    }
    
    // 2) 사용자 위치 권한 상태 확인후, 권한 요청
    func checkCurrentLocationAuthorization(status: CLAuthorizationStatus) {
        switch status {
        case. notDetermined:
            print("일번")
        case .denied:
            print("이번")
        case .authorizedWhenInUse:
            print("삼번")
        default: print("Error")
        }
    }
}

