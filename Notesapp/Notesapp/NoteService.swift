//
//  NoteService.swift
//  Notesapp
//
//  Created by DCS on 07/07/21.
//  Copyright © 2021 DCS. All rights reserved.
//

import Foundation
class NoteService {
    
    static func  getDocDir () -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print("\(paths)")
        return paths[0]
    }
}
