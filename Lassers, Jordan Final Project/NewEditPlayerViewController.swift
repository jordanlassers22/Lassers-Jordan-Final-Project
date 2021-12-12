//
//  NewEditPlayerViewController.swift
//  Lassers, Jordan Final Project
//
//  Created by Scott Lassers on 12/1/21.
//

import UIKit

class NewEditPlayerViewController: UIViewController {

    @IBOutlet weak var playerNameTextField : UITextField!
    @IBOutlet weak var playerNumberTextField : UITextField!
    @IBOutlet weak var playerPositionTextField : UITextField!
    @IBOutlet weak var playerBirthdayTextField : UITextField!
    @IBOutlet weak var playerGamesPlayed : UITextField!
    let datePicker = UIDatePicker()
    let positions = ["Forward", "Defensemen", "Goalie"]
    let pickerView = UIPickerView()
    
    var team : Team!
    var player : Player?
    override func viewDidLoad() {
        super.viewDidLoad()
        playerNameTextField.delegate = self
        playerNumberTextField.delegate = self
        playerPositionTextField.delegate = self
        playerBirthdayTextField.delegate = self
        playerGamesPlayed.delegate = self
        createDatePicker()
        createPositionPicker()
        playerPositionTextField.tintColor = UIColor.clear
        playerBirthdayTextField.tintColor = UIColor.clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let player = player{
            playerNameTextField.text = player.name
            playerNumberTextField.text = player.number
            playerPositionTextField.text = player.position
            playerBirthdayTextField.text = player.birthday
            playerGamesPlayed.text = player.gamesPlayed
            navigationItem.title = player.name
        }else{
            navigationItem.title = "New Player"
        }
    }
    
    @IBAction func editDoneAddTapped(_ sender: UIBarButtonItem) {
        
        guard let playerName = playerNameTextField.text, playerName.count > 3 else{
            showAlert(message: "Enter a proper player name.")
            return
        }
        
        guard let playerNumberString = playerNumberTextField.text,
              let playerNumber = Int(playerNumberString), playerNumber >= 0 && playerNumber <= 99 else{
            showAlert(message: "Enter a valid player number between 0 and 99")
            return
        }
        guard let playerPosition = playerPositionTextField.text, playerPosition != "" else{
            showAlert(message: "Please select a position.")
            return
        }
        guard  let playerGamesPlayedString = playerGamesPlayed.text,
               let playerGamesPlayed = Int(playerGamesPlayedString), playerGamesPlayed >= 0 && playerGamesPlayed <= 100 else{
            showAlert(message: "Games played must be between 0 and 99.")
            return
        }
        guard let playerBirthday = playerBirthdayTextField.text, playerBirthday != "" else{
            showAlert(message: "Please enter a birthday.")
            return
        }
        
        
        if let player = player{
            player.name = playerName
            player.number = playerNumberString
            player.position = playerPosition
            player.birthday = playerBirthday
            player.gamesPlayed = playerGamesPlayedString
            
            CoreDataHelper.save()
        }else{
            let player = CoreDataHelper.newPlayer()
            player.name = playerName
            player.number = playerNumberString
            player.position = playerPosition
            player.birthday = playerBirthday
            player.gamesPlayed = playerGamesPlayedString
            player.team = team
            CoreDataHelper.save()
        }
        performSegue(withIdentifier: "unwindFromPlayer", sender: self)
    }
    
    func createPositionPicker(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(positionDonePressed))
        toolBar.setItems([doneButton], animated: true)
        pickerView.dataSource = self
        pickerView.delegate = self
        playerPositionTextField.inputAccessoryView = toolBar
        playerPositionTextField.inputView = pickerView
        pickerView.selectRow(0, inComponent: 0, animated: false)
        
    }
    @objc func positionDonePressed(){
        playerPositionTextField.text = positions[ pickerView.selectedRow(inComponent: 0)]
        self.view.endEditing(true)
    }
    func createDatePicker(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(birthdayDonePressed))
        toolBar.setItems([doneButton], animated: true)
        if #available(iOS 13.4, *){
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.maximumDate = Date()
            var dateComponents = DateComponents()
            let calendar = Calendar.init(identifier: .gregorian)
            dateComponents.year = -100
            let minDate = calendar.date(byAdding: dateComponents, to: Date())
            datePicker.minimumDate = minDate
        }
        playerBirthdayTextField.inputAccessoryView = toolBar
        playerBirthdayTextField.inputView = datePicker
        datePicker.datePickerMode = .date
    }
    @objc func birthdayDonePressed(){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        playerBirthdayTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    func showAlert(message: String){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }

}

extension NewEditPlayerViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField{
        case playerNameTextField:
            playerNumberTextField.becomeFirstResponder()
        case playerNumberTextField:
            playerPositionTextField.becomeFirstResponder()
        case playerPositionTextField:
            playerGamesPlayed.becomeFirstResponder()
        case playerGamesPlayed:
            playerBirthdayTextField.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        
        }
        return false
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == playerBirthdayTextField || textField == playerPositionTextField{
            return false
        }
        return true
    }
}

extension NewEditPlayerViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return positions.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return positions[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        playerPositionTextField.text = positions[row]
    }

    
}
