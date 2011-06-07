Description
===========

Generates a Java Key Store with default JVM CA certificates and a certificate signed by a Microsoft CA Server

Requirements
============

* Microsoft Active Directory Certificate Services
* User with access to Active Directory Certificate Services

Attributes
==========

* subject: X509 Certificate Subject e.g. "CN=example.example.com, OU=Example, O=Example, L=Atlanta, ST=GA, C=US", defaults to name_attribute
* cn_alias: Name of the key to be created for the Subject e.g. "example"
* ca_url: Full URL to Microsoft Active Directory Certificate Services "https://example.example.com/certsrv/"
* ca_user: User with access to Microsoft Active Directory Certificate Services
* ca_pass: ca_user's password
* store_pass: Password to be set on the newly created keystore e.g. "changeit"
* user_agent: Identification String used to convince Active Directory
  Certificate Services that the provider is a web browser e.g. for IE9 "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)"
* jks_path: Fully qualified path and name of the JKS file to be created or modified

Usage
=====
Create a data bag - in this case example data bag "zw" has been created with item "ca"

The contents of the "ca" item are as follows:

```json
{
  "id": "ca",
  "ca_url": "https://example.example.com/certsrv/",
  "ca_user": "ficticious_user",
  "cn_pass": "ficticious_password",
  "store_pass": "ficiticious_password",
  "user_agent": "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)"
}
```

The "ca" item is loaded from the "zw" data bag

```ruby
ca = Chef::EncryptedDataBagItem.load("zw", "ca")

zw_jks_keystore "CN=example.example.com, OU=Example, O=Example, L=Atlanta, ST=GA, C=US" do
  cn_alias "example"
  ca_url ca['ca_url']
  ca_user ca['ca_user']
  ca_pass ca['ca_pass']
  store_pass ca['store_pass']
  user_agent ca['user_agent']
  jks_path "/srv"
  action :create
  provider "zw_jks_keystore"
end
```
