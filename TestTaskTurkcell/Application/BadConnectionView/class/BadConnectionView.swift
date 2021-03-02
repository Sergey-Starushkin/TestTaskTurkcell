//
//  BadConnectionView.swift
//  TestTaskTurkcell
//
//  Created by Sergey Starushkin on 27.02.21.
//

import UIKit

final class BadConnectionView: UIView {
    weak var delegate: BadConnectionViewDelegate?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }
}

// MARK: - Open

extension BadConnectionView{
    func show() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(observeReachabilityStatus),
                                               name: Notification.Name(ReachabilityStatusChangedNotification),
                                               object: nil)
        self.isHidden = false
    }
    
    func hide() {
        NotificationCenter.default.removeObserver(self,
                                                  name: Notification.Name(ReachabilityStatusChangedNotification),
                                                  object: nil)
        self.isHidden = true
    }
}

// MARK: - Configure
private extension BadConnectionView {
    private func setup() {
        if let view = loadViewFromNib() {
            view.frame = self.bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(view)
        }
    }

    private func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: Constants.Nibs.BadConnectionView, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        Reach().monitorReachabilityChanges()

        return view
    }

    @objc private func observeReachabilityStatus() {
        switch Reach().connectionStatus() {
        case .online(.wiFi), .online(.wwan):
            delegate?.updateView()
            
        default: break
        }
    }
}
