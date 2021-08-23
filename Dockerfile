#
# BASE
#
FROM scratch

#
# RUNTIME
#
FROM codercom/code-server

USER root

RUN apt-get update

RUN apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

RUN groupadd -g 118 docker
RUN apt install -y docker.io
RUN usermod -aG docker coder

# Install docker compose
RUN curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

# Install kubectl
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN touch /etc/apt/sources.list.d/kubernetes.list 
RUN echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list
RUN apt-get update
RUN apt-get install -y kubectl

# Install git-crypt
RUN apt-get install -y git-crypt

# install Tools
RUN apt-get install zip unzip
RUN apt-get install -y jq
RUN apt-get install -y gettext-base
RUN apt-get install -y bc

#Install HELM cli
RUN curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
RUN  apt-get install apt-transport-https --yes
RUN echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
RUN apt-get update
RUN apt-get install helm

# Install AZ CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash
RUN az extension add --name azure-devops

# Install Other Tools
RUN apt-get install -y --no-install-recommends make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
RUN apt-get install reptyr

# Install .NET Core
RUN wget https://packages.microsoft.com/config/ubuntu/20.10/packages-microsoft-prod.deb -O packages-microsoft-prod.deb 
RUN dpkg -i packages-microsoft-prod.deb
RUN apt-get update; \
  apt-get install -y apt-transport-https && \
  apt-get update && \
  apt-get install -y dotnet-sdk-5.0
RUN apt-get install -y dotnet-runtime-5.0

# Configure INIT command
ADD run.sh /home/coder/
ADD init.sh /home/coder/
RUN chmod +x /home/coder/run.sh
RUN chmod +x /home/coder/init.sh

# Install npm & node
RUN apt install -y nodejs npm

# Install NPM dependencies
RUN npm i -g  @chimpwizards/wand yamljs

# Install python dependencies
RUN apt install python3-pip

USER coder
RUN git clone https://github.com/pyenv/pyenv.git /home/coder/.pyenv
RUN echo 'export PYENV_ROOT="/home/coder/.pyenv"' >> /home/coder/.bashrc
RUN echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> /home/coder/.bashrc
RUN echo 'if command -v pyenv 1>/dev/null 2>&1; then\n eval "$(pyenv init -)"\nfi' >> /home/coder/.bashrc
# RUN exec "$SHELL" && eval "$(pyenv init -)" && \
#     pyenv install --list && \
#     pyenv install 3.7.9 && \
#     pyenv local 3.7.9


RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | bash
RUN echo 'export NVM_DIR="/home/coder/.nvm"' >> /home/coder/.bashrc


RUN ls -la /home/coder/.nvm
#SHELL ["/bin/bash", "-c", "-l"]
RUN /bin/bash -c ". /home/coder/.nvm/nvm.sh && nvm install 10"

# Install NPM dependencies
# RUN npm i -g  @chimpwizards/wand csvtojson xml2json-cli yamljs

WORKDIR /var/app

ADD README.md .
ADD ./scripts .

ENTRYPOINT ["/home/coder/run.sh" ]


#
# REFERENCE
#
# - https://matthewpalmer.net/kubernetes-app-developer/articles/install-kubernetes-ubuntu-tutorial.html
# - https://itnext.io/running-kubectl-commands-from-within-a-pod-b303e8176088
# - https://stackoverflow.com/questions/42642170/how-to-run-kubectl-commands-inside-a-container
# - https://docs.microsoft.com/en-us/dotnet/core/install/linux-ubuntu
#
