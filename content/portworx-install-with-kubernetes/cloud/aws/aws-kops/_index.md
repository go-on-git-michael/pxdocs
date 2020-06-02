---
title: Kubernetes Operations (KOPS)
keywords: portworx, container, Kubernetes, storage, Docker, k8s, KOPS, pv, persistent disk, aws, EBS
description: Install Portworx on a Kubernetes KOPS cluster running on AWS.
weight: 3
noicon: true
series: px-k8s
---

This topic explains how to install Portworx with Kubernetes on AWS (KOPS). Follow the steps in this topic in order.

## Prepare

For information on using KOPS, go [here](https://aws.amazon.com/blogs/compute/kubernetes-clusters-aws-kops/) and [here](https://github.com/kubernetes/kops/blob/master/docs/getting_started/aws.md).

{{% content "portworx-install-with-kubernetes/cloud/aws/shared/1-prepare.md" %}}

## Install

{{<info>}}
If you are not using instance privileges, you must also specify AWS environment variables in the DaemonSet spec file. The environment variables to specify \(for the KOPS IAM user\) are:

`AWS_ACCESS_KEY_ID=<id>,AWS_SECRET_ACCESS_KEY=<key>`

If generating the DaemonSet spec via the GUI wizard, specify the AWS environment variables in the **List of environment variables** field. If generating the DaemonSet spec via the command line, specify the AWS environment variables using the `e` parameter.
{{</info>}}

{{% content "portworx-install-with-kubernetes/shared/1-generate-the-spec-footer.md" %}}

{{% content "portworx-install-with-kubernetes/shared/4-apply-the-spec.md" %}}