//
//  Themes.swift
//  BlindMatrix
//
//  Created by Jeyaganthan's Mac Mini on 16/09/21.
//

import Foundation


class Themes : NSObject {
    
    static let shared = Themes()
    
    func checkNull(_ str : Any?) -> String{
        return str is NSNull || str == nil ? "" : String(describing: str!)
    }
}
