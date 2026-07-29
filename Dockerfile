FROM nexus.lieberlieber.com:5000/lieberlieber/lemontree.automation:latest

USER root

# Install git, git-lfs, bash, curl, and PowerShell in one layer
RUN apt-get update && \
    apt-get install -y wget ca-certificates unzip && \
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
    curl -o lemontree.pipeline.tools.modelcheck https://nexus.lieberlieber.com/repository/lemontree-pipeline-tools/v2.5.6/LemonTree.Pipeline.Tools.ModelCheck && \
    chmod +x lemontree.pipeline.tools.modelcheck && \
    ln -s /app/lemontree.pipeline.tools.modelcheck /usr/local/bin/lemontree.modelcheck || true

# Download and set up LemonTree.Connect.Automation.Polarion
RUN mkdir -p /tmp/polarion-extract && \
    cd /tmp/polarion-extract && \
    curl -L -o lemontree.connect.polarion.zip https://nexus.lieberlieber.com/repository/lemontree-release/LemonTree.Automation/LemonTree.Connect.Automation.Polarion.Linux_3.1.0.zip && \
    unzip -q lemontree.connect.polarion.zip && \
    cp -r LemonTree.Connect.Polarion.Automation Mapping NLog.config EULA.rtf /app/ && \
    chmod +x /app/LemonTree.Connect.Polarion.Automation && \
    rm -rf /tmp/polarion-extract && \
    ln -s /app/LemonTree.Connect.Polarion.Automation /usr/local/bin/lemontree.polarion || true

# Download and set up LemonTree.Connect.Automation.Jama
RUN mkdir -p /tmp/jama-extract && \
    cd /tmp/jama-extract && \
    curl -L -o lemontree.connect.jama.zip https://nexus.lieberlieber.com/repository/lemontree-release/LemonTree.Automation/LemonTree.Connect.Jama.Automation.Linux_latest.zip && \
    unzip -q lemontree.connect.jama.zip && \
    cp -r LemonTree.Connect.Jama.Automation Mapping NLog.config EULA.rtf /app/ && \
    chmod +x /app/LemonTree.Connect.Jama.Automation && \
    rm -rf /tmp/jama-extract && \
    ln -s /app/LemonTree.Connect.Jama.Automation /usr/local/bin/lemontree.jama || true

# Install Node.js (LTS v20) for Playwright SVG to PNG conversion
RUN set -eux && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Verify Node.js installation
RUN node --version && npm --version

# Shared browser cache directory for both Node.js and Python Playwright runtimes
ENV PLAYWRIGHT_BROWSERS_PATH=/ms-playwright

# Set up Playwright with Chromium for SVG to PNG conversion
RUN mkdir -p /opt/svg2png && \
    cd /opt/svg2png && \
    npm init -y && \
    npm install playwright && \
    node node_modules/.bin/playwright install --with-deps chromium

# Install Python Playwright package so Python scripts can use the preinstalled runtime.
# System dependencies are already installed above; skip --with-deps to avoid redundancy.
RUN pip3 install playwright && \
    python3 -m playwright install chromium

# Copy SVG to PNG conversion script and make it globally accessible
COPY svg2png.js /opt/svg2png/svg2png.js
RUN chmod +x /opt/svg2png/svg2png.js && \
    ln -s /opt/svg2png/svg2png.js /usr/local/bin/svg2png

# Smoke-test: verify SVG to PNG conversion works at build time
RUN echo '<svg xmlns="http://www.w3.org/2000/svg" width="100" height="100"><circle cx="50" cy="50" r="40" fill="blue"/></svg>' > /tmp/test.svg && \
    svg2png /tmp/test.svg /tmp/test.png && \
    test -f /tmp/test.png && \
    rm /tmp/test.svg /tmp/test.png

# Copy version script
COPY versions.sh /usr/local/bin/versions.sh
RUN sed -i 's/\r$//' /usr/local/bin/versions.sh && chmod +x /usr/local/bin/versions.sh

# Set working directory to root
WORKDIR /





