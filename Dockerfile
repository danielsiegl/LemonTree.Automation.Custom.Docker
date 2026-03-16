FROM nexus.lieberlieber.com:5000/lieberlieber/lemontree.automation:latest

USER root

# Install git, git-lfs, bash, curl, and PowerShell in one layer
RUN apt-get update && \
    apt-get install -y wget ca-certificates && \
    echo 'APT::Get::AllowUnauthenticated "true";' >> /etc/apt/apt.conf.d/99-allow-unauthenticated && \
    echo "deb [trusted=yes] http://ppa.launchpad.net/git-core/ppa/ubuntu jammy main" > /etc/apt/sources.list.d/git-core-ppa.list && \
    apt-get update && \
    apt-get install -y git bash curl && \
    apt-get install -y git-lfs && \
    wget -q https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O /tmp/packages-microsoft-prod.deb && \
    dpkg -i /tmp/packages-microsoft-prod.deb && \
    apt-get update && \
    apt-get install -y powershell && \
    rm /tmp/packages-microsoft-prod.deb && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Verify installations
RUN git --version && \
    git lfs version && \
    pwsh --version

# Create symlink to lemontree.automation in /usr/local/bin for global access
RUN ln -s /app/lemontree.automation /usr/local/bin/lemontree.automation || true

# Download and set up LemonTree.Pipeline.Tools.ModelCheck
RUN cd /app && \
    curl -o lemontree.pipeline.tools.modelcheck https://nexus.lieberlieber.com/repository/lemontree-pipeline-tools/LemonTree.Pipeline.Tools.ModelCheck && \
    chmod +x lemontree.pipeline.tools.modelcheck && \
    ln -s /app/lemontree.pipeline.tools.modelcheck /usr/local/bin/lemontree.modelcheck || true

# Set working directory to root
WORKDIR /

