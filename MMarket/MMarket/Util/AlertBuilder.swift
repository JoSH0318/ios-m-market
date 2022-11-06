//
//  AlertBuilder.swift
//  MMarket
//
//  Created by 조성훈 on 2022/11/06.
//

import UIKit

final class AlertBuilder {
    var title: String?
    var message: String?
    var type: UIAlertController.Style = .alert
    var actions: [UIAlertAction] = []

    static var shared = AlertBuilder()
    
    private init() { }
    
    func setTitle(_ title: String) -> AlertBuilder {
        self.title = title
        
        return self
    }
    
    func setMessage(_ message: String?) -> AlertBuilder {
        self.message = message
        
        return self
    }
    
    func setType(_ type: UIAlertController.Style) -> AlertBuilder {
        self.type = type
        
        return self
    }
    
    func setActions(_ actions: [UIAlertAction]?) -> AlertBuilder {
        guard let actions = actions else {
            return self
        }
        
        actions.forEach { self.actions.append($0) }
        
        return self
    }
    
    func apply() -> UIAlertController {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: type
        )
        
        actions.forEach { alert.addAction($0) }
        
        return alert
    }
}

