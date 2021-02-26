function dotfiles {
  local REPO="$(echo ~/Dev/dotfiles)"
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
        
        #vim
        cp $REPO/vim/.vimrc ~/
        
        #zsh
        cp $REPO/zsh/.zshrc ~/
        cp $REPO/zsh/.zprofile ~/
        cp $REPO/zsh/themes/*.zsh-theme ~/.oh-my-zsh/themes/

        #vscode
        cp $REPO/vscode/*.json ~/Library/Application\ Support/Code/User/
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
        
        #vim
        cp ~/.vimrc $REPO/vim/
        
        #zsh
        cp ~/.zshrc $REPO/zsh/
        cp ~/.zprofile $REPO/zsh/
        cp ~/.oh-my-zsh/themes/robbyctx.zsh-theme $REPO/zsh/themes/

        #vscode
        cp ~/Library/Application\ Support/Code/User/*.json $REPO/vscode/
        cp ~/Library/Application\ Support/Code/User/snippets/*.json $REPO/vscode/snippets

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