New-SelfSignedCertificate -CertStoreLocation Cert:\CurrentUser\my `
                          -DnsName *.r.local `
                          -KeyAlgorithm RSA `
                          -KeyExportPolicy Exportable `
                          -KeyLength 2048 `
                          -KeyUsage DigitalSignature `
                          -Provider "Microsoft Enhanced RSA and AES Cryptographic Provider" `
                          -Subject "CN=Local Code Signing" `
                          -Type CodeSigningCert `
                          -NotAfter (Get-Date).AddYears(10)



$cert = @(Get-ChildItem cert:\CurrentUser\My -CodeSigning)[0] 
Set-AuthenticodeSignature .\your-script.ps1 $cert
