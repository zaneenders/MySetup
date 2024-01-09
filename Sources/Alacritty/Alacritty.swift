import ScribeSystem

public func setupAlacritty() async {
    // TODO Change font size based on OS. MacOS seems to be smallar font at 20
    print("hello from Alacritty setup")
    // TODO change to path of Package
    let commands = """
        ln -s /Users/zane/.scribe/Packages/MySetup/alacritty/* /Users/zane/.config/alacritty/
        """
    let linuxCommand = """
        ln -s /home/zane/.scribe/Packages/MySetup/alacritty/* /home/zane/.config/alacritty/
        """

    let alacrittyFolderPath = "\(System.configPath)/alacritty"

    print(alacrittyFolderPath)

    if !FileSystem.fileExists(atPath: alacrittyFolderPath) {
        print("Making file at \(alacrittyFolderPath)")
        let _ = try? FileSystem.createDirectory(at: alacrittyFolderPath)
        switch System.os {
        case .macOS:
            try? await System.shell(commands)
        case .linux:
            try? await System.shell(linuxCommand)
        }

    } else {
        print(
            "already setup delete \(alacrittyFolderPath) if you would like a fresh setup"
        )
    }
}
