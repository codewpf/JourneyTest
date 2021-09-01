//
//  JTPostListModel.swift
//  JourneyTest
//
//  Created by Alex on 1/09/21.
//

import Foundation
import RxDataSources

struct JTPostListModel {
    var items: [JTPostModel]
}

extension JTPostListModel: SectionModelType {
    typealias Item = JTPostModel

    init(original: JTPostListModel, items: [JTPostModel]) {
        self = original
        self.items = items
    }

}
