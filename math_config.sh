#!/bin/bash

#START_DIR="${START_DIR:-/home/coder/project}"

PREFIX="deploy-code-server"
RCLONE_FLAGS=--exclude "node_modules/**" --exclude ".git/**"

# function to clone the git repo or add a user's first file if no repo was specified.
project_init () {
    [ -z "${MATHG_REPO}" ] && echo "[$PREFIX] No MATHG_REPO specified" && echo "Example file. Have questions? Join us at https://community.coder.com" > $START_DIR/coder.txt || git clone $MATHG_REPO $START_DIR
}

# add rclone config and start rclone, if supplied
if [[ -z "${MATHR_DATA}" ]]; then
    echo "[$PREFIX] MATHR_DATA is not specified. Files will not persist"

    # start the project
    project_init

else
    echo "[$PREFIX] Copying rclone config..."
    mkdir -p ~/.config/rclone/
    touch ~/.config/rclone/rclone.conf
    echo $MATHR_DATA | base64 -d > ~/.config/rclone/rclone.conf

    # default to true
    RCLONE_VSCODE_TASKS="${RCLONE_VSCODE_TASKS:-true}"
    RCLONE_AUTO_PUSH="${RCLONE_AUTO_PUSH:-true}"
    RCLONE_AUTO_PULL="${RCLONE_AUTO_PULL:-true}"

    if [ $RCLONE_VSCODE_TASKS = "true" ]; then
        # copy our tasks config to VS Code
        echo "[$PREFIX] Applying VS Code tasks for rclone"
        #cp /rclone-tasks.json ~/.local/share/code-server/User/tasks.json
        # install the extension to add to menu bar
        #code-server --install-extension actboy168.tasks&
    else
        # user specified they don't want to apply the tasks
        echo "[$PREFIX] Skipping VS Code tasks for rclone"
    fi


    mkdir -p /home/coder
    # Full path to the remote filesystem
    RCLONE_REMOTE_PATH_2=${RCLONE_REMOTE_NAME:-onedrive_imath}:${RCLONE_DESTINATION:-Projects}
    RCLONE_REMOTE_PATH=${RCLONE_REMOTE_NAME:-gdrive_small}:${RCLONE_DESTINATION:-Projects}
    RCLONE_SOURCE_PATH=${RCLONE_SOURCE:-$START_DIR}
    echo "cd ${START_DIR}" >> /home/coder/pull_remote.sh
    echo "git pull origin main" >> /home/coder/pull_remote.sh
    echo "# rclone sync $RCLONE_REMOTE_PATH $RCLONE_SOURCE_PATH --exclude \"node_modules/**\" --exclude \".git/**\" -vv" >> /home/coder/pull_remote.sh

    echo "cd ${START_DIR}" >> /home/coder/push_remote.sh
    echo "git config --global user.email \"mather@example.com\"" >> /home/coder/push_remote.sh
    echo "git config --global user.name \"mather\"" >> /home/coder/push_remote.sh
    echo "git add ." >> /home/coder/push_remote.sh
    echo "git commit -m \"ok\"" >> /home/coder/push_remote.sh
    echo "git push origin main" >> /home/coder/push_remote.sh
    
    echo "rclone sync $RCLONE_SOURCE_PATH $RCLONE_REMOTE_PATH --exclude \"node_modules/**\" --exclude \".git/**\" -vv" >> /home/coder/push_remote.sh
    echo "rclone sync $RCLONE_SOURCE_PATH $RCLONE_REMOTE_PATH_2 --exclude \"node_modules/**\" --exclude \".git/**\" -vv" >> /home/coder/push_remote.sh
    chmod a+rx /home/coder/push_remote.sh
    chmod a+rx /home/coder/pull_remote.sh
    project_init

    # if rclone ls $RCLONE_REMOTE_PATH; then

    #     if [ $RCLONE_AUTO_PULL = "true" ]; then
    #         # grab the files from the remote instead of running project_init()
    #         echo "[$PREFIX] Pulling existing files from remote..."
    #         /home/coder/pull_remote.sh&
    #     else
    #         # user specified they don't want to apply the tasks
    #         echo "[$PREFIX] Auto-pull is disabled"
    #     fi

    # else

    #     if [ $RCLONE_AUTO_PUSH = "true" ]; then
    #         # we need to clone the git repo and sync
    #         echo "[$PREFIX] Pushing initial files to remote..."
    #         project_init
    #         /home/coder/push_remote.sh&
    #     else
    #         # user specified they don't want to apply the tasks
    #         echo "[$PREFIX] Auto-push is disabled"
    #     fi

    # fi

fi

# Add dotfiles, if set
if [ -n "$DOTFILES_REPO" ]; then
    # grab the files from the remote instead of running project_init()
    echo "[$PREFIX] Cloning dotfiles..."
    mkdir -p $HOME/dotfiles
    git clone $DOTFILES_REPO $HOME/dotfiles

    DOTFILES_SYMLINK="${RCLONE_AUTO_PULL:-true}"

    # symlink repo to $HOME
    if [ $DOTFILES_SYMLINK = "true" ]; then
        shopt -s dotglob
        ln -sf source_file $HOME/dotfiles/* $HOME
    fi

    # run install script, if it exists
    [ -f "$HOME/dotfiles/install.sh" ] && $HOME/dotfiles/install.sh
fi

echo "[$PREFIX] Starting code-server..."


# while true
# do
# 	echo "Press [CTRL+C] to stop.."
#     time2=$(date "+%Y-%m-%d %H:%M:%S")
#     echo "${time2}"
# 	sleep 60
#     # Full path to the remote filesystem
#     time=$(date "+%Y-%m-%d_%H-%M-%S")
#     RCLONE_REMOTE_PATH_B=${RCLONE_REMOTE_NAME:-gdrive_small}:${RCLONE_DESTINATION:-Docker_Backup/Heroku/${time}}
#     RCLONE_SOURCE_PATH_B=${RCLONE_SOURCE:-$START_DIR}
#     rclone sync $RCLONE_SOURCE_PATH_B $RCLONE_REMOTE_PATH_B $RCLONE_FLAGS -vv
# done
