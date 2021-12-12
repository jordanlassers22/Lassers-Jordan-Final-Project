//
//  CoreDataHelper.swift
//  Lassers, Jordan Final Project
//
//  Created by Scott Lassers on 12/4/21.
//

import UIKit
import CoreData
struct CoreDataHelper {
    static let context: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }

        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.viewContext

        return context
    }()
    //Creates a new team in core data
    static func newTeam() -> Team{
        let team = NSEntityDescription.insertNewObject(forEntityName: "Team", into: context) as! Team
        return team
    }
    //Creates a new player in core data
    static func newPlayer() -> Player{
        let player = NSEntityDescription.insertNewObject(forEntityName: "Player", into: context) as! Player
        return player
    }
    static func save(){
        do {
            try context.save()
        }catch let error{
            print("Could not save. Error \(error.localizedDescription)")
        }
    }
    //Removes a team and all of its players from users device.
    static func delete(team : Team){
         let players = team.players.array(of: Player.self)
            for player in players{
                context.delete(player)
            }
        context.delete(team)
        save()
    }
    static func delete(player : Player){
        context.delete(player)
        save()
    }
    static func retrieveTeams()-> [Team]{
        do{
            let fetchRequest = NSFetchRequest<Team>(entityName: "Team")
            let results = try context.fetch(fetchRequest)
            return results
        }catch let error{
            print("Could not save. Error \(error.localizedDescription)")
            return []
        }
    }
    //Retrieves a teams array of players from the users device.
    static func retrievePlayers(from team: Team)-> [Player]{
        print("Getting players from team: \(team.name ?? "No team name")")
        do{
            let fetchRequest = NSFetchRequest<Player>(entityName: "Player")
            let results = try context.fetch(fetchRequest)
            var players = [Player]()
            for player in results{
                if let playerTeam = player.team, playerTeam == team{
                    players.append(player)
                }
            }
            return players
        }catch let error{
            print("Could not save. Error \(error.localizedDescription)")
            return []
        }
    }
}
extension Optional where Wrapped == NSSet {
    func array<T: Hashable>(of: T.Type) -> [T] {
        if let set = self as? Set<T> {
            return Array(set)
        }
        return [T]()
    }
}
