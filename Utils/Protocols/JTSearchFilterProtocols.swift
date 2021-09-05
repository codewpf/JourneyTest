//
//  JTSearchFilterProtocols.swift
//  JourneyTest
//
//  Created by Alex on 4/09/21.
//

import Foundation
import RxDataSources
import RxSwift
import RxCocoa

protocol JTModelFilterable {
    func allInformation() -> String
}

protocol JTSearchableVC {
    var searchController: UISearchController? { get set }
}


struct JTFilterBridge<Section: SectionModelType> {
    let sections: [Section]
    let type: Section
    init(sections: [Section], type: Section) {
        self.sections = sections
        self.type = type
    }
}


protocol JTSearchFilterable {
    func filterResultable<ListModel: SectionModelType>(data: JTFilterBridge<ListModel>) -> Driver<[ListModel]> where ListModel.Item: JTModelFilterable
}

extension JTSearchFilterable where Self: JTSearchableVC {
    func filterResultable<ListModel: SectionModelType>(data: JTFilterBridge<ListModel>) -> Driver<[ListModel]> where ListModel.Item: JTModelFilterable {
        guard let searchBar = self.searchController?.searchBar else {
            return Driver.just(data.sections)
        }

        return searchBar.rx.text.orEmpty
            .flatMap { query -> Driver<[ListModel]> in
                if query.isEmpty {
                    return Driver.just(data.sections)
                } else {
                    var newData: [ListModel] = []
                    for section in data.sections {
                        var sectionItems: [ListModel.Item] = []
                        for item in section.items {
                            if item.allInformation().contains(query.lowercased()) {
                                sectionItems.append(item)
                            }
                        }
                        newData.append(ListModel(original: data.type , items: sectionItems))
                    }
                    return Driver.just(newData)
                }
            }.asDriver(onErrorJustReturn: [])
    }

}

