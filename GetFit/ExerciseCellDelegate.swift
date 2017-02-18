import UIKit

@objc protocol ExerciseCellDelegate {
  @objc optional func didTapOnWeightButton(_ cell: UITableViewCell)
  @objc optional func didTapOnRepetitionsButton(_ cell: UITableViewCell)
}
