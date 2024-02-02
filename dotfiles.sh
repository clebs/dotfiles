# Find repo directory so script works from anywhere
REPO=$(dirname $0)

function dotfiles {
  case $1 in
    apply) # Apply the config files on the repository to this machine
      echo "Overwrite your local dotfiles? [y/n]"
      read -r REPLY
      echo    # (optional) move to a new line

      if [[ $REPLY =~ ^[Yy].* ]]
      then
      echo "Applying configuration..."
        #git
        cp $REPO/git/.gitconfig ~/

        # homebrew
        cd $REPO/homebrew
        brew bundle
        cd -

        # tmux
        mkdir -p ~/.config/tmux/
        cp $REPO/tmux/tmux.conf ~/.config/tmux/
        
        #vim
        cp $REPO/vim/.vimrc ~/
        mkdir -p ~/.config/nvim/
        cp -r $REPO/vim/nvim/* ~/.config/nvim/

        # kitty
        mkdir -p ~/.config/kitty/
        cp -r $REPO/kitty/* ~/.config/kitty/
        
        # ghostty
        mkdir -p ~/.config/ghostty/
        cp -r $REPO/ghostty/* ~/.config/ghostty/
        
        #zsh
        cp $REPO/zsh/.zshrc ~/
        cp $REPO/zsh/.zprofile ~/
        cp $REPO/zsh/themes/*.zsh-theme ~/.oh-my-zsh/themes/

        # fish
        mkdir -p ~/.config/fish/
        cp -r $REPO/fish/* ~/.config/fish/


        #vscode
        # Settings
        cp $REPO/vscode/*.json ~/Library/Application\ Support/Code/User/
        cp $REPO/vscode/snippets/*.json ~/Library/Application\ Support/Code/User/snippets/
        # Extensions
        cat $REPO/vscode/extensions.txt | xargs -n 1 code --install-extension

        #rust
        cp $REPO/rust/.rustfmt.toml ~/
        
        echo "Done!"
      fi

      return 0
      ;;
    backup) # Commit config on this machine into the repository
      echo "Backup your local dotfiles? [y/n]"
      read -r REPLY
      echo    # (optional) move to a new line

      if [[ $REPLY =~ ^[Yy].* ]]
      then
      echo "Backing up configuration..."
        #git
        cp ~/.gitconfig $REPO/git/
        
        # homebrew
        cd $REPO/homebrew
        brew bundle dump -f
        cd -

        # tmux
        cp ~/.config/tmux/tmux.conf $REPO/tmux/

        #vim
        cp ~/.vimrc $REPO/vim/
        cp -r ~/.config/nvim/ $REPO/vim/nvim

        # kitty
        cp -r ~/.config/kitty/ $REPO/kitty

        # ghostty
        cp -r ~/.config/ghostty/ $REPO/ghostty
        
        #zsh
        cp ~/.zshrc $REPO/zsh/
        cp ~/.zprofile $REPO/zsh/
        cp ~/.oh-my-zsh/themes/robbyctx.zsh-theme $REPO/zsh/themes/

        # tmux
        cp ~/.config/fish/config.fish $REPO/fish/
        
        #vscode
        # Settings
        cp ~/Library/Application\ Support/Code/User/*.json $REPO/vscode/
        cp ~/Library/Application\ Support/Code/User/snippets/*.json $REPO/vscode/snippets

        # Extensions
        code --list-extensions > $REPO/vscode/extensions.txt

        #rust
        cp ~/.rustfmt.toml $REPO/rust/

        if [ -z "$(git -C $REPO status --porcelain)" ]; then 
          echo "No changes in dotfiles. Nothing to backup."
        else 
          git -C $REPO add .
          git -C $REPO commit -m "Backup configuration"
          git -C $REPO push
          echo "Done!"
        fi
      fi
      return 0
      ;;
    *)
      echo "Dotfiles command not supported: $1"
      echo "Provide either apply or backup option"
      return 1
      ;;
  esac
}
