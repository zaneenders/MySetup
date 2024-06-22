import ScribeSystem

public func setupGitConfig() {
    print("updating .gitconfig")
    // Needed for push and commit but not clone
    let gitConfig: String =
        """
        # .gitconfig
        [user]
                email = 39070793+zaneenders@users.noreply.github.com
                name = zane
        [init]
                defaultBranch = main
        [push]
            autoSetupRemote = true
        """

    let gitPath = "\(System.homePath)/.gitconfig"
    do {
        if FileSystem.fileExists(atPath: gitPath) {
            try FileSystem.removeItem(atPath: gitPath)
        }
        try FileSystem.write(string: gitConfig, to: gitPath)
    } catch {
        print(error.localizedDescription)
    }
}
