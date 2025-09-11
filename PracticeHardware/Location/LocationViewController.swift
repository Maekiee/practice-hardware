import UIKit
import MapKit
import SnapKit



final class LocationViewController: UIViewController {
    private let locationManager = CLLocationManager()
    private let mapView = MKMapView()
    private let loadingWeatherLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    private let locationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "location.fill"), for: .normal)
        return button
    }()
    private let refreshButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configHierarchy()
        configLayout()
        configView()
        
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
            } else {
                print("위치 서비스가 꺼져있어서, 위치 권한 요청을 할 수 없음")
            }
        }
    }
    
    // 2) 사용자 위치 권한 상태 확인후, 권한 요청
    func checkCurrentLocationAuthorization(status: CLAuthorizationStatus) {
        switch status {
        case.notDetermined:
            // 앱을 사용하는 동안 허용
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            print("사용자가 거부한 상황, iOS 설정 창으로 이동하라는 얼럿 띄우기")
            showLoactionSettingAlert()
        case .authorizedWhenInUse:
            print("삼번")
        default: print("Error")
        }
    }
    
    func showLoactionSettingAlert() {
        let alert = UIAlertController(title: "위치 정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정'> '개인정보 보호'에서 위치 서비스를 켜주세요", preferredStyle: .alert)
        
        let goSetting = UIAlertAction(title: "설정으로 이동", style: .default) { _ in
            if let setting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(setting)
            }
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(goSetting)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    func setRegionAndAnnotation(center: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: center,
                                        latitudinalMeters: 500,
                                        longitudinalMeters: 500)
        
        mapView.setRegion(region, animated: true)
    }
    
}


extension LocationViewController {
    
    
    func configHierarchy() {
        [
            mapView,
            loadingWeatherLabel,
            locationButton,
            refreshButton
        ].forEach { view.addSubview($0) }
    }
    
    func configLayout() {
        mapView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(400)
        }
        
        loadingWeatherLabel.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        locationButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(28)
        }
        
        refreshButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-28)
        }
    }
    
    func configView() {
        view.backgroundColor = .white
        locationManager.delegate = self
    }
}

