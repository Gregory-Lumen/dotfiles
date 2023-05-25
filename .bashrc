# Some shortcuts for different directory listings
alias ls='ls -hF --color=tty'                # classify files in colour
alias ll='ls -Al'                            # long list
alias la='ls -A'                             # all but . and ..
alias l='ls'                                 #

# alias myscreen='screen -RaAd -S DevScreen'
alias myscreen='tmux attach-session -t DevScreen || tmux new-session -s DevScreen'
export RANGER_LOAD_DEFAULT_RC=FALSE

export PS1='\[\e]0;\w\a\]\n\[\e[35m\][\D{%F %T}] \[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\]\n\$'

stty -ixany

function ranger-cd {
  tempfile='/tmp/chosendir'
  ranger --choosedir="$tempfile" "${@:-$(pwd)}"
  test -f "$tempfile" &&
  if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
    cd -- "$(cat "$tempfile")"
  fi
  rm -f -- "$tempfile"
}

# -- Improved X11 forwarding through GNU Screen (or tmux).
# If not in screen or tmux, update the DISPLAY cache.
# If we are, update the value of DISPLAY to be that in the cache.
function update-display()
{
  if [ -z "$STY" -a -z "$TMUX" ]; then
    # echo Updating ~/.display.txt with $DISPLAY
    echo $DISPLAY > ~/.display.txt
  else
    export DISPLAY=`cat ~/.display.txt`
    # echo DISPLAY set to $DISPLAY
  fi
}

update-display

# This binds Ctrl-O to ranger-cd:
bind '"\C-o":"ranger-cd\C-m"'

function workspace-create()
{
  DEV_WORKSPACE_NAME=$1
  DEV_WORKSPACE=~/workspace/$DEV_WORKSPACE_NAME
  if [ -d $DEV_WORKSPACE ]; then
    echo "Workspace $DEV_WORKSPACE already exists, to recreate it run 'rm -rf $DEV_WORKSPACE' then run this command again"
    return
  fi

  echo "Creating workspace at $DEV_WORKSPACE"

  mkdir -p $DEV_WORKSPACE/build
  mkdir -p $DEV_WORKSPACE/cache
  mkdir -p $DEV_WORKSPACE/src
  git clone --recursive git@ssh.dev.azure.com:v3/msazuresphere/4x4/exp23-yocto $DEV_WORKSPACE/src/exp23-yocto
}

function activate-os-sdk()
{
  ## test for an existing bus daemon, just to be safe
  if test -z "$DBUS_SESSION_BUS_ADDRESS" ; then
    ## if not found, launch a new one
    eval `dbus-launch --sh-syntax`
    echo "D-Bus per-session daemon address is: $DBUS_SESSION_BUS_ADDRESS"
  fi

  echo 'alltoomuch' | gnome-keyring-daemon --unlock
  source ~/os-sdk/setup-env.sh
}

function workspace-update-sstate()
{

  if test -z "$DEV_WORKSPACE" ; then
    echo "No Workspace set, please activate a workspace with 'activate-[dev|clean]-workspace' and try again."
  else
    # For some reason we frequently get in a state where the artifact
    # downloader fails. The error message coincides with errors folks get with
    # read-only Filesystems (like docker, see
    # https://stackoverflow.com/questions/74447989/failed-to-create-coreclr-hresult-0x80004005)
    # Might be related to VM OS partition sizing, but it solves the problem.
    export COMPlus_EnableDiagnostics=0
    $DEV_WORKSPACE/src/exp23-yocto/scripts/download_sstate_cache.sh -c $DEV_WORKSPACE/cache/sstate-cache/ -b $DEV_WORKSPACE/build/
  fi
}

function workspace-build-py()
{
  if test -z "$DEV_WORKSPACE" ; then
    echo "No Workspace set, please activate a workspace with 'activate-[dev|clean]-workspace' and try again."
  else
    OPTIONS=$1
    $DEV_WORKSPACE/src/exp23-yocto/build.py --cache $DEV_WORKSPACE/cache --out $DEV_WORKSPACE/build -v $DEV_OPTIONS
  fi
}

function workspace-run-qemu()
{
  if test -z "$DEV_WORKSPACE" ; then
    echo "No Workspace set, please activate a workspace with 'activate-[dev|clean]-workspace' and try again."
  else
    os vm create --reconfigure \
      --soc mt3620 \
      --flash $DEV_WORKSPACE/build/out/deploy/images/blanca/exp23-rtm-blanca.flash.bin \
      --pluton ~/.exp23-qemu/blanca/hsp.bin \
      --name workspace_qemu_vm \
      --stage ~/.exp23-qemu/blanca/console-enabled.bin

    os vm run --name workspace_qemu_vm
  fi
}

function activate-workspace()
{
  DEV_WORKSPACE_NAME=$1
  DEV_WORKSPACE=~/workspace/$DEV_WORKSPACE_NAME
  if [ ! -d $DEV_WORKSPACE ]; then
    echo "Workspace $DEV_WORKSPACE does not exist, create it with 'workspace-create $DEV_WORKSPACE_NAME'"
    return
  fi
  BUILD_ROOT=$DEV_WORKSPACE/build CACHE_ROOT=$DEV_WORKSPACE/cache VERBOSE=1 source $DEV_WORKSPACE/src/exp23-yocto/setup-env.sh

  export BUILD_ROOT=$DEV_WORKSPACE/build
  export CACHE_ROOT=$DEV_WORKSPACE/cache
  export DEV_WORKSPACE=$DEV_WORKSPACE
  export PS1="\n\[\e[36m\]Workspace: $DEV_WORKSPACE $PS1"
}
