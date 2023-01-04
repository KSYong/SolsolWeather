//
//  MailView.swift
//  WeatherApp_SwiftUI_Refactoring
//
//  Created by 권승용 on 2023/01/04.
//

import SwiftUI
import MessageUI

struct MailView: UIViewControllerRepresentable {
        
    var body: String
    var to: String
    var subject: String
    
    typealias UIViewControllerType = MFMailComposeViewController
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        if MFMailComposeViewController.canSendMail() {
            let view = MFMailComposeViewController()
            view.mailComposeDelegate = context.coordinator
            view.setToRecipients([to])
            view.setSubject(subject)
            view.setMessageBody(body, isHTML: false)
            return view
        } else {
            return MFMailComposeViewController()
        }
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    // SwiftUI 내부에서 UIKit의 Delegate 패턴을 사용하기 위한 Coordinator
    class Coordinator : NSObject, MFMailComposeViewControllerDelegate {
        
        var parent: MailView
        
        init(_ parent: MailView) {
            self.parent = parent
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true)
        }
        
    }
    
}
