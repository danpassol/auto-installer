# 🚀 Auto Installer for Debian Based distributions

This project provides a streamlined way to install and configure essential tools and services on a Linux system. It includes a modular installer framework with support for multiple services, such as Docker, and optional tools like Portainer.

---

## 📋 Table of Contents

- [Features](#features)
- [Prerequisites](#prerequisites)
- [Usage](#usage)
- [Project Structure](#project-structure)
- [Contributing](#contributing)
- [License](#license)

---

## ✨ Features

- **Interactive Menu**: Easily select and run installers from a menu.
- **Verbose Mode**: Option to enable detailed output for debugging.
- **Modular Design**: Add new installers by simply dropping scripts into the `.installers` directory.
- **Error Handling**: Robust error detection and logging.
- **Spinner Animation**: Visual feedback during long-running operations.

---

## ✅ Prerequisites

Before running the installer, ensure the following:

1. **Linux Distribution**: Ubuntu or Debian-based system.
2. **Root Privileges**: The script requires `sudo` access to install packages.
3. **Internet Connection**: Required for downloading dependencies.

---

## 🛠️ Usage

1. Clone the repository:
   ```bash
   git clone https://github.com/danpassol/auto-installer.git
   cd auto-installer
   chmod +x install.sh
   sudo ./install.sh
   ```
2. Follow the interactive menu to select the tools and services you want to install.
3. Optionally, enable verbose mode for detailed output by selecting the appropriate option in the menu.

## 📂 Project Structure

The repository is organized as follows:

```
auto-installer/
├── install.sh          # Main script to run the installer
├── .installers/        # Directory containing modular installer scripts
├── README.md           # Project documentation
├── LICENSE             # License file
└── utils/              # Utility scripts and helper functions
```

---

## 🤝 Contributing

Contributions are welcome! To contribute:

1. Fork the repository.
2. Create a new branch for your feature or bugfix.
3. Commit your changes with clear and concise messages.
4. Submit a pull request with a detailed description of your changes.

---

## 📜 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

made with ❤️ by Dani Pastor