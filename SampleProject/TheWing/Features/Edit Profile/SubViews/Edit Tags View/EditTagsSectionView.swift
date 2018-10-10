//
//  EditTagsSectionView.swift
//  TheWing
//
//  Created by Jonathan Samudio on 4/16/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class EditTagsSectionView: BuildableView {

    // MARK: - Public Properties

    weak var delegate: EditTagsSectionViewDelegate? {
        didSet {
            tagsSectionView.delegate = delegate
        }
    }
    
    var collectionView: UICollectionView {
        return tagsSectionView.collectionView
    }
    
    /// The text used to describe what type of tag you're adding.
    var addTagText: String? {
        didSet {
            let text = addTagText ?? ""
            addTagButton.set(text: text)
        }
    }

    // MARK: - Private Properties

    private let tagsSectionView: TagsSectionView

    private let type: ProfileTagType
    
    private lazy var addTagButton: PlusButton = {
        let button = PlusButton(theme: theme)
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Initialization

    init(theme: Theme, type: ProfileTagType) {
        self.type = type
        tagsSectionView = TagsSectionView(theme: theme, title: type.title)
        super.init(theme: theme)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Functions

    /// Sets up the tags section view.
    ///
    /// - Parameter tags: Tags to use.
    func setup(tags: [String]?) {
        tagsSectionView.setup(tags: tags, dataSources: Array(repeating: type, count: tags?.count ?? 0))
    }

}

// MARK: - Private Functions
private extension EditTagsSectionView {

    func setupView() {
        addSubview(tagsSectionView)
        tagsSectionView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)

        addSubview(addTagButton)
        addTagButton.autoPinEdge(.leading, to: .leading, of: self)
        addTagButton.autoPinEdge(.bottom, to: .bottom, of: self)
        addTagButton.autoPinEdge(.top, to: .bottom, of: tagsSectionView)
    }
    
    @objc func addButtonTapped() {
        delegate?.addNewTags(type: type)
    }

}
