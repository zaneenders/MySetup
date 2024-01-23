import Alacritty
import Git
import NeoVim
import SSH
import ScribeSystem

/*
there might be more but some effor into documenting the setup.

Goal is install swift, git clone, swift run install

TODO figure out .scribe setup
- I think I wanna change .scribe form a repo itself to something that gets setup for you
- so when setup runs it creats a .scribe folder and setups up everything else from there.

Just adding a few more thoughts on this. Maybe you clone or fork a .scribe package and we use swift as a sorta OS package manager
one language your editor your content
*/
print("Setting up .scribe")

// TODO setup build Script
let shellScript = """
    TODO setup ssh key
    TODO install Swift
    """
let releaseName = "swift-5.9.2-RELEASE-ubi9-aarch64"
let swiftBin =
    "https://download.swift.org/swift-5.9.2-release/ubi9-aarch64/swift-5.9.2-RELEASE/\(releaseName).tar.gz"
let swiftSig =
    "https://download.swift.org/swift-5.9.2-release/ubi9-aarch64/swift-5.9.2-RELEASE/\(releaseName).tar.gz.sig"

let gpgKey = """
    gpg --keyserver hkp://keyserver.ubuntu.com \
          --recv-keys \
          '7463 A81A 4B2E EA1B 551F  FBCF D441 C977 412B 37AD' \
          '1BE1 E29A 084C B305 F397  D62A 9F59 7F4D 21A5 6D5F' \
          'A3BA FD35 56A5 9079 C068  94BD 63BC 1CFE 91D3 06C6' \
          '5E4D F843 FB06 5D7F 7E24  FBA2 EF54 30F0 71E1 B235' \
          '8513 444E 2DA3 6B7C 1659  AF4D 7638 F1FB 2B2B 08C4' \
          'A62A E125 BBBF BB96 A6E0  42EC 925C C1CC ED3D 1561' \
          '8A74 9566 2C3C D4AE 18D9  5637 FAF6 989E 1BC1 6FEA' \
          'E813 C892 820A 6FA1 3755  B268 F167 DF1A CF9C E069'
    """

let verifyGpgKey = """
    gpg --verify \(releaseName).tar.gz.sig
    """

let extractCMD = """
    tar xzf \(releaseName).tar.gz
    """

// We can run swift now and git should be setup

// Update .zshrc file
let UpdateSwiftPath = """
    export PATH=/path/to/usr/bin:"${PATH}"
    """

setupGitConfig()

// TODO install allacrity
let alacrittyCMD = "sudo dnf install alacritty"

// TODO install fly.io for website
let flyInstallCMD = "curl -L https://fly.io/install.sh | sh"

let flyDotIOPathUpdate = """
    export FLYCTL_INSTALL="/home/zane/.fly"
    export PATH="$FLYCTL_INSTALL/bin:$PATH"
    """

let macZSHRCContents = """
    export ZSH="$HOME/.oh-my-zsh"

    ZSH_THEME="robbyrussell"

    # Swift Path
    # MacOS Takes care of this

    # Racket path
    export PATH=:/Users/zane/.scribe/.repositories/Racketv8.11.1/bin:"${PATH}"

    # NeoVim as defualt editor
    export EDITOR=/usr/bin/nvim

    # Fly.io Path
    export FLYCTL_INSTALL="/home/zane/.fly"
    export PATH="$FLYCTL_INSTALL/bin:$PATH"

    plugins=(git)
    source $ZSH/oh-my-zsh.sh
    """

let dotZSHRCcontents = """
    export ZSH="$HOME/.oh-my-zsh"

    ZSH_THEME="robbyrussell"

    # Swift Path
    # TODO where do I want to move this?
    export PATH=/home/zane/.scribe/.repositories/swift-5.9.2-RELEASE-ubi9-aarch64/usr/bin:"${PATH}"
    # Racket path
    export PATH=/home/zane/.scribe/.repositories/racket/racket/bin/:"${PATH}"

    # NeoVim as defualt editor
    export EDITOR=/usr/bin/nvim

    # Fly.io Path
    export FLYCTL_INSTALL="/home/zane/.fly"
    export PATH="$FLYCTL_INSTALL/bin:$PATH"

    plugins=(git)
    source $ZSH/oh-my-zsh.sh
    """

func setupZSHConfig() {
    print("Updateing .zshrc")
    let zshPath = "\(System.homePath)/.zshrc"
    do {
        if FileSystem.fileExists(atPath: zshPath) {
            try FileSystem.removeItem(atPath: zshPath)
        }
        switch System.os {
        case .macOS:
            try FileSystem.write(string: macZSHRCContents, to: zshPath)
        case .linux:
            try FileSystem.write(string: dotZSHRCcontents, to: zshPath)
        }
    } catch {
        print(error.localizedDescription)
    }
}

SSH.setup()
setupZSHConfig()

// TODO setup reset/override current setup and a flag to pass in
await setupAlacritty()
await setupNeoVim()
