//
//  DynamicTypes.swift
//  Marvel
//
//  Created by Petra Cvrljevic on 02/09/2018.
//  Copyright © 2018 Petra Cvrljevic. All rights reserved.
//

import Foundation

class Dynamic<T> {
    
    var bind :(T) -> () = { _ in }
    
    var value :T? {
        didSet {
            bind(value!)
        }
    }
    
    init(_ v :T) {
        value = v
    }
    
}
