FROM codercom/code-server

USER root

# Install git-crypt
RUN apt-get update
RUN apt-get install -y git-crypt

#export NVM_DIR="/home/coder/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" 

# Install azcure cli
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Install devops extension
RUN az extension add --name azure-devops

# Install jq
RUN apt-get install -y jq

ADD run.sh .
RUN chmod +x ./run.sh

USER coder
ENV NVM_DIR="/home/coder/.nvm"

# install nvm
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | bash && \
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
    nvm install 10 && \
    npm i -g @chimpwizards/wand

ENTRYPOINT [ "./run.sh" ]