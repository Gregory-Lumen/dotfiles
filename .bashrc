# Some shortcuts for different directory listings
alias ls='ls -hF --color=tty'                # classify files in colour
alias ll='ls -Al'                            # long list
alias la='ls -A'                             # all but . and ..
alias l='ls'                                 #

# alias myscreen='screen -RaAd -S DevScreen'
alias myscreen='tmux attach-session -t DevScreen || tmux new-session -s DevScreen'
export RANGER_LOAD_DEFAULT_RC=FALSE

export PS1='\[\e]0;\w\a\]\n\[\e[35m\][\D{%F %T}] \[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\]\n\$'
export WORKSPACE_ROOT=/workspace

stty -ixany


# Add .NET Core SDK tools
#export PATH="$PATH:/home/glumen/.dotnet/tools"

# I've noticed that for CDEs, we sometimes have trouble running the Git-Credential-Manager under the version of dotnet included in the os-sdk.
# The error in question looks like:
# > Failed to create CoreCLR, HRESULT: 0x8007000E
# And the following export seems to clear it up
export COMPlus_EnableDiagnostics=0

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

function launch-dbus()
{
  if test -z "$DBUS_SESSION_BUS_ADDRESS" ; then
    eval `dbus-launch --sh-syntax`
    echo "D-Bus per-session daemon address is: $DBUS_SESSION_BUS_ADDRESS"
  fi


  if test -z "$SSH_AUTH_SOCK" ; then
    export $(echo 'alltoomuch' | gnome-keyring-daemon --unlock)
  fi
}

launch-dbus

# Poetry starts acting wierd with keychain stuff, so we can simply disable it
# for now
export PYTHON_KEYRING_BACKEND=keyring.backends.null.Keyring

alias qemu-wifi-add='azsphere_v2 device wifi add -s qemu_ap'

function workspace-create()
{
  DEV_WORKSPACE_NAME=$1
  DEV_WORKSPACE=$WORKSPACE_ROOT/$DEV_WORKSPACE_NAME
  if [ -d $DEV_WORKSPACE ]; then
    echo "Workspace $DEV_WORKSPACE already exists, to recreate it run 'rm -rf $DEV_WORKSPACE' then run this command again"
    return
  fi

  echo "Creating workspace at $DEV_WORKSPACE"

  mkdir -p $DEV_WORKSPACE/build
  mkdir -p $DEV_WORKSPACE/cache
  mkdir -p $DEV_WORKSPACE/src

  git clone --recursive https://msazuresphere@dev.azure.com/msazuresphere/4x4/_git/exp23-yocto $DEV_WORKSPACE/src/exp23-yocto
  #git clone --recursive git@ssh.dev.azure.com:v3/msazuresphere/4x4/exp23-yocto $DEV_WORKSPACE/src/exp23-yocto
}

function activate-os-sdk()
{
  # OS SDK requires the Gnome-keyring which in turn requires a working dbus
  # session.
  launch-dbus

  source ~/azure-sphere/os-sdk/setup-env.sh
}

function workspace-update-sstate()
{

  if test -z "$DEV_WORKSPACE" ; then
    echo "No Workspace set, please activate a workspace and try again."
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
    echo "No Workspace set, please activate a workspace and try again."
  else
    DEV_OPTIONS=$1
    $DEV_WORKSPACE/src/exp23-yocto/build.py --cache $DEV_WORKSPACE/cache --out $DEV_WORKSPACE/build -v $DEV_OPTIONS
  fi
}

function workspace-run-qemu()
{
  if test -z "$DEV_WORKSPACE" ; then
    echo "No Workspace set, please activate a workspace and try again."
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

function workspace-generate-symbols()
{
  if test -z "$DEV_WORKSPACE" ; then
    echo "No Workspace set, please activate a workspace and try again."
  else
    $DEV_WORKSPACE/src/exp23-yocto/scripts/create-drop.py --output $BUILD_ROOT/drop --overwrite --build-output $BUILD_ROOT
    mkdir $BUILD_ROOT/symbols
    tar xf $BUILD_ROOT/drop/images/debug/symbols.tar.bz2 -C $BUILD_ROOT/symbols --overwrite
  fi

}

function prefixwith() {
  local prefix="$1"
  shift
  "$@" > >(sed "s/^/$prefix: /") 2> >(sed "s/^/$prefix (err): /" >&2)
}

function workspace-debug-console()
{
  if test -z "$DEV_WORKSPACE" ; then
    echo "No Workspace set, please activate a workspace and try again."
  else
    tail -F $BUILD_ROOT/debug-console
  fi
}

function workspace-debug-app()
{
  if test -z "$DEV_WORKSPACE" ; then
    echo "No Workspace set, please activate a workspace and try again."
  else
    APP_NAME=$(jq -r ".Name" app_manifest.json)
    APP_ID=$(jq -r ".ComponentId" app_manifest.json)

    if [[ ! -d $BUILD_ROOT/symbols ]] ; then
      workspace-generate-symbols
    else
      echo "Symbols already generated, re-using. Run 'workspace-generate-symbols' to regenerate symbols if needed"
    fi

    azsphere_v2 device sideload deploy -p $BUILD_ROOT/out/exp23-images/cortexa7t2hf-neon-vfpv4/gdbserver.imagepackage
    azsphere_v2 device sideload deploy -p ./out/ARM-Debug/$APP_NAME.imagepackage -m
    azsphere_v2 device app start --debug-mode --component-id "$APP_ID"
    ~/src/helper-scripts/debug-console.py 192.168.35.2 2342 $BUILD_ROOT/debug-console &
    TELNET_PID=$!

    $AZ_SPHERE_OS_SDK_ROOT/sysroots/native-x86_64-linux/usr/bin/gdb-multiarch \
      -ex "set print pretty on" \
      -ex "set pagination off" \
      -ex "set history save on" \
      -ex "set history expansion on" \
      -ex "set verbose on" \
      -ex "set solib-search-path $BUILD_ROOT/symbols" \
      -ex "set solib-absolute-prefix $BUILD_ROOT/symbols" \
      -ex "set debug-file-directory $BUILD_ROOT/symbols" \
      -ex "set substitute-path /usr/src/debug /" \
      -ex "target remote 192.168.35.2:2345" \
      ./out/ARM-Debug/$APP_NAME.out

    kill $TELNET_PID
  fi
}

function workspace-run-gdb()
{
  if test -z "$DEV_WORKSPACE" ; then
    echo "No Workspace set, please activate a workspace and try again."
  else
    if [[ ! -d $BUILD_ROOT/symbols ]] ; then
      workspace-generate-symbols
    else
      echo "Symbols already generated, re-using. Run 'workspace-generate-symbols' to regenerate symbols if needed"
    fi

    $AZ_SPHERE_OS_SDK_ROOT/sysroots/native-x86_64-linux/usr/bin/gdb-multiarch \
      -ex "set print pretty on" \
      -ex "set pagination off" \
      -ex "set history save on" \
      -ex "set history expansion on" \
      -ex "set verbose off" \
      -ex "set confirm off" \
      -ex "add-auto-load-safe-path $BUILD_ROOT/" \
      -ex "set solib-search-path $BUILD_ROOT/symbols" \
      -ex "set solib-absolute-prefix $BUILD_ROOT/symbols" \
      -ex "set debug-file-directory $BUILD_ROOT/symbols" \
      -ex "set substitute-path /usr/src/debug /"
  fi
}



function workspace-activate()
{
  DEV_WORKSPACE_NAME=$1
  DEV_WORKSPACE=$WORKSPACE_ROOT/$DEV_WORKSPACE_NAME
  if [ ! -d $DEV_WORKSPACE ]; then
    echo "Workspace $DEV_WORKSPACE does not exist, create it with 'workspace-create $DEV_WORKSPACE_NAME'"
    return
  fi

  pushd .
  activate-os-sdk
  BUILD_ROOT=$DEV_WORKSPACE/build CACHE_ROOT=$DEV_WORKSPACE/cache VERBOSE=1 source $DEV_WORKSPACE/src/exp23-yocto/setup-env.sh

  export BUILD_ROOT=$DEV_WORKSPACE/build
  export CACHE_ROOT=$DEV_WORKSPACE/cache
  export SSTATE_CACHE_ROOT=$DEV_WORKSPACE/cache
  export DEV_WORKSPACE=$DEV_WORKSPACE
  export PS1="\n\[\e[36m\]Workspace: $DEV_WORKSPACE $PS1"
}

function install_public_sphere_sdk()
{
  SPHERE_TEMP_DIR=~/tmp/azsphere-installer

  if [ -d $SPHERE_TEMP_DIR ]; then
    rm -r $SPHERE_TEMP_DIR
  fi
  mkdir -p $SPHERE_TEMP_DIR

  curl -L https://aka.ms/AzureSphereSDKInstall/Linux > $SPHERE_TEMP_DIR/install_azure_sphere_sdk.tar.gz
  tar xvfz $SPHERE_TEMP_DIR/install_azure_sphere_sdk.tar.gz -C $SPHERE_TEMP_DIR
  chmod +x $SPHERE_TEMP_DIR/install_azure_sphere_sdk.sh
  sudo $SPHERE_TEMP_DIR/install_azure_sphere_sdk.sh
  rm -r $SPHERE_TEMP_DIR
}

function install_internal_sphere_sdk()
{
  SPHERE_TEMP_DIR=~/tmp/azsphere-installer

  if [ -d $SPHERE_TEMP_DIR ]; then
    rm -r $SPHERE_TEMP_DIR
  fi
  mkdir -p $SPHERE_TEMP_DIR

  LATEST_RUN_ID=$(az pipelines runs list --branch main --pipeline-ids 62 --result succeeded --status completed --top 1 --query [0].id)
  echo "Downloading sdk installer from build $LATEST_RUN_ID"

  az pipelines runs artifact download --run-id $LATEST_RUN_ID --artifact-name LinuxSdk --path $SPHERE_TEMP_DIR

  chmod +x $SPHERE_TEMP_DIR/install_azure_sphere_sdk.sh
  sudo $SPHERE_TEMP_DIR/install_azure_sphere_sdk.sh -y -i $SPHERE_TEMP_DIR/Azure_Sphere_SDK_Bundle.tar.gz
  rm -r $SPHERE_TEMP_DIR
}

function install_latest_os_sdk()
{
  SPHERE_TEMP_DIR=~/tmp/os-sdk-installer

  if [ -d $SPHERE_TEMP_DIR ]; then
    rm -r $SPHERE_TEMP_DIR
  fi
  mkdir -p $SPHERE_TEMP_DIR

  LATEST_RUN_ID=$(az pipelines runs list --branch main --pipeline-ids 83 --result succeeded --status completed --top 1 --query [0].id)
  echo "Downloading OS SDK installer from build $LATEST_RUN_ID"

  az pipelines runs artifact download --run-id $LATEST_RUN_ID --artifact-name os-sdk-install --path $SPHERE_TEMP_DIR

  chmod +x $SPHERE_TEMP_DIR/install.sh
  $SPHERE_TEMP_DIR/install.sh -y -u -d ~/azure-sphere/os-sdk

  rm -r $SPHERE_TEMP_DIR
}
