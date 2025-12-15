FROM ghcr.io/ledgerhq/ledger-app-builder/ledger-app-builder:latest

# Switch to root to add coverity tools
USER root

# Coverity Scan
ADD cov-analysis-linux64-2021.12.tar.gz /opt/
ENV PATH=/opt/cov-analysis-linux64-2021.12.1/bin:$PATH

# Switch back to base_user
USER base_user
WORKDIR /home/base_user
