# reference:
# https://github.com/donnemartin/dev-setup
# https://github.com/jvortmann/dots/blob/master/osx/configure-osx.sh

# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "

# Set the default shell to bash
# chsh -s /bin/bash

# set computer name
COMPUTERNAME="panitanw_nvidia_mbp_m4"
sudo scutil --set ComputerName ${COMPUTERNAME}
sudo scutil --set HostName ${COMPUTERNAME}
sudo scutil --set LocalHost ${COMPUTERNAME}

# Turn on app auto-update
defaults write com.apple.commerce AutoUpdate -bool false

######################################################################
# screen saver
######################################################################
# Disable requiring password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 0
defaults write com.apple.screensaver askForPasswordDelay -int 0

######################################################################
# Finder Setup
######################################################################
# show full path in finder
defaults write com.apple.finder _FXShowPosixPathInTitle -bool YES
killall Finder

# Finder: show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# cmd+H to hidden the apps
# this command will add transparency to all of your hidden apps.
defaults write com.apple.dock showhidden -bool TRUE
killall Dock

# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool true

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Show icons for hard drives, servers, and removable media on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false

######################################################################
# Docker Setup
######################################################################
# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool false
# Don’t automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false
# Disable Magnification
defaults write com.apple.dock magnification -bool false
# set the dock position
defaults write com.apple.Dock orientation -string left
killall Dock

######################################################################
# Hot corners
######################################################################
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center

######################################################################
# Dock
######################################################################
# Bottom left screen corner -> Start screen saver
defaults write com.apple.dock wvous-bl-corner -int 4
defaults write com.apple.dock wvous-bl-modifier -int 0
# Bottom Righ screen corner -> Desktop
# defaults write com.apple.dock wvous-br-corner -int 4
# defaults write com.apple.dock wvous-br-modifier -int 0

######################################################################
# Terminal & iTerm 2
######################################################################
# Only use UTF-8 in Terminal.app
defaults write com.apple.terminal StringEncodings -array 4
defaults write -app iterm DisableFullscreenTransparency -bool true
defaults write -app iterm AdjustWindowForFontSizeChange -bool false
defaults write -app iterm QuitWhenAllWindowsClosed -bool true

######################################################################
# Use proper units
######################################################################
defaults write -g AppleMeasurementUnits -string "Centimeters"
defaults write -g AppleMetricUnits -bool true

######################################################################
# Screen Shots as a jpg
######################################################################
# Save screenshot as a png
defaults write com.apple.screencapture type -string 'jpg'

######################################################################
# keyboard
######################################################################
# enable key repeats on mac
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

######################################################################
# menu bar
######################################################################
PreferredMenuExtras=(
    "/System/Library/CoreServices/Menu Extras/Battery.menu"
    "/System/Library/CoreServices/Menu Extras/Bluetooth.menu"
    "/System/Library/CoreServices/Menu Extras/Clock.menu"
    "/System/Library/CoreServices/Menu Extras/Volume.menu"
)

currentUser=$(ls -l /dev/console | awk '{print $3}')
userHome=$(dscl . read /Users/$currentUser NFSHomeDirectory | awk '{print $NF}')

MenuExtras=$(defaults read "$userHome/Library/Preferences/com.apple.systemuiserver.plist" menuExtras | awk -F'"' '{print $2}')

for menuExtra in "${PreferredMenuExtras[@]}"; do
    menuShortName=$(echo "${menuExtra}" | awk -F'/' '{print $NF}')
    if [[ $(echo "${MenuExtras}" | grep "${menuExtra}") ]]; then
        echo "Menu Extra \"${menuShortName}\" present"
    else
        echo "Menu Extra \"${menuShortName}\" not in plist. Opening..."
        open "${menuExtra}"
    fi
done
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
