//
//  ViewController.swift
//  Plan & Hatırlatıcı
//
//  Created by Kübra Cennet Yavaşoğlu on 13.03.2023.
//

import UserNotifications //bildirimler birkaç şey için mekanizmalara sahiptir.1-zamanlamadır 2-kullanıcının bu bildirimleri planlamak için izin vermesidir. daha birçok şey var.Önemli olan şey, satırları boyunca bir şeyler okuyacak bir açılır pencere göstermemiz gerekiyor(diğer uygulamalarda old. gibi)
import UIKit

class ViewController: UIViewController {

    @IBOutlet var table: UITableView!
    
    var models = [MyReminder]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self //ıboutlet bağlantımın delegesini ve kaynağını ayarladığımdan emin olmalıyım.
        table.dataSource = self
        
     }
    //nativigation, apple'ın kullanıcı bildirimleri adı verilen bir kitaplık tarafından işlenir, bu nedenle ilk önce içe aktarmamız gereken şeyleri buraya alalım.import usernotifications ile başlayacağız
    
    @IBAction func didTapAdd() {
        //show add vc
        
        guard let vc = storyboard?.instantiateViewController(identifier: "add") as? AddViewController else {
            return
        }
        vc.title = "New Reminder"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = { title, body, date in
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                let new = MyReminder(title: title, date: date, identifier: "id_\(title)")
                self.models.append(new)
                self.table.reloadData()
                
                let content = UNMutableNotificationContent()
                content.title = title
                content.sound = .default
                content.body = body
                
                let targetDate = date
                let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second],
                                                        from: targetDate),
                                                        repeats: false)
                let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
                    if error != nil {
                        print("something went wrong")
                    }
                })
             
            }
            
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didTapTest () {
        //fire test notification - ilk olarak kullanıcıdan izin almak istiyoruz bildirimler için.
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { success, error in
            if success {
                //schedule test
                self.scheduleTest()
            }
            else if error != nil {
                print("error occurred") //izin isteme talebi bildirimler için
            }
        })
    }
    //bildirimin üç ana parçası vardır.Öncelikle bir istedğimiz olur "Kullanıcı bildirim merkezine göndereceğiz bir bildirimin eklenmesini isteyeceğiz, bir bidlrimin kendisinin de içerik parametresi vardır bu da başlığı, gövdesi, sesi vb. ve üçüncü parça tetikleyecidir."
    func scheduleTest() {
        //bildirim içeriği nesnesi oluşturacağız
        let content = UNMutableNotificationContent()
        content.title = "Hello World"
        content.sound = .default
        content.body = "My long body. My long body. My long body."
        
        //tarihleri tetiklemesine izin vereceğim.
       // DateComponents: bir tarih nasıl tekrarlanabilir? Bu yüzden bu kod tarih bileşenlerini alır böylece ylın beşinci haftasını belirtebilriz.
        let targetDate = Date().addingTimeInterval(10)
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second],
                                                from: targetDate),
                                                repeats: false)
    
        let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
//gerçek bildirim oluşturacağım
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            if error != nil {
                print("something went wrong")
            }
        })
    }
}

//bazı uzantılar eklemeliyim

//TEMEL TABLO GÖRÜNÜMÜ İŞLEVLERİMİ UYGULARIM
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row].title
        let date = models[indexPath.row].date
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM, dd, YYYY at hh: mm a"
        cell.detailTextLabel?.text = formatter.string(from: date)
        return cell
    }
    
}

//hatırlatıcı nesnelerimi tutmak için bir yola ihtiyacım olacak.Hatırlatıcım olacak yapı oluştururum.Tabii ki hatırlatıcıma bir başlık, tarih ve bir tanımlayıcı eklemeliyim.
//Temelde uygulamamda yeni bir hatırlatıcı planladığımızda buna bir referans tutacağız böylece başlığı ve ayarladığı tarihi listemizde gösterebiliriz.
struct MyReminder {
    let title: String
    let date: Date
    let identifier: String
}





