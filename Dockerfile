FROM kasmweb/core-ubuntu-jammy:1.18.0
USER root

ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
ENV INST_SCRIPTS $STARTUPDIR/install
WORKDIR $HOME

######### Customize Container Here ###########

#COPY ./src/ubuntu/install/viber $INST_SCRIPTS/viber/
#RUN bash $INST_SCRIPTS/viber/install_viber.sh  && rm -rf $INST_SCRIPTS/viber/
#RUN  wget -O /tmp/viber.deb https://download.cdn.viber.com/cdn/desktop/Linux/viber.deb \
#      && apt-get update \
#      && sudo dpkg -i /tmp/viber.deb \
#      && sudo apt-get install -f \
#      && sudo apt install libc6:i386 libatomic1:i386 \
#      && cp /usr/share/applications/viber.desktop $HOME/Desktop/ \
#      && chmod +x $HOME/Desktop/viber.desktop \
#      && chown 1000:1000 $HOME/Desktop/viber.desktop
#RUN echo "/usr/bin/desktop_ready && /opt/viber/Viber &" > $STARTUPDIR/custom_startup.sh && chmod +x $STARTUPDIR/custom_startup.sh

RUN apt-get update && apt-get install -y \
    pipewire \
    pipewire-audio-client-libraries \
    libpipewire-0.3-0 \
    libqt5multimedia5 \
    libqt5multimediawidgets5 \
    && rm -rf /var/lib/apt/lists/* \
    && wget -O /opt/viber.AppImage https://download.cdn.viber.com/desktop/Linux/viber.AppImage \
    && chmod +x /opt/viber.AppImage \
    && echo "/usr/bin/desktop_ready && /opt/viber.AppImage --appimage-extract-and-run &" > $STARTUPDIR/custom_startup.sh && chmod +x $STARTUPDIR/custom_startup.sh
    

######### End Customizations ###########

RUN chown 1000:0 $HOME
RUN $STARTUPDIR/set_user_permission.sh $HOME

ENV HOME /home/kasm-user
ENV APPIMAGE_EXTRACT_AND_RUN 1
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000