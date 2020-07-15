---
title: Portworx Licensing
keywords: Licensing, Portworx Enterprise, px-developer, requirements, Portworx features, trial period, upgrade Portworx, activate license, transfer license
description: Find out more about the Portworx licensing model.
series: kb
weight: 4
---

## Introduction

Starting with the v1.2.8 release, the Portworx products support the following license types:

|      License type      |  Description
|:-----------------------|:-------------------------------------------------------------------------------------------------------------------------------
| Portworx Developer           | Embedded into [px-developer](/install-with-other/docker/standalone/px-developer), free license that supports select functionality.
| Trial                  | Automatically installed with [{{< pxEnterprise >}}](/), enables functionality for 30 days.
| {{< pxEnterprise >}} VM       | Enterprise license, suitable for Virtual Machine (VM) installs on-prem and in cloud
| {{< pxEnterprise >}} Metal    | Enterprise license, suitable for installs on any bare metal hardware


Depending on the type of the container you are installing, a different license will be automatically activated:

* [px-developer](/install-with-other/docker/standalone/px-developer) container activates free PX-Developer license, and
* [{{< pxEnterprise >}}](/) automatically
activates the Trial license (limited to 30 days), which can be upgraded to a {{< pxEnterprise >}} license at any time.

## Checking your License

A brief license summary is provided with the `pxctl status` command:

```text
pxctl status
```

```output
Status: PX is operational
License: Trial license (expires in 30 days)
 [...]
```

More details about each individual licensed feature is displayed via `pxctl license list` command, ie.:

```text
pxctl license list
```

```output
DESCRIPTION                  ENABLEMENT  ADDITIONAL INFO
Number of nodes maximum         1000
Number of volumes maximum       1024 [...]
Virtual machine hosts            yes
Product SKU                     Trial    expires in 30 days
```

{{<info>}}
7 days before your Portworx license is set to expire, an alert will trigger saying that your license is getting ready to expire. The alert will tell you how long you have to renew your license. Note that the alert will also keep triggering after the license has expired. For more details, see [this page](/install-with-other/operate-and-maintain/monitoring/portworx-alerts#list-of-alerts).
{{</info>}}

## Licensed features

In the table below, we can see the overview of features that are controlled via licensing as of Portworx v1.2.8.

|       Description            |  Type  | Details
|:-----------------------------|:------:|:------------------------------------------------------------------------------------
| Number of nodes maximum      | number | Defines the maximum number of nodes in a cluster
| Number of volumes maximum    | number | Defines max number of volues on a single node
| Volume capacity [TB] maximum | number | Defines max size of a single volume
| Storage aggregation          | yes/no | Defines if volumes may be aggregated across multiple nodes
| Shared volumes               | yes/no | Defines if volumes may be shared w/ other nodes
| Volume sets                  | yes/no | Defines if volumes may be scaled
| BYOK data encryption         | yes/no | Defines if volumes may be encrypted
| Resize volumes on demand     | yes/no | Defines if volumes can be resized
| Snapshot to object store     | yes/no | Defines if volumes may be snapshotted to Amazon S3, MS Azure and Google storage
| Cluster level migration      | yes/no | Defines if applications and data (using K8s namespace) can be migrated between paired clusters
| Disaster Recovery (PX-DR)[Add-on]    | yes/no | Enables synchronous and asynchronous DR features (requires 2.1 or later, needs additional license)
| Virtual machine hosts        | yes/no | Software may be deployed on VMs (including Amazon EC2, OpenStack Nova, etc...)
| Bare-metal hosts             | yes/no | Software may be deployed on commodity hardware


## Type of Licenses

### PX-Developer License

The PX-Developer license is a default license for [px-developer](/install-with-other/docker/standalone/px-developer) containers.
The PX-Developer license is permanent and free, and provides a select set of functionality.
It supports the following features:

```text
pxctl license list
```

```output
DESCRIPTION                  ENABLEMENT    ADDITIONAL INFO
Number of nodes maximum             3
Number of volumes maximum         256
Volume capacity [TB] maximum        1
Storage aggregation                no      feature upgrade needed
Shared volumes                    yes
Volume sets                       yes
BYOK data encryption               no      feature upgrade needed
Resize volumes on demand           no      feature upgrade needed
Snapshot to object store           no      feature upgrade needed
Bare-metal hosts                  yes
Virtual machine hosts             yes
Product SKU                  PX-Developer  permanent
```


### Trial License

The Trial license activates automatically when the [{{< pxEnterprise >}}](/) license is installed.
The trial license provides the full product functionality for 30 days.

```
DESCRIPTION                  ENABLEMENT  ADDITIONAL INFO
Number of nodes maximum         1000
Number of volumes maximum       1024
Volume capacity [TB] maximum      40
Storage aggregation              yes
Shared volumes                   yes
Volume sets                      yes
BYOK data encryption             yes
Resize volumes on demand         yes
Snapshot to object store         yes
Bare-metal hosts                 yes
Virtual machine hosts            yes
Product SKU                     Trial    expires in 6 days, 20:40
```


#### EXPIRATION

When the trial period expires, one will no longer be able to create new volumes or volume snapshots.
The normal functionality may be restored at any time, by purchasing and installing the {{< pxEnterprise >}} license.

#### UPGRADE NOTES

* The Trial license can be upgraded into a {{< pxEnterprise >}} license by contacting
support@portworx.com, and activating via the activation code or via the
license file (see [{{< pxEnterprise >}}](#px-enterprise-license) below for details)
* The Trial license itself cannot be upgraded or extended with another Trial, or downgraded into PX-Developer license.


### {{< pxEnterprise >}} License

The {{< pxEnterprise >}} license is our most flexible license, which comes with a number of options.
Please reach out to support@portworx.com  to determine which type of {{< pxEnterprise >}} license will work best for your needs.

#### License sharing

Once installed, the {{< pxEnterprise >}} license is locked to a single Portworx cluster via the unique UUID identifier of the cluster.
Such license (or, license-file) will not work on other clusters.


#### Installation

The easiest way to install the {{< pxEnterprise >}} license, is via the
 "Activation ID" (reach out to us at support@portworx.com for purchasing licenses), ie:

```text
pxctl license activate c0ffe-fefe-activation-123
```

Note that the license activation process will require active Internet connection from the Portworx nodes to the license server,
as the activation process automatically registers the cluster UUID, generates and installs the license on the cluster.
Upon activating the license on one Portworx node, all remaining Portworx nodes will automatically update to the new license.

#### Install on air-gapped environments

If you're running Portworx in an air-gapped environment, contact Portworx, Inc.'s support team at support@portworx.com. Note that you will follow a slightly different process.

Customers will be asked to provide the `Cluster UUID` information (available via `pxctl cluster list` command):

```text
pxctl cluster list
```

```output
Cluster ID: MY_FAVORITE_PX_CLUSTER
Cluster UUID: f987ad4b-987c-4e7e-a8bd-788c89cc40f1
Status: OK [...]
```

Upon supplying the "Cluster UUID", the customers will get their license file.
The license file will need to be uploaded to one of the Portworx nodes, and activated via the following command:

```text
pxctl license add license_file.bin
```

Finally, please note that the license installation is a non-obtrusive process, which will not interfere with the data stored
on the Portworx volumes, nor will it interrupt the active IO operations.

#### License transfer

From {{< pxEnterprise >}} 1.4.0 onwards, a valid enterprise license can be transferred between two Portworx clusters. Both Portworx clusters need to be operational at the time of license transfer.
The source cluster must have a valid {{< pxEnterprise >}} license, while the destination cluster can have either a valid or expired Trial license, PX-Developer, or expired {{< pxEnterprise >}} license.

License transfer command requires 'clusterUUID' from the source cluster, (available via `pxctl cluster list` command) and remote Portworx cluster node IP.

```text
pxctl license transfer -h
```

```output
NAME:
   pxctl license transfer - Transfer license to remote PX cluster

USAGE:
   pxctl license transfer <clusterUUID> <remoteIP>

DESCRIPTION:
   Command swaps licenses between the two Portworx clusters.

   Note that both Portworx clusters need to be operational at the time this
   command is ran.
   The source cluster must have a valid {{< pxEnterprise >}} license, while the
   destination cluster can have either a valid or expired Trial license,
   PX-Developer, or expired {{< pxEnterprise >}} license.

EXAMPLE:
   pxctl license transfer f91531d9-bf65-46f5-9619-eb99128e3270 10.0.15.201
```

{{<info>}}
* The license transfer happens directly between the Portworx clusters, so at least one node from source cluster must have a network connectivity to a node in the target Portworx cluster.
* After the successful license transfer, the two Portworx clusters will have swapped identities, and licenses (for example, Portworx cluster A will have Trial license originally from Portworx cluster B, while the cluster B will have the {{< pxEnterprise >}} license originally from cluster A)
{{</info>}}

For information on purchase, upgrades and support, please reach out to us at support@portworx.com
