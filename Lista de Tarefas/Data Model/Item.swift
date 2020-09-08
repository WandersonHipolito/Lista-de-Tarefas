//
//  Item.swift
//  Lista de Tarefas
//
//  Created by Wanderson Hipolito on 05/09/20.
//  Copyright © 2020 Wanderson Hipolito. All rights reserved.
//

import Foundation

class Item: Encodable, Decodable{
    
    var title: String = ""
    var done: Bool = false
    
}
