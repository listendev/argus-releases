# Introduction

Welcome to Argus project! Argus is a runtime security tool capable of not only monitoring, but also enforcing application behavior. It is designed to be lightweight, efficient, and easy to use. Argus is a powerful tool that can be used to monitor and enforce security policies in real-time, providing a high level of protection for your applications.

## Why Argus is special ?

1. Made by a **team of experts**, including **former Tracee and Falco core engineers**.
2. Differently than other similar projects, Argus can deal with **any type of workload**.
3. No events, **no losses**. No events, **no delays**.
4. No performance impact, tiny memory footprint.
5. Easy to use.

Read about the [theory](https://listendev.github.io/argus/dev/overview/theory/) and [history](https://listendev.github.io/argus/dev/overview/history/) behind it.

## eBPF Loader and Argus Extension

### eBPF Loader

- There is a single eBPF loader that contains extensions easily added to the build tree.
- There are multiple extensions providing different application like functionalities.
- Each extension can have multiple plugins providing different features.

### Argus Extension

- The Argus extension is the main extension of the Argus project and why it was created.
- Argus extension has **libraries** to talk to eBPF programs and to the kernel.
- Argus works with plugins like `config`, `simple`, `procfs`, `netflows` and `detections`.
- Both `config` and `simple` plugins are for internal use.
- The `github` plugin is used to interact with the ListenDev API.
- The `simple` plugin provides a stdout printer (beautified events).
- The `netflows` provides an event called `netflow` (tasks network flows).
- The `detections` plugin provides many different events related to security detections.

## How to try it

### Locally

Best way to try argus out, for now, is to use the provided docker container image, like described below, and check the stdout file (`/var/log/argus/argus.log`) for the detections output.

```shell
curl -s https://listendev.github.io/argus/dev/argus.sh | sh
```

### GitHub Integration

You can also give it a try (as an action) with the GitHub integration support at:

[https://dashboard.listen.dev/](https://dashboard.listen.dev/)

> Argus is the tool in charge of [https://www.listen.dev/](https://www.listen.dev/) dynamic runtime analysis feature.

## Documentation

[https://listendev.github.io/argus/dev](https://listendev.github.io/argus/dev)

## How do I report bugs ?

[https://github.com/listendev/argus-releases/issues](https://github.com/listendev/argus-releases/issues)

## Mythology

In Greek mythology, Argus Panoptes, or simply Argus, is a fascinating and unique character renowned for his hundred eyes. According to myth, Argus was a giant, an all-seeing guardian, making him an ideal watchman. His most famous tale involves being appointed by Hera, the queen of the gods, to guard the white heifer Io, who was actually Zeus' lover transformed into a cow to escape Hera's wrath. Argus' ability to have some of his eyes sleep while others remained awake made him a nearly impenetrable guardian. Argus' story intertwines themes of vigilance, loyalty, and the intricate dynamics of the divine in Greek mythology.
