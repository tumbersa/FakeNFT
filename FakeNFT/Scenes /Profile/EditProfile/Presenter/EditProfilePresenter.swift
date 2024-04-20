//
//  EditProfilePresenter.swift
//  FakeNFT
//
//  Created by Dinara on 11.04.2024.
//

import Foundation
import ProgressHUD

protocol EditProfilePresenterProtocol {
    func viewDidLoad()
    func updateProfile(name: String?, description: String?, website: String?, newAvatarURL: String?)
}

protocol EditProfilePresenterDelegate: AnyObject {
    func profileDidUpdate(_ profile: Profile, newAvatarURL: String?)
}

final class EditProfilePresenter {
    private weak var view: EditProfileViewControllerProtocol?
    private let editProfileService: EditProfileService
    weak var delegate: EditProfilePresenterDelegate?

    init(view: EditProfileViewControllerProtocol,
         editProfileService: EditProfileService) {
        self.view = view
        self.editProfileService = editProfileService
    }
}

extension EditProfilePresenter: EditProfilePresenterProtocol {
    func viewDidLoad() {
        ProgressHUD.show()
        editProfileService.getProfile()
        ProgressHUD.dismiss()
    }

    func updateProfile(name: String?, description: String?, website: String?, newAvatarURL: String?) {
        view?.showLoading()

        let updatedProfile = EditProfileModel(
            name: name ?? "",
            description: description ?? "",
            avatar: newAvatarURL ?? "",
            website: website ?? "",
            likes: nil
        )
        editProfileService.updateProfile(with: updatedProfile) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let profile):
                    self?.delegate?.profileDidUpdate(profile, newAvatarURL: newAvatarURL)
                    self?.view?.profileUpdateSuccessful()
                    self?.view?.hideLoading()
                case .failure(let error):
                    self?.view?.displayError(error)
                    self?.view?.hideLoading()
                }
            }
        }
    }
}
