# Enable PowerShell remoting
Enable-PSRemoting -Force

# Set WinRM service startup type to automatic
Set-Service WinRM -StartupType 'Automatic'

# Configure WinRM Service
Set-Item -Path WSMan:\localhost\Service\Auth\Certificate -Value $true
Set-Item -Path 'WSMan:\localhost\Service\AllowUnencrypted' -Value $true
Set-Item -Path 'WSMan:\localhost\Service\Auth\Basic' -Value $true
Set-Item -Path 'WSMan:\localhost\Service\Auth\CredSSP' -Value $true

# Create a self-signed certificate using the machine's hostname and set up an HTTPS listener
$hostname = hostname
$cert = New-SelfSignedCertificate -DnsName $hostname -CertStoreLocation "cert:\LocalMachine\My"
winrm create winrm/config/Listener?Address=*+Transport=HTTPS "@{Hostname=`"$hostname`";CertificateThumbprint=`"$($cert.Thumbprint)`"}"

# Create a firewall rule to allow WinRM HTTPS inbound
New-NetFirewallRule -DisplayName "Allow WinRM HTTPS" -Direction Inbound -LocalPort 5986 -Protocol TCP -Action Allow

# Configure TrustedHosts to allow all hosts (use "*" for simplicity or specify particular IPs if preferred)
Set-Item WSMan:\localhost\Client\TrustedHosts -Value "*" -Force

# Set LocalAccountTokenFilterPolicy to allow remote connections with local accounts
New-ItemProperty -Name LocalAccountTokenFilterPolicy -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -PropertyType DWord -Value 1 -Force

# Set execution policy to unrestricted (optional, only if required for remoting)
Set-ExecutionPolicy Unrestricted -Force

# Restart the WinRM service to apply changes
Restart-Service WinRM

# List the WinRM listeners to verify the configuration
winrm enumerate winrm/config/Listener
