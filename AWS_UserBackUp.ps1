
#Get local profile name of primary user
$username = $Env:UserName

#Get Path of primary user profile
$filepath = Get-ItemPropertyValue "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\$((Get-LocalUser $username).SID)" ProfileImagePath

#Get Relevant Folders
$DesktopFilePath = $filepath + "\Desktop"

#AWS Variables
$AWSAccessKey = "ENTER KEY HERE"
$AWSSecretKey = "ENTER SECRET HERE"


#Install AWS Modules
Install-Module -Name AWS.Tools.Installer
Install-AWSToolsModule AWS.Tools.EC2,AWS.Tools.S3 -CleanUp

#Set AWS Credentials
Set-AWSCredential -AccessKey $AWSAccessKey -SecretKey $AWSSecretKey -StoreAs default

#Back up local user profile to AWS S3 bucket
Write-S3Object -BucketName arn:aws:s3:us-west-2:251673795712:accesspoint/local-backup-ap -Folder $Desktopfilepath -KeyPrefix $username

#Uninstall AWS Modules
#Get-Module -Name AWS.Tools.EC2 -ListAvailable | Select-Object -ExpandProperty ModuleBase | Remove-Item -Recurse -Force
#Get-Module -Name aws.tools.S3 -ListAvailable | Select-Object -ExpandProperty ModuleBase | Remove-Item -Recurse -Force

#Delete remaining AWS credentials file
Remove-Item -Path C:\Users\$username\AppData\Local\AWSToolkit\RegisteredAccounts.json
