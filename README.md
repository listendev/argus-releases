## Introduction

Welcome to Argus project! Argus is a runtime security tool capable of not only monitoring,
but also enforcing application behavior. It is designed to be lightweight, efficient, and
easy to use. Argus is a powerful tool that can be used to monitor and enforce security
policies in real-time, providing a high level of protection for your applications.

This is the public repository, containing the released binaries, packages and images.

## Why Argus is special ?

1. Made by a **team of experts**, including **former Tracee and Falco core engineers**.
2. Differently than other similar projects, Argus can deal with **any type of workload**.
3. No events, **no losses**. No events, **no delays**.
4. No performance impact, tiny memory footprint.
5. Easy to use.

## eBPF Loader and Argus Extension

### eBPF Loader

- There is a single eBPF loader that contains extensions easily added to the build tree.
- There are multiple extensions providing different application like functionalities.
- Each extension can have multiple plugins providing different features.

### Argus Extension

- The Argus extension is the main extension of the Argus project and why it was created.
- It has many `normal` and `test` plugins.
- The `test` plugins work like regular plugins but provide pass/fail tests.
- The `normal` plugins are the ones that provide the real functionality.
- Argus extension has `libraries` to talk to eBPF programs and to the kernel.
- Argus provides a `github` plugin that is used to interact with the ListenDev API.
- The `github` plugin defines 2 events: `simpleflow` and `completeflow`.
- The `simpleflow` event is used to send network flows information to the ListenDev API.
- The `completeflow` has more information than `simpleflow` and serves the same purpose.
- The `github` plugin defines 2 printers: `listendev` and `listendevdebug`.
- The `listendev` printer is used to send data to the ListenDev API.
- The `listendevdebug` printer is used to send same data as JSON to a file.

## How do I try it ?

[https://dashboard.listen.dev/](https://dashboard.listen.dev/)

> Argus is the tool in charge of [https://www.listen.dev/](https://www.listen.dev/)
> dynamic runtime analysis feature.

## Documentation

Being finished.

## How do I report bugs ?

[https://github.com/listendev/argus-releases/issues](https://github.com/listendev/argus-releases/issues)

## Mythology

In Greek mythology, Argus Panoptes, or simply Argus, is a fascinating and unique character
renowned for his hundred eyes. According to myth, Argus was a giant, an all-seeing
guardian, making him an ideal watchman. His most famous tale involves being appointed by
Hera, the queen of the gods, to guard the white heifer Io, who was actually Zeus' lover
transformed into a cow to escape Hera's wrath. Argus' ability to have some of his eyes
sleep while others remained awake made him a nearly impenetrable guardian. Argus' story
intertwines themes of vigilance, loyalty, and the intricate dynamics of the divine in
Greek mythology.
