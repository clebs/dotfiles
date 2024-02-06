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

        # homebrew
        cd $REPO/homebrew
        brew bundle install --no-lock
        cd -

        stow -d ~/Dev/dotfiles/ -t ~/ .

        #vscode
        # Settings
        cp $REPO/vscode/*.json ~/Library/Application\ Support/Code/User/
        cp $REPO/vscode/snippets/*.json ~/Library/Application\ Support/Code/User/snippets/
        # Extensions
        cat $REPO/vscode/extensions.txt | xargs -n 1 code --install-extension

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
        # homebrew
        cd $REPO/homebrew
        brew bundle dump -f
        cd -

        #vscode
        # Settings
        cp ~/Library/Application\ Support/Code/User/*.json $REPO/vscode/
        cp ~/Library/Application\ Support/Code/User/snippets/*.json $REPO/vscode/snippets

        # Extensions
        code --list-extensions > $REPO/vscode/extensions.txt

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
