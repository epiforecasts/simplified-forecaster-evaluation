# R version: latest, ... ,4.0.1 , 4.0.0
ARG VARIANT=4.2.0
FROM rocker/r-ver:${VARIANT}

# Use the [Option] comment to specify true/false arguments that should appear in VS Code UX
#
# [Option] Install zsh
ARG INSTALL_ZSH="true"
# [Option] Upgrade OS packages to their latest versions
ARG UPGRADE_PACKAGES="false"

# Install needed packages and setup non-root user. Use a separate RUN statement to add your own dependencies.
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID
COPY .devcontainer/library-scripts/*.sh /tmp/library-scripts/
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && /bin/bash /tmp/library-scripts/common-debian.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" "true" "true" \
    && usermod -a -G staff ${USERNAME} \
    && apt-get -y install \
        python3-pip \
        libgit2-dev \
        libcurl4-openssl-dev \
        libssl-dev \
        libxml2-dev \
        libxt-dev \
        pandoc \
        libfontconfig1-dev \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts \
    && python3 -m pip --no-cache-dir install radian pre-commit \
    && install2.r --error --skipinstalled --repos ${CRAN} --ncpus -1 \
        devtools \
        languageserver \
        git2r \
        tinytex \
        httpgd \
        remotes \
        renv \
    && rm -rf /tmp/downloaded_packages


RUN apt-get update \
     && export DEBIAN_FRONTEND=noninteractive \
     && apt-get -y install --no-install-recommends libglpk-dev libv8-dev \
            pandoc-citeproc tmux

# make workspace directory
RUN mkdir -p /workspaces/simplified-forecaster-evaluation
RUN chmod -R ugo+rw /workspaces/simplified-forecaster-evaluation

# install dependencies
WORKDIR /workspaces/simplified-forecaster-evaluation
COPY renv.lock renv.lock
RUN R -e 'renv::restore()'
RUN rm renv.lock

# install latex
RUN Rscript -e "tinytex::install_tinytex()"