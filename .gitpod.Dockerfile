
FROM mcr.microsoft.com/azure-cloudshell:latest
# refer https://github.com/PowerShell/PowerShell-Docker/issues/394

SHELL ["/usr/bin/pwsh", "-c"]
RUN $ErrorActionPreference='Stop'; `
    Start-Transcript -path /Dockerfile.log -append -IncludeInvocationHeader ; `
    $PSVersionTable | Write-Output ; `
    Install-Module -Name AWSPowerShell.NetCore -AllowClobber -Force ; `
    New-Item /root/.config/powershell/ -Type Directory -Force ; `
    Stop-Transcript ;

# Copy in my custom powershell module files that are "imported" in the profile bellow
ADD ./ /mnt/MyCustomPSM1Dir

# Use pwsh profile to initialize my custom powershell module
ADD ./MyCustom.PowerShell_profile.ps1 /root/.config/powershell/Microsoft.PowerShell_profile.ps1

# Default commands to pwsh
ENTRYPOINT ["pwsh","-c"]

## end paste

USER root 

# # Install Nix
# RUN addgroup --system nixbld \
#   && adduser gitpod nixbld \
#   && for i in $(seq 1 30); do useradd -ms /bin/bash nixbld$i &&  adduser nixbld$i nixbld; done \
#   && mkdir -m 0755 /nix && chown gitpod /nix \
#   && mkdir -p /etc/nix && echo 'sandbox = false' > /etc/nix/nix.conf
  
# # Install Nix
# CMD /bin/bash -l
# USER gitpod
# ENV USER gitpod
# WORKDIR /home/gitpod

# RUN touch .bash_profile \
#  && curl https://nixos.org/releases/nix/nix-2.3.14/install | sh

# RUN echo '. /home/gitpod/.nix-profile/etc/profile.d/nix.sh' >> /home/gitpod/.bashrc
# RUN mkdir -p /home/gitpod/.config/nixpkgs && echo '{ allowUnfree = true; }' >> /home/gitpod/.config/nixpkgs/config.nix

# # Install cachix
# RUN . /home/gitpod/.nix-profile/etc/profile.d/nix.sh \
#   && nix-env -iA cachix -f https://cachix.org/api/v1/install \
#   && cachix use cachix

# # # Install git
# # RUN . /home/gitpod/.nix-profile/etc/profile.d/nix.sh \
# #   && nix-env -i git git-lfs

# # Install direnv
# RUN . /home/gitpod/.nix-profile/etc/profile.d/nix.sh \
#   && nix-env -i direnv \
#   && direnv hook bash >> /home/gitpod/.bashrc