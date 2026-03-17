FROM nexus.lieberlieber.com:5000/lieberlieber/lemontree.automation:latest

USER root

# Install git, git-lfs, bash, curl, and PowerShell in one layer
RUN apt-get update && \
    apt-get install -y wget ca-certificates && \
    echo 'APT::Get::AllowUnauthenticated "true";' >> /etc/apt/apt.conf.d/99-allow-unauthenticated && \
    echo "deb [trusted=yes] http://ppa.launchpad.net/git-core/ppa/ubuntu jammy main" > /etc/apt/sources.list.d/git-core-ppa.list && \
    apt-get update && \
    apt-get install -y git bash curl && \
    wget -q https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O /tmp/packages-microsoft-prod.deb && \
    dpkg -i /tmp/packages-microsoft-prod.deb && \
    apt-get update && \
    apt-get install -y powershell && \
    rm /tmp/packages-microsoft-prod.deb && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
# Install latest git-lfs from official releases
RUN set -eux && \
    GIT_LFS_VERSION=$(curl -s https://api.github.com/repos/git-lfs/git-lfs/releases/latest | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/') && \
    curl -L "https://github.com/git-lfs/git-lfs/releases/download/v${GIT_LFS_VERSION}/git-lfs-linux-amd64-v${GIT_LFS_VERSION}.tar.gz" -o /tmp/git-lfs.tar.gz && \
    mkdir -p /tmp/git-lfs-extract && cd /tmp/git-lfs-extract && tar -xzf /tmp/git-lfs.tar.gz && \
    find . -name "git-lfs" -type f -executable -exec bash -c 'mv "$1" /usr/local/bin/git-lfs' _ {} \; && \
    chmod +x /usr/local/bin/git-lfs && \
    /usr/local/bin/git-lfs install && \
    rm -rf /tmp/git-lfs* && \
    git lfs version
# Verify installations
RUN git --version && \
    git lfs version && \
    pwsh --version

# Install latest Go from official distribution
RUN set -eux && \
    GO_VERSION=$(curl -s https://go.dev/VERSION?m=text | head -n 1 | sed 's/go//') && \
    curl -L "https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz" -o /tmp/go.tar.gz && \
    tar -C /usr/local -xzf /tmp/go.tar.gz && \
    rm /tmp/go.tar.gz

ENV PATH=$PATH:/usr/local/go/bin

# Verify Go installation
RUN go version

# Create symlink to lemontree.automation in /usr/local/bin for global access
RUN ln -s /app/lemontree.automation /usr/local/bin/lemontree.automation || true

# Download and set up LemonTree.Pipeline.Tools.ModelCheck
RUN cd /app && \
    curl -o lemontree.pipeline.tools.modelcheck https://nexus.lieberlieber.com/repository/lemontree-pipeline-tools/LemonTree.Pipeline.Tools.ModelCheck && \
    chmod +x lemontree.pipeline.tools.modelcheck && \
    ln -s /app/lemontree.pipeline.tools.modelcheck /usr/local/bin/lemontree.modelcheck || true

# Set working directory to root
WORKDIR /

