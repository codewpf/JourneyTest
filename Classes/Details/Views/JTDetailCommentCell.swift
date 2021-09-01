//
//  JTDetailCommentCell.swift
//  JourneyTest
//
//  Created by Alex on 1/09/21.
//

import UIKit
//import WPFoundation

class JTDetailCommentCell: UITableViewCell, JTReuseIdentifier, JTCellConstant, JTLayoutable {
    
    static var height: CGFloat = 80
    
    private let name: UILabel = UILabel().then {
        $0.textColor = .label
        $0.lineBreakMode = .byClipping
        $0.font = .systemFont(ofSize: 17)
        $0.accessibilityIdentifier = JTUITestKeys.keys.detailCellNameLabel
    }
    
    private let email: UILabel = UILabel().then {
        $0.textColor = .tertiaryLabel
        $0.textAlignment = .right
        $0.font = .systemFont(ofSize: 12)
    }

    private let body: UILabel = UILabel().then {
        $0.textColor = .secondaryLabel
        $0.font = .systemFont(ofSize: 15)
        $0.numberOfLines = 0
        $0.accessibilityIdentifier = JTUITestKeys.keys.detailCellBodyLabel
    }
    
    private var _model: JTCommentModel?
    var model: JTCommentModel? {
        willSet(newValue) {
            guard let value = newValue else {
                return
            }
            self._model = value
            self.name.text = newValue?.name
            self.email.text = newValue?.email.emailEncrypted
            self.body.text = newValue?.body
        }
    }


    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(self.email)
        self.email.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(self.smallMargin)
            make.right.equalToSuperview().inset(self.margin)
            make.width.equalToSuperview().dividedBy(3)
            make.height.equalTo(30)
        }

        
        self.contentView.addSubview(self.name)
        self.name.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(self.smallMargin)
            make.left.equalToSuperview().inset(self.margin)
            make.height.equalTo(self.email)
            make.right.equalTo(self.email.snp.left).offset(-1 * self.smallMargin)
        }

        self.contentView.addSubview(self.body)
        self.body.snp.makeConstraints { (make) in
            make.top.equalTo(self.name.snp.bottom).offset(self.smallMargin/2)
            make.left.right.equalToSuperview().inset(self.margin)
            make.bottom.equalToSuperview().inset(self.smallMargin)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}

extension JTDetailCommentCell {
    static func height(_ model: JTCommentModel) -> CGFloat {
        var result: CGFloat = 10 * 2.5 + 30
        let size = CGSize(width: UIScreen.screenW-20*2, height: CGFloat(Int.max))
        result += model.body.height(with: size, font: .systemFont(ofSize: 15))
        return result
    }
}


private extension String {
    var emailEncrypted: String {
        get {
            guard self.contains("@") else {
                return self
            }
            
            let substr = self.split(separator: "@")
            
            guard let first = substr.first,
                  first.count > 2,
                  let last = substr.last,
                  last.count > 0 else {
                return self
            }
            
            let range = NSRange(location: 1, length: first.count - 2 )
                         
            return "\(first)".replace(range: range, place: "***") + "@" + "\(last)s"
        }
    }
}
