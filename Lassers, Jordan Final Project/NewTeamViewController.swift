//
//  NewTeamViewController.swift
//  Lassers, Jordan Final Project
//
//  Created by Scott Lassers on 11/24/21.
//
import UIKit
class NewTeamViewController : UIViewController{
    
    var team : Team?
    @IBOutlet weak var teamNameText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let team = team{
            teamNameText.text = team.name
        }
        
    }
    
    @IBAction func submitTeamName(_ sender: Any) {
        
    }
    //Prepares for segue by updating TeamListView controller with the newly created team, and saves it in core data.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let text = teamNameText.text, text != "" else {return}
        if let teamListViewController = segue.destination as? TeamListViewController{
            team = CoreDataHelper.newTeam()
            team?.name = text
            CoreDataHelper.save()
            teamListViewController.tableView.reloadData()
        }else if let _ = segue.destination as? TeamViewController, let team = team{
            team.name = text
            CoreDataHelper.save()
        }
    }
}

