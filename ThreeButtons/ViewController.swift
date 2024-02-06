import UIKit

final class ViewController: UIViewController {
    private let button1 = ScaledButton(title: "First Button")
    private let button2 = ScaledButton(title: "Second Medium Button")
    private let button3 = ScaledButton(title: "Third")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        [button1, button2, button3].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        button3.addAction(UIAction { [weak self] _ in self?.route() }, for: .touchUpInside)

        NSLayoutConstraint.activate([
            button1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button3.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            button1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            button2.topAnchor.constraint(equalTo: button1.bottomAnchor, constant: 20),
            button3.topAnchor.constraint(equalTo: button2.bottomAnchor, constant: 20)
        ])
    }

    private func route() {
        let controller = UIViewController()
        controller.view.backgroundColor = .white
        controller.modalPresentationStyle = .pageSheet
        present(controller, animated: true)
    }
}
