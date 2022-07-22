[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1
wget "https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1" -Outfile ConfigureRemotingForAnsible.ps1 
./ConfigureRemotingForAnsible.ps1 -EnableCredSSP -DisableBasicAuth -Verbose