FROM kasmweb/core-ubuntu-jammy:1.18.0
USER root

ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
ENV INST_SCRIPTS $STARTUPDIR/install
WORKDIR $HOME

######### Customize Container Here ###########

COPY ./src/ubuntu/install/viber $INST_SCRIPTS/viber/
#RUN bash $INST_SCRIPTS/viber/install_viber.sh  && rm -rf $INST_SCRIPTS/viber/
RUN  wget -O /tmp/viber.deb https://download.cdn.viber.com/cdn/desktop/Linux/viber.deb \\
      && apt-get update \\
      && sudo dpkg -i viber.deb \\
      && sudo apt-get install -f \\
      && cp /usr/share/applications/viber.desktop $HOME/Desktop/ \\
      && chmod +x $HOME/Desktop/viber.desktop \\
      && chown 1000:1000 $HOME/Desktop/viber.desktop

RUN echo "/usr/bin/desktop_ready && /opt/viber/Viber &" > $STARTUPDIR/custom_startup.sh && chmod +x $STARTUPDIR/custom_startup.sh


######### End Customizations ###########

RUN chown 1000:0 $HOME
RUN $STARTUPDIR/set_user_permission.sh $HOME

ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000