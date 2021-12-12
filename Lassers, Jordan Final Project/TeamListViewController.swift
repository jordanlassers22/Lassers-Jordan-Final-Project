//
//  TeamListViewController.swift
//  Lassers, Jordan Final Project
//
//  Created by Scott Lassers on 11/11/21.
//

import UIKit

class TeamListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editDoneButton : UIBarButtonItem!
    var teams = [Team](){
        didSet{
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        teams = CoreDataHelper.retrieveTeams()
     
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
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
    }

    @IBAction func createNewTeam(_ sender: UIButton){
        performSegue(withIdentifier: "showNewTeamViewController", sender: nil)
    }
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let teamViewController = segue.destination as? TeamViewController, let indexPath = tableView.indexPathForSelectedRow, segue.identifier == "showTeamViewController" {
        let team = teams[indexPath.row]
        teamViewController.team = team
        }
   }
    @IBAction func editAction(_ sender: UIBarButtonItem){
       editDone()
    }
    @IBAction func unwindWithSegue(_ segue : UIStoryboardSegue){
        teams = CoreDataHelper.retrieveTeams()
    }
}

extension TeamListViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "teamNameCell", for: indexPath)
        cell.textLabel?.text = teams[indexPath.row].name
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            CoreDataHelper.delete(team: teams[indexPath.row])
            teams = CoreDataHelper.retrieveTeams()
            tableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return tableView.isEditing
    }
    
    
    
}
