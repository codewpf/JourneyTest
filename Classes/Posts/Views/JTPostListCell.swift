//
//  JTPostListCell.swift
//  JourneyTest
//
//  Created by Alex on 1/09/21.
//

import UIKit

class JTPostListCell: UITableViewCell, JTReuseIdentifier, JTCellConstant {

    static var height: CGFloat = 90
    
    private var _model: JTPostModel?
    var model: JTPostModel? {
        willSet(newValue) {
            guard let value = newValue else {
                return
            }
            self._model = value
            // todo
        }
    }

    

}
