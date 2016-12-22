# Puff

Password Utility Free Forever

## Features

* Open Source
* **Blowfish Encryption**
* **Totally Offline** - we don't even require an internet access permission
* Quick access your credentials
* Cross Platform - Working in Progress


## Screenshots


## How does it works ?

### Design Guideline

Like other password manager, Puff also use a master password for encryption & decryption. All your credentials are encrypted with it using `Blowfish Encryption`.

Puff's most important design guideline is we **DO NOT** upload your database to anywhere. Not to a cloud or self-hosted server. We **DO NOT** require internet permission in this app. All your credentials are in your local storage safely.

Second guideline is, we try to avoid store your master password. In iOS version, we stored your master password in `KeyChain`, which is safe enough for most people if you don't jail break your phone. The reason why we storing your master password is to provide a more convinience experience by combining `Touch-ID` and `KeyChain`.

### Quick Access Tools

Puff provide two ways for quick access your account credentials.

* **Pin**

    Pin means pin your account information in `Today Widget`. As you can see in the screenshot, for each credential there is a button in the widget. Click that button the credential will be copied to your clipboard automatically. And the information can be automatically cleared to avoid un-intented access.

* Action Extension

    Action extension is for `Safari`, which you can access your account information in Safari browser quickly. Click the share button in the bottom of Safari then tap on Puff icon. A dialog will pop up and you can copy & pin your account information. You may need to enable Puff action extension by clicking the `more` button in Safari.


## Roadmap

- [ ] UI tweaks and tutorial page.
- [ ] Support export database.
- [ ] Support import database.
- [ ] Ship iOS app on App Store.
- [ ] Develop desktop version.

## Credits

Icons in this app are brought you by [Icons8.com](https://icons8.com)

[MMDrawerController](https://github.com/mutualmobile/MMDrawerController)

[BFPaperCheckbox](https://github.com/bfeher/BFPaperCheckbox)

[Masonry](https://github.com/SnapKit/Masonry)

[Material-Controls-For-iOS](https://github.com/fpt-software/Material-Controls-For-iOS) - **Forked & Modified**  some codes. And the modified version can be found [** here **](https://github.com/PuffOpenSource/Material-Controls-For-iOS)
