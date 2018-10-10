//
//  TagsSectionView.swift
//  TheWing
//
//  Created by Luna An on 3/30/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Pilas

final class TagsSectionView: BuildableView {
    
    // MARK: - Public Properties
    
    /// Collection view delegate.
    weak var delegate: UICollectionViewDelegate? {
        didSet {
            collectionView.delegate = delegate
        }
    }
    
    /// Boolean that when set - sets property allowMultipleSelection of the collection view.
    var collectionViewMultiSelection: Bool = false {
        didSet {
            collectionView.allowsMultipleSelection = collectionViewMultiSelection
        }
    }
    
    /// Tags collection view.
    lazy var collectionView: TagsCollectionView = {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 100, height: 50)
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        let collectionView = TagsCollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        return collectionView
    }()
    
    // MARK: - Private Properties
    
    private let title: String

    private var topStackViewConstraint: NSLayoutConstraint?

    private var bottomStackViewConstraint: NSLayoutConstraint?

    private var tagDataSources = PillDataSources(tagNames: [], tagViewSources: []) {
        didSet {
            collectionView.isHidden = tagDataSources.tagNames.isEmpty
            collectionView.reloadData()
        }
    }
    
    private lazy var headerView = SectionHeaderView(theme: theme)

    private lazy var spacingView = UIView.dividerView(height: TagsSectionView.verticalGutter)

    private lazy var textView: UITextView = {
        let textView =  UITextView()
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = false
        textView.contentInset = UIEdgeInsets(top: 0, left: -5, bottom: 10, right: 0)
        textView.sizeToFit()
        return textView
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    // MARK: - Constants

    private static let verticalGutter: CGFloat = 18
    private static let topSpacing: CGFloat = 15

    // MARK: - Initialization

    /// Instantiates a tags section view.
    ///
    /// - Parameters:
    ///   - theme: The theme.
    ///   - title: Title of collection.
    init(theme: Theme, title: String) {
        self.title = title
        super.init(theme: theme)
        translatesAutoresizingMaskIntoConstraints = false
        setupDesign()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Functions

    /// Sets view with tags and corresponding data sources.
    ///
    /// - Parameters:
    ///   - tags: Tags.
    ///   - dataSources: Pill data source.
    ///   - descriptionText: Description text for empty state.
    ///   - activated: If the view is active or disabled.
    func setup(tags: [String]?, dataSources: [TagViewDataSource]?, descriptionText: String? = nil, activated: Bool = true) {
        let textColor = activated ? colorTheme.emphasisQuaternary : colorTheme.tertiary
        textView.setText(descriptionText ?? "", using: theme.textStyleTheme.bodyNormal.withColor(textColor))
        textView.isHidden = activated

        collectionView.isHidden = !activated
        spacingView.isHidden = !activated

        updateStackViewConstraints(activated: activated)

        tagDataSources = PillDataSources(tagNames: tags ?? [], tagViewSources: dataSources ?? [])
        headerView.set(title: title, activated: activated)
    }
    
}

// MARK: - Private Functions
private extension TagsSectionView {
    
    func setupDesign() {
        backgroundColor = theme.colorTheme.invertTertiary
        setupSubviews()
    }
    
    func setupSubviews() {
        addSubview(stackView)

        let bottomOffset = TagsSectionView.verticalGutter
        topStackViewConstraint = stackView.autoPinEdge(.top, to: .top, of: self, withOffset: TagsSectionView.topSpacing)
        bottomStackViewConstraint = stackView.autoPinEdge(.bottom, to: .bottom, of: self, withOffset: -bottomOffset)
        stackView.autoPinEdge(.leading, to: .leading, of: self, withOffset: ViewConstants.defaultGutter)
        stackView.autoPinEdge(.trailing, to: .trailing, of: self, withOffset: -ViewConstants.defaultGutter)

        stackView.addArrangedSubview(headerView)
        stackView.addArrangedSubview(textView)
        stackView.addArrangedSubview(spacingView)
        stackView.addArrangedSubview(collectionView)
        stackView.layoutIfNeeded()
    }

    func updateStackViewConstraints(activated: Bool) {
        topStackViewConstraint?.constant = activated ? TagsSectionView.topSpacing : 0
        bottomStackViewConstraint?.constant = activated ? -TagsSectionView.verticalGutter : -13
        layoutIfNeeded()
    }
    
}

// MARK: - UICollectionViewDataSource
extension TagsSectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TagCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        let index = indexPath.item
        cell.setup(theme: theme, tag: tagDataSources.tagNames[index], dataSource: tagDataSources.tagViewSources[index])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagDataSources.tagNames.count
    }
    
}
