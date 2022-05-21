import UIKit

public class LoadingView: UIActivityIndicatorView {
    
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

//    func hideLoading() {
//        DispatchQueue.main.async {
//            guard let window = UIApplication.shared.windows.last else { return }
//            window.subviews.filter({ $0 is UIActivityIndicatorView }).forEach { $0.removeFromSuperview() }
//        }
//    }
    
}

