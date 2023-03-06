import UIKit

public extension UITableView {
    
    // MARK: - UITableViewCell
    
    final func registerReusableCell<T: UITableViewCell>(cellType: T.Type) where T: Reusable {
        register(cellType.self, forCellReuseIdentifier: cellType.reuseIdentifier)
    }
    
    final func dequeueReusableCell<T: UITableViewCell>(_ indexPath: IndexPath, cellType: T.Type = T.self) -> T
        where T: Reusable {
            guard let cell = dequeueReusableCell(withIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
                fatalError(
                    """
                    Failed to dequeue a cell with identifier \(cellType.reuseIdentifier) matching type \(cellType.self).
                    """
                )
            }
            
            return cell
    }
    
    // MARK: - UITableViewHeaderFooterView
    
    final func registerReusableHeaderFooterView<T: UITableViewHeaderFooterView>(viewType: T.Type) where T: Reusable {
        register(viewType.self, forHeaderFooterViewReuseIdentifier: viewType.reuseIdentifier)
    }
    
    final func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(
        _ section: Int,
        viewType: T.Type = T.self) -> T? where T: Reusable {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: viewType.reuseIdentifier) as? T? else {
            fatalError(
                """
                Failed to dequeue a header/footer with identifier \(viewType.reuseIdentifier) matching type \(viewType.self).
                """
            )
        }
        
        return view
    }
    
}
