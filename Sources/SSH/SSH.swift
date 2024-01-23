import ScribeSystem

public enum SSH {
    public static func setup() {
        print("setup ssh")
        let sshConfigFileContents = """
            Host lab1-*.eng.utah.edu
                User u0687657

            Host github.com
                HostName github.com
                User git
                PreferredAuthentications publickey

            Host 192.168.0.98
                HostName 192.168.0.98
            """
        let configPath = "\(System.homePath)/.ssh/config"
        if FileSystem.fileExists(
            atPath: configPath,
            isDirectory: true)
        {
            do {
                try FileSystem.removeItem(atPath: configPath)
            } catch {
                print(error.localizedDescription)
                print("SSH SETUP ERROR")
            }
        }
        do {
            try FileSystem.write(string: sshConfigFileContents, to: configPath)
        } catch {
            print(error.localizedDescription)
            print("SSH write config ERROR")
        }

        // TODO set file permissions on linux
        // chmod 700 ~/.ssh
        // chmod 600 ~/.ssh/*
    }
}
