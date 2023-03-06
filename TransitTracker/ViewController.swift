//
//  ViewController.swift
//  BusThing
//
//  Created by Owen Guo on 2023-03-03.
//

import GoogleMaps
import UIKit
import CoreLocation
import WebKit

class ViewController: UIViewController {
    private let button: UIButton = {
        let button = UIButton (frame: CGRect(x: 115, y: 650, width: 150, height: 52))
        button.backgroundColor = .gray
        button.setTitle("Find Route!", for: .normal)
        button.layer.cornerRadius = 25
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    let startPoint: UITextField = UITextField(frame: CGRect(x: 40, y: 555, width: 300, height: 30))
    let endPoint: UITextField = UITextField(frame: CGRect(x: 40, y: 600, width: 300, height: 30))
    
    let padding1 = UIView(frame: CGRect(x: 0, y: 0, width: 11, height: 30))
    let padding2 = UIView(frame: CGRect(x: 0, y: 0, width: 11, height: 30))
    
    @IBOutlet weak var textField: UITextField!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        
        //view.backgroundColor = .systemCyan
        view.addSubview(button)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        setBackground()
        startPoint.textAlignment = .left
        startPoint.leftView = padding1
        startPoint.leftViewMode = .always
        startPoint.placeholder = "Choose starting point..."
        startPoint.backgroundColor = UIColor.white
        startPoint.layer.cornerRadius = 15
        startPoint.textColor = UIColor.darkGray
        view.addSubview(startPoint)
        
        endPoint.textAlignment = .left
        endPoint.leftView = padding2
        endPoint.leftViewMode = .always
        endPoint.placeholder = "Choose destination..."
        endPoint.backgroundColor = UIColor.white
        endPoint.layer.cornerRadius = 15
        endPoint.textColor = UIColor.darkGray
        view.addSubview(endPoint)
        
        

    }
    func setBackground(){
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        
        backgroundImage.image = UIImage(named: "HomeBackground")
        backgroundImage.contentMode =  .scaleAspectFill
        view.insertSubview(backgroundImage, at: 0)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    @objc func didTapButton() {
        let tabBarVC = UITabBarController()
        tabBarVC.tabBar.backgroundColor = UIColor.white
        let vc2 = UINavigationController(rootViewController: ViewController())
        let vc3 = UINavigationController(rootViewController: FirstViewController())
        let vc1 = UINavigationController(rootViewController: SecondViewController())
        
        tabBarVC.setViewControllers([vc3, vc2, vc1], animated: false)
        
        guard let items = tabBarVC.tabBar.items else {
            return
        }
        
        vc1.title = "Map"
        vc3.title = "Settings"
        vc2.title = "Home"
        items[1].image = UIImage(systemName: "house")
        items[0].image = UIImage(systemName: "map")
        items[2].image = UIImage(systemName: "bell")
        
        tabBarVC.modalPresentationStyle = .fullScreen
        present(tabBarVC, animated: false)
    }
    
    //requestion for location
     let locationServices = CLLocationManager()
     private func initializeLocationServices(){
         locationServices.delegate = self
         
         DispatchQueue.global().async {
             if CLLocationManager.locationServicesEnabled(){
                 guard CLLocationManager.locationServicesEnabled() else {
                     return
                 }
             }
         }
         locationServices.requestWhenInUseAuthorization()
     }
 }
 extension ViewController: CLLocationManagerDelegate{
     func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
         let status = manager.authorizationStatus
         switch status {
         case .notDetermined:
             print("Not Determined")
         case .denied:
             print("Denied")
         case .restricted:
             print("Restriced")
         case .authorizedAlways:
             print("Authorized Always")
         case .authorizedWhenInUse:
             print("Authorized when in use")
         default:
             print("unknown")
         }
     }
     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
         print(locations)
     }
 }

    

class FirstViewController: UIViewController, WKUIDelegate {
        var webView: WKWebView!
        
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Map"
        
        let myURL = Bundle.main.url(forResource: "Directions", withExtension: "html")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
}


//setting view
struct SettingsOption{
    let title: String
    let icon: UIImage?
    let iconBackgroundColor: UIColor
    let handler: (() -> Void)
}
struct Section{
    let title: String
    let options: [SettingsOptionType]
}
enum SettingsOptionType{
    case staticCell(model: SettingsOption)
    case switchCell(model: SettingsSwitchOption)
}
struct SettingsSwitchOption{
    let title: String
    let icon: UIImage?
    let iconBackgroundColor: UIColor
    let handler: (() -> Void)
    var isOn: Bool
}
class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
        table.register(SwitchTableViewCell.self, forCellReuseIdentifier: SwitchTableViewCell.identifier)
        
        return table
    }()
    var models = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemRed
        configure()
        title = "Settings"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
    }
    func configure() {
            models.append(Section(title: "General", options: [
                .staticCell(model: SettingsOption(title: "Volume", icon: UIImage(systemName: "speaker.wave.2.circle.fill"), iconBackgroundColor: .systemPink){
                    self.present(VolumeController(), animated: true, completion: nil)
                }),
                .staticCell(model: SettingsOption(title: "Sound Effect", icon: UIImage(systemName: "headphones"), iconBackgroundColor: .systemPink){
                    self.present(soundController(), animated: true, completion: nil)
                }),
            ]))
            models.append(Section(title: "Alarms", options: [
                .switchCell(model: SettingsSwitchOption(title: "Alarm 1", icon: UIImage(systemName: "alarm.fill"), iconBackgroundColor: .systemRed, handler: {
                    
                }, isOn: true)),
                .switchCell(model: SettingsSwitchOption(title: "Alarm 2", icon: UIImage(systemName: "alarm.fill"), iconBackgroundColor: .systemRed, handler: {
                    
                }, isOn: true))
            ]))
        }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = models[section]
        
        return section.title
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].options.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.section].options[indexPath.row]
        
        switch model.self{
        case .staticCell(let model):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SettingTableViewCell.identifier,
                for: indexPath
            ) as? SettingTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: model)
            return cell
        case .switchCell(let model):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SwitchTableViewCell.identifier,
                for: indexPath
            ) as? SwitchTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: model)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated:  true)
        let type = models[indexPath.section].options[indexPath.row]
        switch type.self{
        case .staticCell(let model):
            model.handler()
        case .switchCell(let model):
            model.handler()
        }
        
    }
}

//Volume Cell
class VolumeController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemRed
    }
}

class soundController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        createButton()
    }
    func createButton() {
        let button = UIButton(frame: CGRect(x: 0, y:0, width: self.view.frame.width, height: 50))
        button.tintColor = .white
        button.center = view.center
        button.configuration = createConfig()
        view.addSubview(button)
    }
    func createConfig() -> UIButton.Configuration{
        var config: UIButton.Configuration = .filled()
        config.title = "Button-Sound"
        config.baseBackgroundColor = .black
        return config
    }
    
}
