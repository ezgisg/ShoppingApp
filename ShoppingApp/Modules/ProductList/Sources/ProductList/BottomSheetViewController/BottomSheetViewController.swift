//
//  BottomSheetViewController.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 7.08.2024.
//


//TODO: localizable

import AppResources
import Base
import UIKit

//MARK: - Enums
enum SortingOption:  Int, CaseIterable {
    case none = 0
    case highestPrice = 1
    case lowestPrice = 2

    //TODO: localizable
    var stringValue: String? {
         switch self {
         case .highestPrice:
             "Yüksekten Düşüğe Sırala"
         case .lowestPrice:
             "Düşükten Yükseğe Sırala"
         case .none:
             "Önerilen Sıralama"
         }
     }
}

//MARK: - BottomSheetViewController
class BottomSheetViewController: BaseViewController {

    //MARK: - Outlets
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var containerViewofContainerView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var tableViewTopSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    //MARK: - Variables
    var selectedOption: SortingOption
    var applySorting: ((SortingOption) -> Void)?
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        otherSetups()
    }
    

    override func viewDidLayoutSubviews() {
        updateTableViewHeight()
    }
    
    // MARK: - Module init
    public init(selectedOption: SortingOption) {
        self.selectedOption = selectedOption
        super.init(nibName: String(describing: Self.self), bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//MARK: - Actions
private extension BottomSheetViewController {
    @IBAction func tappedCancelButton(_ sender: Any) {
        dismissView()
    }
    
    @IBAction func tappedApplyButton(_ sender: Any) {
        guard let applySorting else { return }
        applySorting(selectedOption)
        dismissView()
    }
}

//MARK: - Helpers
private extension BottomSheetViewController {
    final func updateTableViewHeight() {
        DispatchQueue.main.async {  [weak self] in
            guard let self,
            let tableView else { return }
            tableView.clipsToBounds = true
            tableView.layoutIfNeeded()
            
            let contentHeight = tableView.contentSize.height
            let topPartHeight: CGFloat = 50
//            tableViewTopSpaceConstraint.constant
            let maxHeight: CGFloat = view.bounds.height * 0.7 - topPartHeight
            let newHeight = min(contentHeight, maxHeight)
            tableViewHeightConstraint.constant = newHeight
            if contentHeight < maxHeight {
                tableView.isScrollEnabled = false
            } else {
                tableView.isScrollEnabled = true
            }
       
        }
    }
    
    @objc final func dismissView() {
        dismiss(animated: true, completion: nil)
    }

}

//MARK: - Setup
private extension BottomSheetViewController {
    final func setupUI() {
        mainView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        containerView.backgroundColor = .clear
        
        containerViewofContainerView.backgroundColor = .white
        containerViewofContainerView.layer.cornerRadius = 24
        containerViewofContainerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        containerViewofContainerView.layer.shadowColor = UIColor.black.cgColor
        containerViewofContainerView.layer.shadowOpacity = 0.5
        containerViewofContainerView.layer.shadowOffset = CGSize(width: 0, height: -2)
        containerViewofContainerView.layer.shadowRadius = 20
        
        applyButton.setTitle("Uygula", for: .normal)
        cancelButton.setTitle("İptal", for: .normal)
        
        applyButton.setTitleColor(.tabbarBackgroundColor, for: .normal)
        cancelButton.setTitleColor(.tabbarBackgroundColor, for: .normal)
        
        mainView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissView)))
        
        tableView.separatorStyle = .none
    }
    
    final func otherSetups() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(nibWithCellClass: SelectionCell.self, at: Bundle.module)
        selectDefaultOption()
    }

    private func selectDefaultOption() {
        let indexPath = IndexPath(row: selectedOption.rawValue, section: 0)
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        tableView.delegate?.tableView?(tableView, didSelectRowAt: indexPath)
    }
}

extension BottomSheetViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let option = SortingOption(rawValue: indexPath.row) else { return }
        selectedOption = option
    }
}

//MARK: - UITableViewDataSource
extension BottomSheetViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SortingOption.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: SelectionCell.self, for: indexPath)
        if let option = SortingOption(rawValue: indexPath.row) {
            cell.configureWith(text: option.stringValue ?? "")
        }
        return cell
    }
    
}
