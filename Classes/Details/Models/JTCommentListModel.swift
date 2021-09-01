//
//  JTCommentListModel.swift
//  JourneyTest
//
//  Created by Alex on 1/09/21.
//

import Foundation
import RxDataSources

struct JTCommentListModel {
    var items: [JTCommentModel]
}

extension JTCommentListModel: SectionModelType {
    typealias Item = JTCommentModel

    init(original: JTCommentListModel, items: [JTCommentModel]) {
        self = original
        self.items = items
    }

}
