//
//  StoryboardBased.swift
//  BankLocator
//
//  Created by Pritam on 31/10/20.
//

import UIKit

public protocol StoryboardBased: class {
    static var storyboard: UIStoryboard { get }
    static var sceneIdentifier: String { get }
}

public extension StoryboardBased {
  static var sceneIdentifier: String {
    return String(describing: self)
  }
}

public extension StoryboardBased where Self: UIViewController {
    static func instantiate() -> Self {
        let storyboard = Self.storyboard
        let viewController = storyboard.instantiateViewController(withIdentifier: self.sceneIdentifier)
    guard let typedViewController = viewController as? Self else {
      fatalError("The viewController '\(self.sceneIdentifier)' of '\(storyboard)' is not of class '\(self)'")
    }
    return typedViewController
  }
}
