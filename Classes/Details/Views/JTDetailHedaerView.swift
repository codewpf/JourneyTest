//
//  JTDetailHedaerView.swift
//  JourneyTest
//
//  Created by Alex on 2/09/21.
//

import UIKit
import SnapKit
import WPFoundation

class JTDetailHedaerView: UIView, JTLayoutable {

    private let title: UILabel = UILabel().then {
        $0.textColor = .label
        $0.font = .boldSystemFont(ofSize: 20)
        $0.numberOfLines = 0
    }
    private let body: UILabel = UILabel().then {
        $0.textColor = .label
        $0.font = .systemFont(ofSize: 17)
        $0.numberOfLines = 0
    }
    
    let post: JTPostModel
    init(post: JTPostModel) {
        self.post = post
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        let insets = self.safeAreaInsets
        let size = CGSize(width: UIScreen.screenW-self.margin*2-insets.left-insets.right, height: CGFloat(Int.max))
        
        let titleHeight = self.post.title.height(with: size, font: self.title.font)
        self.title.snp.remakeConstraints {
            $0.top.equalToSuperview().inset(self.margin)
            $0.left.equalToSuperview().inset(self.margin+insets.left)
            $0.right.equalToSuperview().inset(self.margin+insets.right)
            $0.height.equalTo(titleHeight)
        }
        
        
        let bodyHeight = self.post.body.height(with: size, font: self.body.font)
        self.body.snp.remakeConstraints {
            $0.bottom.equalToSuperview().inset(self.margin)
            $0.left.right.equalToSuperview().inset(self.margin+insets.left)
            $0.left.right.equalToSuperview().inset(self.margin+insets.right)
            $0.height.equalTo(bodyHeight)
        }

    }
}

extension JTDetailHedaerView {
    func setupSubviews() {
        
        self.title.text = self.post.title
        self.addSubview(self.title)
        
        self.body.text = self.post.body
        self.addSubview(self.body)

    }
    
    func calculateFrame() -> CGRect {
        let size = CGSize(width: UIScreen.screenW-self.margin*2, height: CGFloat(Int.max))

        let height: CGFloat = post.title.height(with: size, font: self.title.font) + post.body.height(with: size, font: self.body.font) + self.margin * 2 + self.smallMargin
        let frame = CGRect(x: 0, y: 0, width: UIScreen.screenW, height: height)
        return frame
    }
}
