//
//  PayNftViewController.swift
//  FakeNFT
//
//  Created by Марат Хасанов on 23.03.2024.
//

import UIKit
import WebKit
import SafariServices

protocol PayNftView: AnyObject {
    func showSafariView() -> SFSafariViewController
    func loadImage(from imageUrl: URL, completion: @escaping (UIImage?) -> Void)
}

final class PayNftViewController: UIViewController {
    
    var paymentID: String = "" {
        didSet {
            payButton.alpha = 1
            payButton.isEnabled = true
        }
    }
    
    let servicesAssembly: ServicesAssembly
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private var presenter: PayNftPresenter?
    
    private let cartService: CartService = CartServiceImpl(networkClient: DefaultNetworkClient())
    private let nftService: NftService = NftServiceImpl(networkClient: DefaultNetworkClient(), storage: NftStorageImpl())
    
    private var currencies: [Currency] = [] {
        didSet {
            selectedCollection.reloadData()
        }
    }
    
    var back = false
    
    private lazy var selectedCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.register(CryptoWalletCell.self, forCellWithReuseIdentifier: "CryptoCell")
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()

    //Отделение с кнопкой оплаты
    private lazy var bottomView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(named: "ypLightGray")
        view.layer.masksToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 12
        view.heightAnchor.constraint(equalToConstant: 186).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var infoLabel: UILabel = {
       let label = UILabel()
        label.text = "Совершая покупку, вы соглашаетесь с условиями"
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var webInfo: WKWebView?
    
    private lazy var infoWebButton: UIButton = {
       let button = UIButton()
        button.setTitle("Пользовательского соглашения", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .regular)
        button.setTitleColor(UIColor(named: "ypUniBlue"), for: .normal)
        button.contentHorizontalAlignment = .left
        button.heightAnchor.constraint(equalToConstant: 26).isActive = true
        button.widthAnchor.constraint(equalToConstant: 202).isActive = true
        button.addTarget(self, action: #selector(showUserInfo), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var payButton: UIButton = {
        let button = UIButton()
        button.setTitle("Оплатить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(payButtonClicked), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
       return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        presenter = PayNftPresenter()
        getCurrencyList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if back {
            dismissModal()
        }
    }
    
    private func configureVC() {
        view.backgroundColor = .white
        title = "Выберите способ оплаты"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let backButtonImage = UIImage(systemName: "chevron.left")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(dismissModal))
        setupViews()
    }
    
    @objc func payButtonClicked() {
        paymentConfirmationRequest(for: self.paymentID)
    }
    
    private func getCurrencyList() {
        servicesAssembly.nftService.loadCurrencyList { (result: Result<[Currency], Error>) in
            switch result {
            case .success(let currencies):
                self.currencies = currencies
                print(currencies)
            case .failure:
                print("ERROR")
            }
        }
    }
    
    private func paymentConfirmationRequest(for id: String) {
        servicesAssembly.nftService.paymentConfirmationRequest(currencyId: id) {(result: Result<PaymentConfirmation, Error>) in
            switch result {
            case .success:
                let vc = CongratulationViewController()
                self.back = true
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
                self.selectedCollection.reloadData()
            case .failure:
                self.showErrorBuyAlert()
            }
        }
    }
    
    //MARK: -добавить функцию повтора
    private func showErrorBuyAlert() {
        let alert = UIAlertController(title: "Не удалось произвести оплату", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        let returnAction = UIAlertAction(title: "Повторить", style: .default) {_ in 
            print("повторить - повторить")
        }
        alert.addAction(cancelAction)
        alert.addAction(returnAction)
        present(alert, animated: true, completion: nil)
    }

    
    @objc func dismissModal() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func showUserInfo() {
        guard let vc = presenter?.showSafariView() else { return }
        present(vc, animated: true)
    }
    
    private func setupViews() {
        view.addSubview(bottomView)
        view.addSubview(selectedCollection)
        [infoLabel, infoWebButton, payButton].forEach {
            bottomView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            selectedCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            selectedCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            selectedCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            selectedCollection.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
            selectedCollection.heightAnchor.constraint(equalToConstant: 200),
            
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            infoLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16),
            infoLabel.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -16),
            infoLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 16),
            
            infoWebButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16),
            infoWebButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -16),
            infoWebButton.topAnchor.constraint(equalTo: infoLabel.bottomAnchor),
        
            payButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            payButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            payButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12)])
    }
}

extension PayNftViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        currencies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CryptoCell", for: indexPath) as? CryptoWalletCell else {
            return UICollectionViewCell()
        }
        let currency = currencies[indexPath.item]
        cell.setupUiElements(currency: currency)
        
        //Картинка
        let imagesURL = currency.image
        // Используем кэш для установки изображения
        if let presenter = presenter {
            if let cachedImage = presenter.imageCache.object(forKey: imagesURL.absoluteString as NSString) {
                cell.cryptoImage.image = cachedImage
            } else {
                cell.cryptoImage.image = UIImage(named: "placeholder")
                loadImage(imageUrl: imagesURL, indexPath: indexPath)
            }
        }
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 12
        return cell
    }
    
    private func loadImage(imageUrl: URL, indexPath: IndexPath) {
        presenter?.loadImage(from: imageUrl) { [weak self] image in
            DispatchQueue.main.async {
                guard let self = self, let image = image, let cell = self.selectedCollection.cellForItem(at: indexPath) as? CryptoWalletCell
                else {
                    return
                }
                cell.cryptoImage.image = image
                // Сохраняем загруженное изображение в кэше
                self.presenter?.imageCache.setObject(image, forKey: imageUrl.absoluteString as NSString)
            }
        }
    }
}

extension PayNftViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth: CGFloat = 168
        let cellHeight: CGFloat = 46

        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        //отступы от краев секции
        return UIEdgeInsets(top: 20, left: 0, bottom: 7, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? CryptoWalletCell
        paymentID = currencies[indexPath.item].id
        cell?.layer.borderWidth = 1
        cell?.layer.cornerRadius = 12
        cell?.layer.borderColor = UIColor.black.cgColor
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CryptoWalletCell {
            cell.layer.borderWidth = 0 // Сбрасываем толщину рамки
        }
    }
}
