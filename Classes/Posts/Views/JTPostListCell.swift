//
//  JTPostListCell.swift
//  JourneyTest
//
//  Created by Alex on 1/09/21.
//

import UIKit
import WPFoundation

class JTPostListCell: UITableViewCell, JTReuseIdentifier, JTCellConstant, JTLayoutable {

    static var height: CGFloat = 60
    
    private let title: UILabel = UILabel().then {
        $0.textColor = .label
        $0.font = .systemFont(ofSize: 20)
    }
    private let body: UILabel = UILabel().then {
        $0.textColor = .tertiaryLabel
        $0.font = .systemFont(ofSize: 14)
        $0.lineBreakMode = .byTruncatingTail
    }

    private var _model: JTPostModel?
    var model: JTPostModel? {
        willSet(newValue) {
            guard let value = newValue else {
                return
            }
            self._model = value
            self.title.text = newValue?.title
            self.body.text = newValue?.body
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(self.title)
        self.title.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(self.margin)
            make.top.equalToSuperview().offset(self.smallMargin)
            make.height.equalTo((JTPostListCell.height-(self.smallMargin*1.5))/3*2)
        }
        
        self.contentView.addSubview(self.body)
        self.body.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.title)
            make.bottom.equalToSuperview().inset(self.smallMargin / 2)
            make.height.equalTo((JTPostListCell.height-(self.smallMargin*1.5))/3)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    

}
