//
//  ProfilePresenter.swift
//  FakeNFT
//
//  Created by Dinara on 23.03.2024.
//

import Foundation

protocol ProfilePresenterDelegate: AnyObject {
    func navigateToMyNFTScreen(with nftID: [String], and likedNFT: [String])
    func navigateToFavoriteNFTScreen(with nftID: [String], and likedNFT: [String])
    func navigateToEditProfileScreen(name: String, avatar: String?, description: String, website: String)
}

protocol ProfilePresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    func viewWillAppear()
    func didTapMyNFT()
    func didTapFavoriteNFT()
    func didTapEditProfile()
}

// MARK: - ProfilePresenter Class
final class ProfilePresenter {
    weak var view: ProfileViewControllerProtocol?
    private let profileService = ProfileService.shared
    private let tokenKey = "6209b976-c7aa-4061-8574-573765a55e71"
    weak var delegate: ProfilePresenterDelegate?
}

extension ProfilePresenter: ProfilePresenterProtocol {
    func didTapEditProfile() {
        let name = profileService.profile?.name ?? ""
        let avatar = profileService.profile?.avatar ?? ""
        let description = profileService.profile?.description ?? ""
        let website = profileService.profile?.website ?? ""
        delegate?.navigateToEditProfileScreen(name: name, avatar: avatar, description: description, website: website)
    }

    func didTapFavoriteNFT() {
        let nftID = profileService.profile?.nfts ?? []
        let likedNFT = profileService.profile?.likes ?? []
        delegate?.navigateToFavoriteNFTScreen(with: nftID, and: likedNFT)
    }

    func didTapMyNFT() {
        let nftID = profileService.profile?.nfts ?? []
        let likedNFT = profileService.profile?.likes ?? []
        delegate?.navigateToMyNFTScreen(with: nftID, and: likedNFT)
    }

    func viewWillAppear() {
        guard let profile = profileService.profile else {
            profileService.fetchProfile(tokenKey) { [weak self] result in
                switch result {
                case .success(let profile):
                    self?.view?.updateProfileDetails(profile)
                case .failure(let error):
                    print("Failed to fetch profile: \(error)")
                }
            }

            return
        }
        view?.updateProfileDetails(profile)
    }
}
