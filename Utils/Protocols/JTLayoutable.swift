//
//  JTLayoutable.swift
//  JourneyTest
//
//  Created by Alex on 31/08/21.
//

import Foundation
import UIKit

protocol JTLayoutable {
    
}

extension JTLayoutable where Self: UIViewController {
    var margin: CGFloat {
        get { return 20 }
    }
    
    var smallMargin: CGFloat {
        get { return 10}
    }

}

extension JTLayoutable where Self: UIView {
    var margin: CGFloat {
        get { return 20 }
    }
    
    var smallMargin: CGFloat {
        get { return 10}
    }

}

