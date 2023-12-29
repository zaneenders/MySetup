import ScribeSystem

public func setupNeoVim() async {

    /**
Welcome
*/
    print("hello from nvim setup")
    /**
# NeoVim
TODO fix bindings for spell checker, and maybe UI
TODO add symlink for config and .config location

this might need to be a two phase process?
TODO test this

TODO Install Language Servers with Mason
- lua
- html
- css
- stylua (might not need this one)


Maybe I can use this?
https://github.com/nvim-telescope/telescope-file-browser.nvim/blob/8e0543365fe5781c9babea7db89ef06bcff3716d/doc/telescope-file-browser.txt#L342C1-L342C39

Maybe I don't need ZSH?
*/

    let commands = """
        ln -s /Users/zane/.scribe/Packages/MySetup/nvim/* /Users/zane/.config/nvim/
        """
    let linuxCommand = """
        ln -s /home/zane/.scribe/Packages/MySetup/nvim/* /home/zane/.config/nvim/
        """
    let nvimFolderPath = "\(System.configPath)/nvim"

    print(nvimFolderPath)

    if !FileSystem.fileExists(atPath: nvimFolderPath) {
        print("Making file at \(nvimFolderPath)")
        let _ = try? FileSystem.createDirectory(at: nvimFolderPath)
        switch System.os {
        case .macOS:
            try? await System.shell(commands)
        case .linux:
            try? await System.shell(linuxCommand)
        }
    } else {
        print(
            "already setup delete \(nvimFolderPath) if you would like a fresh setup"
        )
    }
}
