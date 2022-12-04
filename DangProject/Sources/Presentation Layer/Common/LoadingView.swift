import UIKit

final class LoadingView: UIActivityIndicatorView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLoadingView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLoadingView() {
        self.style = .large
        self.color = .darkGray
        self.stopAnimating()
        self.backgroundColor = .init(red: 0, green: 0, blue: 0, alpha: 0.3)
    }
    
    func showLoading() {
        DispatchQueue.main.async {
            self.startAnimating()
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            self.stopAnimating()
        }
    }
}

