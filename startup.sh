# FROM REPO:
# https://github.com/BoringCat/docker-WXWork

WXWORK_NAME=wxwork

# enable xsettings on not gnome desktop environment
# install by `yay -S cinnamon-settings-daemon` on archlinux
if ! ps -C 'csd-xsettings' >/dev/null
then
    /usr/lib/cinnamon-settings-daemon/csd-xsettings 2>&1 > /dev/null &
fi


# enable xhost service
xhost +

# check whether wxwork has already exists
sudo docker ps -a | grep -q "${WXWORK_NAME}"
if [ "$?" -eq "0" ]; then
        sudo docker start "${WXWORK_NAME}"
        exit 0
fi

# startup by docker command
sudo docker run -d --name "${WXWORK_NAME}" --device /dev/snd --ipc host \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -v $HOME/WXWork:/WXWork \
        -v $HOME:/HostHome \
        -v $HOME/wine-WXWork:/home/wechat/.deepinwine/Deepin-WXWork \
        -e DISPLAY=unix$DISPLAY \
        -e XMODIFIERS=@im=fcitx5 \
        -e QT_IM_MODULE=fcitx5 \
        -e GTK_IM_MODULE=fcitx5 \
        -e AUDIO_GID=`getent group audio | cut -d: -f3` \
        -e GID=`id -g` \
        -e UID=`id -u` \
        -e DPI=96 \
        -e WAIT_FOR_SLEEP=1 \
        boringcat/wechat:work
