# My Dev Environment Files 🚀

**TERMINAL-SETUP:** Please follow the below guide to setup your terminal

- https://www.josean.com/posts/terminal-setup
  - you can skip making edits to the ~/.zshrc file as you will get that from stow
  - just make sure you brew install and curl install everything you need

**STOW:** Please follow the below guide for stow and linking your dot files

- brew install stow
- go to ~ directory
- git clone <DOTFILEREPO>
- execute:
  - stow --append .

**NEOVIM-SETUP**

iTerm2:

```bash
brew install --cask iterm2
```

Nerd font:

```bash
brew tap homebrew/cask-fonts
brew install font-meslo-lg-nerd-font
    - make sure you later set this in the iTerm2 terminal settings under profile/text/font
    - please also make sure to download jetbrains mono nerd font and set it as your regular font for iterm2
```

Neovim:

```bash
brew install neovim
```

Ripgrep:

```bash
brew install ripgrep
```

Node/Npm:

```bash
brew install node
```

For XCode Command Line Tools do:

```bash
xcode-select --install
```

GO:

```bash
brew install go
```
