//
//  ControlCenter.swift
//  Pirate Fleet
//
//  Created by Jarrod Parkes on 9/2/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

struct GridLocation {
    let x: Int
    let y: Int
}

struct Ship {
    let length: Int
    let location: GridLocation
    let isVertical: Bool
    let isWooden: Bool
    

// TODO: Add the computed property, cells.
    var cells: [GridLocation] {
        get {
            // Hint: These two constants will come in handy
            let start = self.location
            let end: GridLocation = ShipEndLocation(self)
            var occupiedCells = [GridLocation]()
            
            if start.x != end.x {
                for x in start.x ... end.x {
                    let coords = GridLocation(x: x, y: start.y)
                    occupiedCells.append(coords)
                }
            } else if start.y != end.y {
                for y in start.y ... end.y {
                    let coords = GridLocation(x: start.x, y: y)
                    occupiedCells.append(coords)
                }
            }
        
            // Hint: The cells getter should return an array of GridLocations.
            return occupiedCells
        }
    }
    
    var hitTracker: HitTracker
// TODO: Add a getter for sunk. Calculate the value returned using hitTracker.cellsHit.
    var sunk: Bool {
        get {
            let numberOfCellsInShip = cells.count
            var hitNumberOfCellsInShip: Int = 0
            for cell in cells {
                if hitTracker.cellsHit[cell] == true {
                    hitNumberOfCellsInShip += 1
                    if hitNumberOfCellsInShip == numberOfCellsInShip {
                        return true
                    }
                }
            }
        return false
        }
    }

// TODO: Add custom initializers
    init(length: Int, location: GridLocation, isVertical: Bool) {
        self.length = length
        self.location = location
        self.isVertical = isVertical
        self.isWooden = false
        self.hitTracker = HitTracker()
    }
    init(length: Int, location: GridLocation, isVertical: Bool, isWooden: Bool) {
        self.length = length
        self.location = location
        self.isVertical = isVertical
        self.isWooden = isWooden
        self.hitTracker = HitTracker()
    }
}

// TODO: Change Cell protocol to PenaltyCell and add the desired properties
protocol PenaltyCell {
    var location: GridLocation {get}
    var guaranteesHit: Bool {get}
    var penaltyText: String {get}
}

// TODO: Adopt and implement the PenaltyCell protocol
struct Mine: PenaltyCell {
    let location: GridLocation
    var guaranteesHit: Bool
    var penaltyText: String

    init(location: GridLocation, penaltyText: String) {
        self.location = location
        self.guaranteesHit = false
        self.penaltyText = penaltyText
    }
    init(location: GridLocation, guaranteesHit: Bool, penaltyText: String) {
        self.location = location
        self.guaranteesHit = guaranteesHit
        self.penaltyText = penaltyText
    }
}

// TODO: Adopt and implement the PenaltyCell protocol
struct SeaMonster: PenaltyCell {
    let location: GridLocation
    var guaranteesHit: Bool
    var penaltyText: String
}

class ControlCenter {
    
    func placeItemsOnGrid(human: Human) {
        
        let smallShip = Ship(length: 2, location: GridLocation(x: 3, y: 4), isVertical: true, isWooden: true)
        human.addShipToGrid(smallShip)
        
        let mediumShip1 = Ship(length: 3, location: GridLocation(x: 0, y: 0), isVertical: false, isWooden: true)
        human.addShipToGrid(mediumShip1)
        
        let mediumShip2 = Ship(length: 3, location: GridLocation(x: 3, y: 1), isVertical: false, isWooden: true)
        human.addShipToGrid(mediumShip2)
        
        let largeShip = Ship(length: 4, location: GridLocation(x: 6, y: 3), isVertical: true)
        human.addShipToGrid(largeShip)
        
        let xLargeShip = Ship(length: 5, location: GridLocation(x: 7, y: 2), isVertical: true)
        human.addShipToGrid(xLargeShip)
        
        let mine1 = Mine(location: GridLocation(x: 6, y: 0), guaranteesHit: true, penaltyText: "Oh No a Mine!")
        human.addMineToGrid(mine1)
        
        let mine2 = Mine(location: GridLocation(x: 3, y: 3), penaltyText: "Oh No a Mine!")
        human.addMineToGrid(mine2)
        
        let seamonster1 = SeaMonster(location: GridLocation(x: 5, y: 6), guaranteesHit: true, penaltyText: "Ouchy SeaMonster!")
        human.addSeamonsterToGrid(seamonster1)
        
        let seamonster2 = SeaMonster(location: GridLocation(x: 2, y: 2), guaranteesHit: true, penaltyText: "Ouchy SeaMonster!")
        human.addSeamonsterToGrid(seamonster2)
    }
    
    func calculateFinalScore(gameStats: GameStats) -> Int {
        
        var finalScore: Int
        
        let sinkBonus = (5 - gameStats.enemyShipsRemaining) * gameStats.sinkBonus
        let shipBonus = (5 - gameStats.humanShipsSunk) * gameStats.shipBonus
        let guessPenalty = (gameStats.numberOfHitsOnEnemy + gameStats.numberOfMissesByHuman) * gameStats.guessPenalty
        
        finalScore = sinkBonus + shipBonus - guessPenalty
        
        return finalScore
    }
}