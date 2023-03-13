//
//  AddViewController.swift
//  Plan & Hatırlatıcı
//
//  Created by Kübra Cennet Yavaşoğlu on 13.03.2023.
//

import UIKit

class AddViewController: UIViewController, UITextFieldDelegate {
    
    //yeni bir bildirim planlamak için neye ihtiyacım var . Bi tane hatırlatıcı oluştur, yani temelde bu hatırlatıcının kaldırılmasını istediğimiz bir tarihe ihtiyacımız var ve ayrıca başlığa ve bildirimin ana bölümüne ihtiyacımız var.
    
    @IBOutlet var titleField: UITextField!
    @IBOutlet var bodyField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    
    public var completion: ((String, String, Date) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.delegate = self
        bodyField.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSaveButton))
        
        
    }
    
    //didtapsave satırı olarak adlandırılına bir action oluşturacağım.Kullanıcı dokunduğunda bunu bu kod içerisinde doğrulayacağız.
    
    @objc func didTapSaveButton() {
        if let titleText = titleField.text, !titleText.isEmpty,
           let bodyText = bodyField.text, !bodyText.isEmpty {
            
            let targetDate = datePicker.date
            completion?(titleText, bodyText, targetDate)
        }
        
    }
    
    func textFieldSholudReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        
    }
}
