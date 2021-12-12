//
//  TeamViewController.swift
//  Lassers, Jordan Final Project
//
//  Created by Scott Lassers on 11/30/21.
//

import UIKit


class TeamViewController: UIViewController {
    
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var editTeamNameButton : UIButton!
    @IBOutlet weak var editDoneButton : UIBarButtonItem!
    
    var canDelete = false
    var team : Team!
    var players = [Player](){
        didSet{
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = team.name
        players = CoreDataHelper.retrievePlayers(from: team)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if tableView.isEditing{
            editDone()
        }
    }
    func editDone(){
        tableView.isEditing.toggle()
        editDoneButton.title = (tableView.isEditing) ? "Done" : "Edit"
        editTeamNameButton.isHidden = !tableView.isEditing
    }
    @IBAction func editTapped(_ sender: Any){
        editDone()
    }
    
    @IBAction func addPlayer(_ sender: Any){
        print("ADD")
    }
    
    @IBAction func unwindWithSegue(_ segue : UIStoryboardSegue){
        players = CoreDataHelper.retrievePlayers(from: team)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editTeamName"{
            if let newTeamViewController = segue.destination as? NewTeamViewController{
                newTeamViewController.team = team
            }
        }else if segue.identifier == "newPlayer" {
            if let newPlayerViewController = segue.destination as? NewEditPlayerViewController{
                newPlayerViewController.team = team
            }
        }else{
            if let editPlayerViewController = segue.destination as? NewEditPlayerViewController, let indexPath = tableView.indexPathForSelectedRow{
                editPlayerViewController.team = team
                //editPlayerViewController.newPlayer = false
                editPlayerViewController.player = players[indexPath.row]
            }
        }
    }
    
    
    @IBAction func editTeam(_ sender: UIButton) {
        
    }
}

extension TeamViewController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerCell", for : indexPath)
        cell.detailTextLabel?.text = players[indexPath.row].name
            cell.textLabel?.text = "#\(players[indexPath.row].number ?? "Error ")"
            return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return tableView.isEditing
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            CoreDataHelper.delete(player: players[indexPath.row])
            players = CoreDataHelper.retrievePlayers(from: team)
            tableView.reloadData()
        }
    }
    
}
