---
title: Google Cloud KMS
logo: /logos/google-kms.png
weight: 6
keywords: Google Cloud KMS, Key Management Service, gcloud, secrets, Volume Encryption, Cloud Credentials
description: Instructions on using Google Cloud KMS with Portworx
disableprevnext: true
noicon: true
series: key-management
---


{{<info>}}
**NOTE:** Supported from {{< pxEnterprise >}} 2.0.2 onwards
{{</info>}}

Portworx integrates with Google Cloud KMS to store your Portworx secrets for Volume Encryption and Cloud Credentials. This guide will help configure Portworx with Google Cloud KMS.

Portworx requires the following Google Cloud credentials to use its APIs

- **Google Application Credentials [GOOGLE_APPLICATION_CREDENTIALS]**

    Portworx requires permissions to use Google CloudKMS APIs. It requires the following two predefined roles
    - roles/cloudkms.cryptoKeyEncrypterDecrypter
    - roles/cloudkms.publicKeyViewer

    More info about these roles and the included permissions can be found [here](https://cloud.google.com/kms/docs/reference/permissions-and-roles#predefined_roles)

- **Google KMS Public Key Resource ID [GOOGLE_KMS_RESOURCE_ID]**

    Portworx uses Google's asymmetric key pairs to encrypt and decrypt secrets. More information about asymmetric key pairs and how to create them can be found [here](https://cloud.google.com/kms/docs/creating-asymmetric-keys)

    Make sure that while creating the asymmetric key you specify the *purpose* of the key as *Asymmetric decrypt*

    Once the asymmetric key is created, provide its complete resourceID to Portworx. A typical asymmetric key pair's resource ID looks like this
    ```
    projects/<Project ID>/locations/<Region>/keyRings/<Key Ring Name>/cryptoKeys/<Asymmetric Key Name>/cryptoKeyVersions/1
    ```
    Portworx requires the above resource ID as an input argument.

## For Kubernetes Users

Provide the Google credentials to Portworx by using any one of these methods

### Google instance IAM roles (Recommended)

{{% content "shared/gce/instance-role.md" %}}

### Google Service Accounts

#### Step 1: Create a service account

{{% content "shared/gce/service-account.md" %}}

#### Step 2: Create a Kubernetes secret for the Google credentials.

Copy the downloaded account file in a directory `gcloud-secrets/` and rename it `gcloud.json` to create a Kubernetes secret from it.

```text
ls -1 gcloud-secrets
```

```output
gcloud.json
```

Create a kubernetes secret with the following command

```text
 kubectl -n kube-system create secret generic px-gcloud --from-file=gcloud-secrets/ --from-literal=gcloud-kms-resource-id=projects/<Project ID>/locations/<Region>/keyRings/<Key Ring Name>/cryptoKeys/<Asymmetric Key Name>/cryptoKeyVersions/1
```

Make sure to replace the `Project ID`, `Key Ring Name` and `Asymmetric Key Name` in the above command.

#### Step 3: Update the Portworx DaemonSet

- **New installation**

When generating the Portworx Kubernetes spec file on the Portworx spec generator page in [PX-Central](https://central.portworx.com)), select `Google Cloud KMS` from the "Secrets type" list.

- **Existing installation**

For an existing Portworx cluster follow these steps:

##### Step 3a: Update the Portworx DaemonSet to use the Google KMS secret store

Edit the Portworx DaemonSet's `secret_type` field to `gcloud-kms`, so that all the new Portworx nodes will also start using Google Cloud KMS.

```text
kubectl edit daemonset portworx -n kube-system
```

Add the `"-secret_type", "gcloud-kms"` arguments to the `portworx` container in the daemonset. It should look something like this:

```text
containers:
  - args:
    - -c
    - testclusterid
    - -s
    - /dev/sdb
    - -x
    - kubernetes
    - -secret_type
    - gcloud-kms
    name: portworx
```

##### Step 3b: Patch the Portworx DaemonSet

Use the following command to patch the daemon set, so that it has access to the secret created Step 2

Create a patch file

```text
cat <<EOF> patch.yaml
spec:
  template:
    spec:
      containers:
      - name: portworx
        env:
          - name: GOOGLE_KMS_RESOURCE_ID
            valueFrom:
              secretKeyRef:
                name: px-gcloud
                key: gcloud-kms-resource-id
          - name: GOOGLE_APPLICATION_CREDENTIALS
            value: /etc/pwx/gce/gcloud.json
        volumeMounts:
          - mountPath: /etc/pwx/gce
            name: gcloud-certs
      volumes:
        - name: gcloud-certs
          secret:
            secretName: px-gcloud
            items:
              - key: gcloud.json
                path: gcloud.json
EOF
```

Apply the patch

```text
kubectl -n kube-system patch ds portworx --patch "$(cat patch.yaml)" --type=strategic
```

## Other users

### Step 1: Provide Google Cloud credentials to Portworx

Provide the following Google Cloud credentials (key value pairs) as environment variables to Portworx

- [Required] GOOGLE_APPLICATION_CREDENTIALS=[/path/to/service/account file]
- [Required] GOOGLE_KMS_RESOURCE_ID=[asymmetric_resource_id]

{{<info>}}
**Important:**
The service account file needs to be present on all the nodes where Portworx is running.
{{</info>}}

### Step 2: Set up Google Cloud KMS as the secrets provider for Portworx.

#### New installation

While installing Portworx set the input argument `-secret_type` to `gcloud-kms`.

#### Existing installation

Based on your installation method provide the `-secret_type gcloud-kms` input argument and restart Portworx on all the nodes.

## Using Google Cloud KMS with Portworx

{{<homelist series="gcloud-secret-uses">}}
