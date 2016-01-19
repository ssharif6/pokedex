//
//  Pokemon.swift
//  Pokedex
//
//  Created by Shaheen Sharifian on 1/18/16.
//  Copyright © 2016 Shaheen Sharifian. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    private var _name: String!
    private var _pokedexId: Int!
    private var _descrition: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _baseAttack: String!
    private var _evoText: String!
    private var _pokemonURL: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLevel: String!
    private var _nextEvolutionTxt: String!

    var description: String {
        get {
            if _descrition == nil {
                return ""
            }
            return _descrition
        }
    }
    
    var type: String {
        get {
            if _type == nil {
                return ""
            }
            return _type
        }

    }
    
    var defense: String {
        get {
            if _defense == nil {
                return ""
            }
            return _defense
        }
    }
    
    var height: String {
        get {
            if _height == nil {
                return ""
            }
            return _height
        }
    }
    
    var weight: String {
        get {
            if _weight == nil {
                return ""
            }
            return _weight
        }
    }
    
    var attack: String {
        get {
            if _baseAttack == nil {
                return ""
            }
            return _baseAttack
        }
    }
    
    var evoText: String {
        get {
            if _evoText == nil {
                return ""
            }
            return _evoText
        }
    }
    
    var nextEvolutionId: String {
        get {
            if _nextEvolutionId == nil {
                return ""
            }
        return _nextEvolutionId
        }
    }
    
    var nextEvolutionTxt: String {
        get {
            if _nextEvolutionTxt == nil {
                return ""
            }
            return _nextEvolutionTxt
        }
    }
    
    var nextEvolutionLevel: String {
        get {
            if _nextEvolutionLevel == nil {
                return ""
            }
            return _nextEvolutionLevel
        }
    }
    
    var name: String {
        get {
            if _name == nil {
                return ""
            }
            return _name;
        }
    }
    var pokedexId: Int {
        get {
            if _pokedexId == nil {
                return -1
            }
            return _pokedexId
        }
    }
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId)/"
    }
    
    func downloadPokemonDetails(completed: DownloadComplete) {
        let url = NSURL(string: _pokemonURL)!
        Alamofire.request(.GET, url).responseJSON { response in
            let result = response.result
            if let dict = result.value as? Dictionary<String, AnyObject> {
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String {
                    self._height = height
                }
                
                if let attack = dict["attack"] as? Int {
                    self._baseAttack = "\(attack)"
                }
                
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                
                if let types = dict["types"] as? [Dictionary<String, String>] where types.count > 0 {
                    if let name = types[0]["name"] {
                        self._type = name
                    }
                    if types.count > 1 {
                        for var x = 1; x < types.count; x++ {
                            if let name = types[x]["name"] {
                                self._type! += "/\(name)"
                            }
                        }
                    }
                } else {
                    self._type = ""
                }
                print(self._type)
                
                if let descArr = dict["descriptions"] as? [Dictionary<String, String>] where descArr.count > 0 {
                    
                    if let url = descArr[0]["resource_uri"] {
                        let nsurl = NSURL(string: "\(URL_BASE)\(url)")!
                        
                        Alamofire.request(.GET, nsurl).responseJSON { response in
                            
                            let desResult = response.result
                            if let descDict = desResult.value as? Dictionary<String, AnyObject> {
                                
                                if let description = descDict["description"] as? String {
                                    self._descrition = description
                                    print(self._descrition)
                                    
                                }
                            }
                            
                            completed()
                        }
                    }
                    
                } else {
                    self._descrition = ""
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String,AnyObject>] where evolutions.count > 0{
                    
                    if let to = evolutions[0]["to"] as? String {
                        
                        //Can't support mega pokemon right now but
                        //api still has mega data
                        if to.rangeOfString("mega") == nil {
                            
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                
                                let newStr = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                                
                                let num = newStr.stringByReplacingOccurrencesOfString("/", withString: "")
                                
                                self._nextEvolutionId = num
                                self._nextEvolutionTxt = to
                                
                                if let lvl = evolutions[0]["level"] as? Int {
                                    self._nextEvolutionLevel = "\(lvl)"
                                }
                                
                                print(self._nextEvolutionId)
                                print(self._nextEvolutionTxt)
                                print(self._nextEvolutionLevel)
                                
                            }
                        }
                        
                    }
                    
                }
            }
        }
    }
}