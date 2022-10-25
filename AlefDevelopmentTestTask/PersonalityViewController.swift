//
//  PersonalityViewController.swift
//  AlefDevelopmentTestTask
//
//  Created by Артур Фомин on 24.10.2022.
//

import UIKit

class PersonalityViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var childsTableView: UITableView!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var addChildButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    //MARK: - let/var
    
    var childs: [ChildModel] = [] {
        didSet {
            if childs.count > 4 {
                addChildButton.isHidden = true
            } else {
                addChildButton.isHidden = false
            }
        }
    }
    
    //MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        registerForKeyboardNotifications()
        childsTableView.dataSource = self
        childsTableView.delegate = self
        
    }

    //MARK: - IBActions
    
    @IBAction func addChildPressed(_ sender: UIButton) {
        childs.append(ChildModel(fullName: "", age: ""))
        childsTableView.reloadData()
    }
    
    @IBAction func clearPressed(_ sender: UIButton) {
        showActionSheet(title: "Внимание", message: "Вы действительно хотите удалить все данные?")
    }
    
    //MARK: - private funcs
    
    private func setupUI() {
        addChildButton.layer.cornerRadius = addChildButton.frame.height / 2
        addChildButton.layer.borderWidth = 2
        addChildButton.layer.borderColor = UIColor.systemBlue.cgColor
        
        clearButton.layer.cornerRadius = clearButton.frame.height / 2
        clearButton.layer.borderWidth = 2
        clearButton.layer.borderColor = UIColor.systemRed.cgColor
    }
    
    private func showActionSheet(title: String, message: String) {
        let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let delete = UIAlertAction(title: "Сбросить данные", style: .destructive) { delete in
            self.childs = []
            self.childsTableView.reloadData()
            self.fullNameTextField.text = ""
            self.ageTextField.text = ""
        }
        let cancle = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        actionSheet.addAction(delete)
        actionSheet.addAction(cancle)
        present(actionSheet, animated: true, completion: nil)
    }
    
    private func registerForKeyboardNotifications() {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
            guard let userInfo = notification.userInfo,
                  let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
                  let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
            
            if notification.name == UIResponder.keyboardWillHideNotification {
                bottomConstraint.constant = 42
            } else {
                bottomConstraint.constant = keyboardScreenEndFrame.height + 10
            }
            
            view.needsUpdateConstraints()
            UIView.animate(withDuration: animationDuration) {
                self.view.layoutIfNeeded()
            }
        }
}

//MARK: - Extensions

extension PersonalityViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return childs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "childCell", for: indexPath)
                as? ChildTableViewCell else { return UITableViewCell() }
        cell.didDelete = { myCell in
            guard let currentIndexPath = tableView.indexPath(for: myCell) else { return }
            self.childs.remove(at: currentIndexPath.row)
            tableView.deleteRows(at: [currentIndexPath], with: .automatic)
        }
        cell.fullNameTextField.delegate = self
        cell.ageTextField.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
   
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}

extension PersonalityViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textField.resignFirstResponder()
        return true
    }
}
