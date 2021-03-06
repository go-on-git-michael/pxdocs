---
title: All other
linkTitle: All other
weight: 3
logo: /logos/other.png
keywords: Install, on-premise, kubernetes, k8s, air gapped
description: How to install Portworx with Kubernetes
noicon: true
series2: k8s-airgapped
---

This topic explains how to install Portworx with Kubernetes.

## Install

{{<info>}}**Airgapped clusters**: If your nodes are airgapped and don't have access to common internet registries, first follow [Airgapped clusters](/portworx-install-with-kubernetes/on-premise/airgapped) to fetch Portworx images.{{</info>}}

{{% content "shared/portworx-install-with-kubernetes-shared-1-generate-the-spec-footer.md" %}}

{{% content "shared/portworx-install-with-kubernetes-4-apply-the-spec.md" %}}

{{% content "shared/portworx-install-with-kubernetes-post-install.md" %}}

## Related topics

* Refer to the [Advanced installation parameters](/portworx-install-with-kubernetes/operate-and-maintain-on-kubernetes/other-operations/advanced-installation-parameters/) page for details about how to specify advanced installation parameters.
