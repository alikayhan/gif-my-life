//
//  UserProfileViewController.swift
//  Gif My Life
//
//  Created by Ali Kayhan on 17/06/2017.
//  Copyright © 2017 Ali Kayhan. All rights reserved.
//

import UIKit
import FirebaseAuth
import AudioToolbox
import CoreData
import NVActivityIndicatorView

class UserProfileViewController: PortraitUIViewController {
    
    // MARK: - Properties
    var tableView: UITableView!
    var activityIndicator: NVActivityIndicatorView!
    var sections: [[String]]!
    var userIsAnonymous: Bool = UserManager().shared.user.isAnonymous
    var stack: CoreDataStack!
    var gifsShouldBeRefreshed: Bool = false
    
    // MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIConstants.Color.GMLLightPurple
        
        setupNavigationBar()
        addCancelButton()
        addTableView(on: view)
        
        activityIndicator = ActivityIndicator(on: view).indicator
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sections = tableViewSections()
        
        // Reload table view when user signs in or signs out
        if (userIsAnonymous != UserManager().shared.user.isAnonymous) {
            userIsAnonymous = UserManager().shared.user.isAnonymous
            tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Setup View Methods
    fileprivate func setupNavigationBar() {
        // Set the title to display on navigation bar
        navigationItem.title = UIConstants.Title.ViewController.UserProfile
        
        // Make navigation bar look transparent without being transparent indeed
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIConstants.Color.GMLLightPurple
        navigationController?.navigationBar.tintColor = .black
    }

    fileprivate func addCancelButton() {
        let backButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(self.cancelAction))
        navigationItem.setLeftBarButtonItems([backButton], animated: false)
    }

    fileprivate func addTableView(on view: UIView) {
        tableView = UITableView(frame: view.frame)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIConstants.Color.GMLLightPurple
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
    
    // MARK: - Selectors
    @objc fileprivate func cancelAction(_ sender: UIButton) {
        if gifsShouldBeRefreshed {
            let loadingViewController = LoadingViewController()
            self.present(loadingViewController, animated: true, completion: nil)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - UserProfileViewController (UITableViewDataSource)

extension UserProfileViewController: UITableViewDataSource {
    
    fileprivate func tableViewSections() -> [[String]] {
        if UserManager().shared.user.isAnonymous {
            return [[UIConstants.Label.TableViewRow.SignInWithEmail,
                                  UIConstants.Label.TableViewRow.SignInWithFacebook],
                                 [UIConstants.Label.TableViewRow.SignUpWithEmail,
                                  UIConstants.Label.TableViewRow.SignUpWithFacebook],
                                 [UIConstants.Label.TableViewRow.Liked,
                                  UIConstants.Label.TableViewRow.Saved],
                                 []]
        } else {
            return [[UIConstants.Label.TableViewRow.Username,
                     UIConstants.Label.TableViewRow.Email],
                                 [UIConstants.Label.TableViewRow.SignOut],
                                 [UIConstants.Label.TableViewRow.Liked,
                                  UIConstants.Label.TableViewRow.Saved],
                                 []]
        }
    }
    
    fileprivate func tableViewDetailLabelText() -> [String] {
        guard let username = UserManager().shared.username else {
            return [" ", UserManager().shared.user.email!]
        }
        
        return [username, UserManager().shared.user.email!]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            if UserManager().shared.user.isAnonymous {
                return UIConstants.Title.TableViewHeader.SignIn
            } else {
                return UIConstants.Title.TableViewHeader.SignedIn
            }
        case 1:
            if UserManager().shared.user.isAnonymous {
                return UIConstants.Title.TableViewHeader.SignUp
            } else {
                return UIConstants.Title.TableViewHeader.SignOut
            }
        case 2:
            return UIConstants.Title.TableViewHeader.SavedLiked
        case 3:
            return UIConstants.Title.TableViewHeader.Categories
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 3:
            return CategoriesManager().shared.categoriesArray.count
        default:
            return sections[section].count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UIConstants.Size.TableView.HeaderHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath as IndexPath)
        
        switch indexPath.section {
        case 0:
            cell.backgroundColor = UIConstants.Color.GMLLightPurple
            cell.textLabel!.text = "\(sections[indexPath.section][indexPath.row])"
            if !(UserManager().shared.user.isAnonymous) {
                let detailLabelTextArray = tableViewDetailLabelText()
                cell = UITableViewCell(style: .value1, reuseIdentifier: "TableViewCell")
                cell.backgroundColor = UIConstants.Color.GMLLightPurple
                cell.textLabel!.text = "\(sections[indexPath.section][indexPath.row])"
                cell.detailTextLabel?.text = detailLabelTextArray[indexPath.row]
                cell.accessoryView = UIView()
            }
            cell.accessoryView = UIView()
        case 1:
            cell = UITableViewCell(style: .default, reuseIdentifier: "TableViewCell")
            cell.backgroundColor = UIConstants.Color.GMLLightPurple
            cell.textLabel!.text = "\(sections[indexPath.section][indexPath.row])"
            cell.accessoryView = UIView()
        case 2:
            cell = UITableViewCell(style: .default, reuseIdentifier: "TableViewCell")
            cell.backgroundColor = UIConstants.Color.GMLLightPurple
            cell.tintColor = .white
            cell.textLabel!.text = "\(sections[indexPath.section][indexPath.row])"
            
            // Since cell accessory type disclosure indicator is not tintable, create
            // a view and assign it to cell's accessory view
            let disclosureView = UIImageView(image: UIImage(named: "DisclosureIndicator"))
            disclosureView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            disclosureView.contentMode = .scaleAspectFit
            disclosureView.tintColor = UIConstants.Color.GMLPink
            cell.accessoryView = disclosureView            
        case 3:
            cell = UITableViewCell(style: .default, reuseIdentifier: "TableViewCell")
            cell.backgroundColor = .white
            cell.textLabel?.text = CategoriesManager().shared.categoriesArray[indexPath.row].displayText
            
            let cellSwitch = UISwitch(frame: .zero)
            cellSwitch.isOn = false
            cellSwitch.tag = indexPath.row
            cellSwitch.onTintColor = UIConstants.Color.GMLPink
            cell.accessoryView = cellSwitch
            
            guard let selectedCategories = UserManager().shared.userData[FirebaseClient.DatabaseKeys.SelectedCategories] as? [String: Any] else {
                break
            }
            
            if selectedCategories[CategoriesManager().shared.categoriesArray[indexPath.row].id] != nil {
                cellSwitch.isOn = true
                cellSwitch.addTarget(self, action: #selector(deselectCategory), for: .valueChanged )
            } else {
                cellSwitch.addTarget(self, action: #selector(selectCategory), for: .valueChanged )
            }
        default:
            break
        }

        return cell
    }
}

// MARK: - UserProfileViewController (UITableViewDelegate)

extension UserProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                if UserManager().shared.user.isAnonymous {
                    let signInViewController = SignInUpViewController(for: UIConstants.Title.SignInUp.SignIn)
                    navigationController?.pushViewController(signInViewController, animated: true)
                } else {
                    break
                }
            case 1:
                if UserManager().shared.user.isAnonymous {
                    setUIEnabled(false)
                    
                    let readPermissions = [FacebookClient.PermissionKeys.PublicProfile, FacebookClient.PermissionKeys.Email]
                    
                    FirebaseClient().shared.signInWithFacebook(with: readPermissions, from: self, andHandleCompletionWith: { (user, error) in
                        guard let user = user else {
                            if let error = error {
                                print(error)
                            }
                            self.setUIEnabled(true)
                            return
                        }
                        
                        self.fillUserDataWithFacebookProfile(of: user)
                        self.navigationController?.dismiss(animated: true, completion: nil)
                    })
                } else {
                    break
                }
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0:
                if UserManager().shared.user.isAnonymous {
                    let signUpViewController = SignInUpViewController(for: UIConstants.Title.SignInUp.SignUp)
                    navigationController?.pushViewController(signUpViewController, animated: true)
                } else {
                    setUIEnabled(false)
                    
                    FirebaseClient().shared.signOut() { (error) in
                        if let error = error {
                            print(error)
                            DispatchQueue.main.async {
                                self.showAlert(with: UIConstants.Error.SignOutFailed)
                                self.setUIEnabled(true)
                            }
                        } else {
                            // When a user signs out, a new user has been signed in anonymously automagically
                            // so that the app will always have a user either signed in or anonymous
                            UserManager().shared.username = nil
                            DispatchQueue.main.async {
                                self.setUIEnabled(true)
                                self.navigationController?.dismiss(animated: true, completion: nil)
                            }
                        }
                    }
                }
            case 1:
                if UserManager().shared.user.isAnonymous {
                    setUIEnabled(false)
                    
                    let readPermissions = [FacebookClient.PermissionKeys.PublicProfile, FacebookClient.PermissionKeys.Email]
                    
                    FirebaseClient().shared.signUpWithFacebook(with: readPermissions, from: self, andHandleCompletionWith: { (user, error) in
                        guard let user = user else {
                            if let error = error {
                                print(error)
                                self.showAlert(with: UIConstants.Error.FacebookSignUpFailed, message: UIConstants.Error.TryFacebookSignIn)
                            }
                            self.setUIEnabled(true)
                            return
                        }
                        
                        self.fillUserDataWithFacebookProfile(of: user)
                        self.navigationController?.dismiss(animated: true, completion: nil)
                    })
                } else {
                    break
                }
            default:
                break
            }
        case 2:
            switch indexPath.row {
            case 0:
                let likedGifsViewController = LikedGifsViewController()
                navigationController?.pushViewController(likedGifsViewController, animated: true)
            case 1:
                let savedGifsViewController = SavedGifsViewController()
                let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "DownloadedGif")
                fr.sortDescriptors = [NSSortDescriptor(key: "downloadedAt", ascending: true)]
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                stack = appDelegate.stack
                
                let fc = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
                
                savedGifsViewController.fetchedResultsController = fc
                navigationController?.pushViewController(savedGifsViewController, animated: true)
            default:
                break
            }
        case 3:
            break
        default:
            break
        }
    }
    
    // MARK: - Helper Methods
    fileprivate func fillUserDataWithFacebookProfile(of user: User) {
        UserManager().shared.user = user
        
        let parameters = [FacebookClient.GraphRequestParametersKeys.Fields: "\(FacebookClient.GraphRequestParameterValues.ID), \(FacebookClient.GraphRequestParameterValues.Email), \(FacebookClient.GraphRequestParameterValues.Name), \(FacebookClient.GraphRequestParameterValues.PictureTypeLarge), \(FacebookClient.GraphRequestParameterValues.Gender)"]
        
        // For some Facebook users, it is not possible to retrieve e-mail address information.
        // Considering this, if a user does not have an e-mail, user.email is updated as facebookID@facebook.com
        if user.email != nil {
            FacebookClient().shared.obtainProfileInformation(with: parameters, graphPath: FacebookClient.GraphRequestValues.GraphPath.Me, version: nil, HTTPMethod: FacebookClient.GraphRequestValues.HTTPMethod.Get, andHandleCompletionWith: { (profileData, error) in
                if let facebookProfileData = profileData {
                    UserManager().shared.facebookProfileData = facebookProfileData
                    if let facebookID = facebookProfileData[FacebookClient.GraphRequestResultKeys.ID] as? String {
                        UserManager().shared.username = facebookID
                    }
                    UserManager().shared.obtainUserData()
                    
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = facebookProfileData[FacebookClient.GraphRequestResultKeys.Name] as? String
                    
                    guard let picture = facebookProfileData[FacebookClient.GraphRequestResultKeys.Picture] as? [String: Any] else {
                        return
                    }
                    
                    guard let pictureData = picture[FacebookClient.GraphRequestResultKeys.Data] as? [String: Any] else {
                        return
                    }
                    
                    guard let pictureDataURL = pictureData[FacebookClient.GraphRequestResultKeys.URL] as? String else {
                        return
                    }
                    
                    changeRequest.photoURL = URL(string: pictureDataURL)
                    
                    FirebaseClient().shared.changeUserProfile(by: changeRequest, andHandleCompletionWith: { (error) in
                        if let error = error {
                            print(error)
                        }
                    })
                } else {
                    UserManager().shared.obtainUserData()
                }
            })
            self.completeSignInSignUp()
        } else {
            FacebookClient().shared.obtainProfileInformation(with: parameters, graphPath: FacebookClient.GraphRequestValues.GraphPath.Me, version: nil, HTTPMethod: FacebookClient.GraphRequestValues.HTTPMethod.Get, andHandleCompletionWith: { (profileData, error) in
                
                if let facebookProfileData = profileData {
                    UserManager().shared.facebookProfileData = facebookProfileData as! [String: [String: Any]]
                    
                    guard let facebookID = facebookProfileData[FacebookClient.GraphRequestResultKeys.ID] else {
                        self.showAlert(with: UIConstants.Error.SignInSignUpFailed)
                        self.setUIEnabled(true)
                        return
                    }
                    
                    let userEmail = "\(facebookID)@facebook.com"
                    
                    FirebaseClient().shared.updateEmail(to: userEmail, andHandleCompletionWith: { (error) in
                        if error != nil {
                            self.showAlert(with: UIConstants.Error.SignInSignUpFailed)
                            self.setUIEnabled(true)
                        } else {
                            FirebaseClient().shared.checkUserLoginStatus(andHandleCompletionWith: { (user) in
                                if let user = user {
                                    UserManager().shared.user = user
                                    UserManager().shared.username = facebookID as! String
                                    UserManager().shared.obtainUserData()
                                    
                                    let changeRequest = user.createProfileChangeRequest()
                                    changeRequest.displayName = facebookProfileData[FacebookClient.GraphRequestResultKeys.Name] as? String
                                    guard let picture = facebookProfileData[FacebookClient.GraphRequestResultKeys.Picture] as? [String: Any] else {
                                        return
                                    }
                                    
                                    guard let pictureData = picture[FacebookClient.GraphRequestResultKeys.Data] as? [String: Any] else {
                                        return
                                    }
                                    
                                    guard let pictureDataURL = pictureData[FacebookClient.GraphRequestResultKeys.URL] as? String else {
                                        return
                                    }
                                    
                                    changeRequest.photoURL = URL(string: pictureDataURL)
                                    
                                    FirebaseClient().shared.changeUserProfile(by: changeRequest, andHandleCompletionWith: { (error) in
                                        if let error = error {
                                            print (error)
                                        }
                                    })
                                    self.completeSignInSignUp()
                                } else {
                                    self.showAlert(with: UIConstants.Error.SignInSignUpFailed)
                                    self.setUIEnabled(true)
                                }
                            })
                        }
                    })
                } else {
                    self.showAlert(with: UIConstants.Error.SignInSignUpFailed)
                    self.setUIEnabled(true)
                }
            })
        }
    }

    fileprivate func completeSignInSignUp() {
        if UserManager().shared.user.email != nil {
            tableView.reloadData()
        } else {
            showAlert(with: UIConstants.Error.SignInSignUpFailed)
        }
        setUIEnabled(true)
    }

    fileprivate func setUIEnabled(_ enabled: Bool) {
        DispatchQueue.main.async {
            self.tableView.isUserInteractionEnabled = enabled
            if enabled {
                self.activityIndicator.stopAnimating()
            } else {
                self.activityIndicator.startAnimating()
            }
        }
    }
    
    // MARK: - Selectors
    @objc fileprivate func deselectCategory(_ sender: UISwitch) {
        guard var selectedCategories = UserManager().shared.userData[FirebaseClient.DatabaseKeys.SelectedCategories] as? [String: Any] else {
            return
        }
        
        // User should have at least one category selected
        if selectedCategories.count == 1 {
            sender.isOn = true
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        } else {
            let selectedCategory: Category = CategoriesManager().shared.categoriesArray[sender.tag]
            sender.removeTarget(self, action: #selector(deselectCategory), for: .valueChanged)
            sender.addTarget(self, action: #selector(selectCategory), for: .valueChanged)
            
            let childValues = ["\(FirebaseClient.DatabaseKeys.UserSelectedCategories)/\(UserManager().shared.user.uid)/\(FirebaseClient.DatabaseKeys.SelectedCategories)/\(selectedCategory.id!)": [:],
                               "\(FirebaseClient.DatabaseKeys.Users)/\(UserManager().shared.user.uid)/\(FirebaseClient.DatabaseKeys.SelectedCategories)/\(selectedCategory.id!)": [:]]
            
            
            selectedCategories.removeValue(forKey: selectedCategory.id)
            UserManager().shared.userData[FirebaseClient.DatabaseKeys.SelectedCategories] = selectedCategories
            
            FirebaseClient().shared.update(childValuesWith: childValues)
            
        }
    }

    // For now, app allows only one category to be selected. Therefore,
    // once a category is selected, all others get deselected automatically.
    @objc fileprivate func selectCategory(_ sender: UISwitch) {
        
        let selectedCategory: Category = CategoriesManager().shared.categoriesArray[sender.tag]
        sender.removeTarget(self, action: #selector(selectCategory), for: .valueChanged)
        sender.addTarget(self, action: #selector(deselectCategory), for: .valueChanged)

        let childValues: [String: Any] = ["\(FirebaseClient.DatabaseKeys.UserSelectedCategories)/\(UserManager().shared.user.uid)/\(FirebaseClient.DatabaseKeys.SelectedCategories)": ["\(selectedCategory.id!)": selectedCategory.dataPack],
                                          "\(FirebaseClient.DatabaseKeys.Users)/\(UserManager().shared.user.uid)/\(FirebaseClient.DatabaseKeys.SelectedCategories)": ["\(selectedCategory.id!)" : ["\(FirebaseClient.DatabaseKeys.SelectedAt)": FirebaseClient().shared.serverTimestamp]]]
        
        guard var selectedCategories = UserManager().shared.userData[FirebaseClient.DatabaseKeys.SelectedCategories] as? [String: Any] else {
            return
        }
        
        selectedCategories.removeAll()
        selectedCategories[selectedCategory.id] = [FirebaseClient.DatabaseKeys.SelectedAt: FirebaseClient().shared.serverTimestamp]
        UserManager().shared.userData[FirebaseClient.DatabaseKeys.SelectedCategories] = selectedCategories
        
        // Gifs should be refreshed if selected category has changed
        gifsShouldBeRefreshed = true
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        FirebaseClient().shared.update(childValuesWith: childValues)
    }
}
