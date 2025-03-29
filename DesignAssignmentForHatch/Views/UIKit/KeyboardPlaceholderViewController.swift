//
//  KeyboardPlaceholderViewController.swift
//  DesignAssignmentForHatch
//
//  Created by Bob Zhang on 2025-03-28.
//

import SwiftUI
import UIKit
import Combine


// UIKit 容器 ViewController
class KeyboardPlaceholderViewController<Content: View>: UIViewController {
    private let contentView: Content
    private var cancellableSet: Set<AnyCancellable> = []
    init(content: Content) {
        self.contentView = content
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red

        // 顶部 SwiftUI 容器部分
        let hostingController = UIHostingController(rootView: contentView)
        addChild(hostingController)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)

        // 底部自定义视图（占位）
        let bottomView = UIView()
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.backgroundColor = UIColor.systemGray5
        view.addSubview(bottomView)

        // 布局
        let bottomViewHeightConstraint = bottomView.heightAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            // bottomView 高度 80
            bottomViewHeightConstraint,
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            // hostingController 视图布局到顶部和 bottomView 上方
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
        ])
        
        
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .merge(with: NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification))
            .sink { notification in
                if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
//                    print("keyboardFrame: \(keyboardFrame)")
                    bottomViewHeightConstraint.constant = keyboardFrame.height
                }
            }
            .store(in: &cancellableSet)

        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .sink { _ in
//                print("keyboardwillHide")
                bottomViewHeightConstraint.constant = 0
            }
            .store(in: &cancellableSet)
    }
}

// SwiftUI 中使用的桥接器
struct KeyboardPlackhoderView<Content: View>: UIViewControllerRepresentable {
    
    init(@ViewBuilder content: () -> Content) {
           self.content = content()
    }
    let content: Content

    func makeUIViewController(context: Context) -> UIViewController {
        return KeyboardPlaceholderViewController(content: content)
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // 通常不需要更新
    }
}
