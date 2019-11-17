#!/bin/sh
# Script Created by Jerome Laliag

curl -s https://swupdate.openvpn.net/repos/repo-public.gpg | apt-key add -
echo "deb http://build.openvpn.net/debian/openvpn/stable xenial main" > /etc/apt/sources.list.d/openvpn-aptrepo.list
apt-get update
apt-get -y install openvpn apache2
ln -fs /usr/share/zoneinfo/Asia/Manila /etc/localtime
mkdir /etc/iptables/
cat > /etc/iptables/rules.v4 <<-END
* nat
-A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE
COMMIT
END
echo "net.ipv4.ip_forward=1" > /etc/sysctl.conf
cat > /etc/openvpn/server.conf <<-END
dev tun
proto tcp-server
port 853
dh none
tls-crypt tls-crypt.key 0
crl-verify crl.pem
ca ca.crt
cert server.crt
key server.key
client-cert-not-required
plugin /usr/lib/openvpn/plugins/openvpn-plugin-auth-pam.so login
server 10.8.0.0 255.255.255.0
auth none
cipher none
ecdh-curve prime256v1
ncp-ciphers AES-128-GCM
tls-server
tls-version-min 1.2
tls-cipher TLS-ECDHE-ECDSA-WITH-AES-128-GCM-SHA256
push "persist-tun"
push "redirect-gateway def1"
push "dhcp-option DNS 1.1.1.1"
push "dhcp-option DNS 1.0.0.1"
END
cat > /etc/rc.local <<-END
#!/bin/sh -e
iptables-restore < /etc/iptables/rules.v4
END
cat > /etc/openvpn/ca.crt <<-END
-----BEGIN CERTIFICATE-----
MIIBrTCCAVKgAwIBAgIJAMwxNnqzf5hxMAoGCCqGSM49BAMCMBcxFTATBgNVBAMM
DGplcm9tZWxhbGlhZzAeFw0xOTExMDEwNzUwMTBaFw0yOTEwMjkwNzUwMTBaMBcx
FTATBgNVBAMMDGplcm9tZWxhbGlhZzBZMBMGByqGSM49AgEGCCqGSM49AwEHA0IA
BGALTkrNJ8w5KtpeIwjihLsLDXpZxv+KNpSQCei+n6JXvMPeKDrvwEvY8jsEb0KL
aqNbFDo0MfGc3d9OINRUttKjgYYwgYMwHQYDVR0OBBYEFJXihpO93UjCbxkAefFB
O8l4xb4rMEcGA1UdIwRAMD6AFJXihpO93UjCbxkAefFBO8l4xb4roRukGTAXMRUw
EwYDVQQDDAxqZXJvbWVsYWxpYWeCCQDMMTZ6s3+YcTAMBgNVHRMEBTADAQH/MAsG
A1UdDwQEAwIBBjAKBggqhkjOPQQDAgNJADBGAiEA8eehh3XGUwun5HYeW8Ao/vyy
X+9Xat9hIOVsXz/bosMCIQDoraPifMb6J2n0DyaOEfjN/R5JA6BRT0wjR+yBHPMv
pg==
-----END CERTIFICATE-----

END
cat > /etc/openvpn/crl.pem <<-END
-----BEGIN X509 CRL-----
MIHrMIGTAgEBMAoGCCqGSM49BAMCMBcxFTATBgNVBAMMDGplcm9tZWxhbGlhZxcN
MTkxMTAxMDc1MDEwWhcNMjkxMDI5MDc1MDEwWqBLMEkwRwYDVR0jBEAwPoAUleKG
k73dSMJvGQB58UE7yXjFviuhG6QZMBcxFTATBgNVBAMMDGplcm9tZWxhbGlhZ4IJ
AMwxNnqzf5hxMAoGCCqGSM49BAMCA0cAMEQCIFVhEmRNepS8dVlSjCSpR7312HCn
iNSruliDWnKkytbPAiAVhO4fjumH+XOdlMGeDT9iIOB36mIlOkTJF9b28RKXng==
-----END X509 CRL-----

END
cat > /etc/openvpn/server.crt <<-END
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number:
            09:19:b9:24:66:46:b1:66:14:f0:72:31:0b:25:f7:db
    Signature Algorithm: ecdsa-with-SHA256
        Issuer: CN=jeromelaliag
        Validity
            Not Before: Nov  1 07:50:10 2019 GMT
            Not After : Oct 29 07:50:10 2029 GMT
        Subject: CN=jeromelaliag
        Subject Public Key Info:
            Public Key Algorithm: id-ecPublicKey
                Public-Key: (256 bit)
                pub: 
                    04:16:26:9e:a9:45:57:9c:be:90:7c:36:b2:fa:9f:
                    fb:a0:04:2d:c1:e7:04:36:cf:c5:9a:0f:f8:0c:15:
                    9c:f4:84:19:c7:e9:55:81:61:e4:1c:a4:1f:d9:a0:
                    f0:ca:ff:41:04:65:4d:59:6b:aa:84:a4:31:a9:d1:
                    a6:f0:dc:43:a9
                ASN1 OID: prime256v1
                NIST CURVE: P-256
        X509v3 extensions:
            X509v3 Basic Constraints: 
                CA:FALSE
            X509v3 Subject Key Identifier: 
                D6:20:4D:1F:EC:C4:EC:7D:9A:91:AE:36:3F:A0:B0:BB:7C:27:EE:D3
            X509v3 Authority Key Identifier: 
                keyid:95:E2:86:93:BD:DD:48:C2:6F:19:00:79:F1:41:3B:C9:78:C5:BE:2B
                DirName:/CN=jeromelaliag
                serial:CC:31:36:7A:B3:7F:98:71

            X509v3 Extended Key Usage: 
                TLS Web Server Authentication
            X509v3 Key Usage: 
                Digital Signature, Key Encipherment
            X509v3 Subject Alternative Name: 
                DNS:jeromelaliag
    Signature Algorithm: ecdsa-with-SHA256
         30:45:02:21:00:9a:ae:2f:c3:76:ac:78:9b:e3:79:93:e1:b3:
         ad:26:13:40:98:15:a6:6d:ba:a1:96:cc:5d:5a:03:33:5c:cf:
         e9:02:20:57:e8:61:3e:05:c9:c6:e1:fd:f2:c0:cd:47:5c:50:
         cb:5a:0e:79:01:a8:4f:63:2f:0b:22:b2:02:6a:8a:c5:8e
-----BEGIN CERTIFICATE-----
MIIB3jCCAYSgAwIBAgIQCRm5JGZGsWYU8HIxCyX32zAKBggqhkjOPQQDAjAXMRUw
EwYDVQQDDAxqZXJvbWVsYWxpYWcwHhcNMTkxMTAxMDc1MDEwWhcNMjkxMDI5MDc1
MDEwWjAXMRUwEwYDVQQDDAxqZXJvbWVsYWxpYWcwWTATBgcqhkjOPQIBBggqhkjO
PQMBBwNCAAQWJp6pRVecvpB8NrL6n/ugBC3B5wQ2z8WaD/gMFZz0hBnH6VWBYeQc
pB/ZoPDK/0EEZU1Za6qEpDGp0abw3EOpo4GxMIGuMAkGA1UdEwQCMAAwHQYDVR0O
BBYEFNYgTR/sxOx9mpGuNj+gsLt8J+7TMEcGA1UdIwRAMD6AFJXihpO93UjCbxkA
efFBO8l4xb4roRukGTAXMRUwEwYDVQQDDAxqZXJvbWVsYWxpYWeCCQDMMTZ6s3+Y
cTATBgNVHSUEDDAKBggrBgEFBQcDATALBgNVHQ8EBAMCBaAwFwYDVR0RBBAwDoIM
amVyb21lbGFsaWFnMAoGCCqGSM49BAMCA0gAMEUCIQCari/Ddqx4m+N5k+GzrSYT
QJgVpm26oZbMXVoDM1zP6QIgV+hhPgXJxuH98sDNR1xQy1oOeQGoT2MvCyKyAmqK
xY4=
-----END CERTIFICATE-----

END
cat > /etc/openvpn/server.key <<-END
-----BEGIN PRIVATE KEY-----
MIGHAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBG0wawIBAQQgnD6ovb/vyYsdARFN
eyp4QKd+mN26DTaqpI7noNIJbeehRANCAAQWJp6pRVecvpB8NrL6n/ugBC3B5wQ2
z8WaD/gMFZz0hBnH6VWBYeQcpB/ZoPDK/0EEZU1Za6qEpDGp0abw3EOp
-----END PRIVATE KEY-----

END
cat > /etc/openvpn/tls-crypt.key <<-END
#
# 2048 bit OpenVPN static key
#
-----BEGIN OpenVPN Static key V1-----
945dd8355bf77ca1a5d13b6ca1a83ba7
d289338c5b6b3ae01a757741236b7ac7
dc51540a082f622afcca8ab63bc8cedb
e38978da6ba4da796aa93125ca319546
a3cec71c7407baa182a1e764f2dbda3a
d2b0f6aa2bcc7d83e5c89830414d90c1
7b8d3076512861ece9e08b9325c7b7f7
b64ffa9bb7f294731bd098076262fb31
5ef50d9f439d2eacb89b462cef97c34c
c3b5b2585003eaae2c6a88dd55a5ba9e
b05ce33b48bbe47703ca3bb3d0febd7c
f9a90018cbb63eb6f2678fa7169caac1
922fa5e26d76b1e1c0a762e7e0572841
89e86cdeaab657bb3a5a8d33d168c28f
12a5de0b41fb1a87484596f5bc440342
8a819b0cb1983c8dadea3a5faf42330a
-----END OpenVPN Static key V1-----

END
mkdir /var/www/html/ovpn/
cat > /var/www/html/ovpn/default.ovpn <<-END
client
dev tun
proto tcp-client
remote $(wget -qO- ipv4.icanhazip.com) 853
auth-user-pass
verb 3
auth none
cipher none
verify-x509-name jeromelaliag name
tls-client
tls-version-min 1.2
tls-cipher TLS-ECDHE-ECDSA-WITH-AES-128-GCM-SHA256
<ca>
$(cat /etc/openvpn/ca.crt)
</ca>
<tls-crypt>
$(cat /etc/openvpn/tls-crypt.key)
</tls-crypt>
END
cat > /var/www/html/ovpn/sunnoload.ovpn <<-END
client
dev tun
proto tcp-client
remote $(wget -qO- ipv4.icanhazip.com) 853
bind
float
lport 110
auth-user-pass
verb 3
auth none
cipher none
verify-x509-name jeromelaliag name
tls-client
tls-version-min 1.2
tls-cipher TLS-ECDHE-ECDSA-WITH-AES-128-GCM-SHA256
connect-retry 0 1
<ca>
$(cat /etc/openvpn/ca.crt)
</ca>
<tls-crypt>
$(cat /etc/openvpn/tls-crypt.key)
</tls-crypt>
END
cat > /usr/bin/vpnuseradd <<-END
#!/bin/sh
if [ -z "\$2" ];
then
echo "vpnuseradd <days> <username>"
else
useradd -s /bin/false -e \`date +%F -d "+\$1 days"\` \$2 > /dev/null 2>&1
echo Expiration: \`date "+%m/%d/%Y @ %T" -d "+\$1 days"\`
echo Username: \$2
passwd \$2
fi
END
chmod 775 /usr/bin/vpnuseradd
cat > /usr/bin/vpnuserlist <<-END
#!/bin/sh
if [ -z \$1 ]; then
for p in \$(awk -F: '{print \$1}' /etc/passwd); do chage -l \$p | echo \$p -\$(grep Account\ expires | sed 's/Account expires//g'); done | sed '/: never/d' | sed 's/\: //g'
else
chage -l \$1 | echo \$1 -\$(grep Account\ expires | sed 's/Account expires//g') | sed 's/\: //g'
fi
END
chmod 775 /usr/bin/vpnuserlist
clear
echo Install finish!
echo OpenVPN Configuration Download Link
echo "http://$(wget -qO- ipv4.icanhazip.com)/ovpn/"
echo
echo Rebooting...
reboot
