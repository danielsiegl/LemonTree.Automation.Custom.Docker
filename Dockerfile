FROM nexus.lieberlieber.com:5000/lieberlieber/lemontree.automation:latest

USER root

# Install git, git-lfs and PowerShell
RUN echo 'APT::Get::AllowUnauthenticated "true";' >> /etc/apt/apt.conf.d/99-allow-unauthenticated && \
    echo "deb [trusted=yes] http://ppa.launchpad.net/git-core/ppa/ubuntu jammy main" > /etc/apt/sources.list.d/git-core-ubuntu-ppa-jammy.list && \
    echo "deb [trusted=yes] https://packages.microsoft.com/repos/microsoft-debian-bookworm-prod bookworm main" > /etc/apt/sources.list.d/microsoft.list && \
    apt-get update && \
    apt-get install -y git git-lfs powershell bash curl && \
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
    ln -s /app/lemontree.pipeline.tools.modelcheck /usr/local/bin/lemontree-modelcheck || true

# Set working directory to root
WORKDIR /

# Set sh as default entrypoint
ENTRYPOINT ["/bin/sh"]

