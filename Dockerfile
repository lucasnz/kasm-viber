FROM kasmweb/core-ubuntu-jammy:1.18.0
USER root

ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
ENV INST_SCRIPTS $STARTUPDIR/install
WORKDIR $HOME

######### Customize Container Here ###########

## Update the desktop environment to be optimized for a single application
RUN cp $HOME/.config/xfce4/xfconf/single-application-xfce-perchannel-xml/* $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/
# Remove the xfce4-panel
RUN apt-get remove -y xfce4-panel
## --> Optionally, set a background image
RUN cp /usr/share/backgrounds/bg_kasm.png /usr/share/backgrounds/bg_default.png
# install viber
RUN apt-get update && apt-get install -y \
    pipewire \
    pipewire-audio-client-libraries \
    libpipewire-0.3-0 \
    libqt5multimedia5 \
    libqt5multimediawidgets5 \
    && rm -rf /var/lib/apt/lists/* \
    && wget -qO /opt/viber.AppImage https://download.cdn.viber.com/desktop/Linux/viber.AppImage \
    && chmod +x /opt/viber.AppImage

## --> Copy custom_startup.sh script to the startup directory inside the image
COPY ./src/ubuntu/install/viber/custom_startup.sh $STARTUPDIR/custom_startup.sh
## --> Set permissions
RUN chmod 755 $STARTUPDIR/custom_startup.sh

######### End Customizations ###########

RUN chown 1000:0 $HOME
RUN $STARTUPDIR/set_user_permission.sh $HOME

ENV HOME /home/kasm-user
# set AppImage to extract and run (required to run inside docker)
ENV APPIMAGE_EXTRACT_AND_RUN 1
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000