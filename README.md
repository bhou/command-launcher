# Command Launcher

A command launcher 🚀 made with ❤️

## Why a command launcher?

At Criteo, we have many teams who provides command line applications for developers. These CLI providers repeatly handle the same features and functionalities for their CLI apps, such as auto-completion, credential management, release, delivery, monitoring, etc.

On developer side, they have to manually download these tools to keep them up-to-date, and it is difficult for them to discover available tools.

To improve both developer and CLI provider's experience, we developed a command launcher to solve the above issues. It has built-in features like auto-completion, credential management, progressive roll-out, and monitoring, so that the CLI app provider can focus on the functionality of their CLI app. Developers only need to download the command launcher to access all CLI apps. The command launcher will keep their CLI application up-to-date.

## How it works?

Command launcher is a small binary downloaded by developer in their development environment. CLI provider packages new commands or new version of command into a package, upload it to a remote repository, and update the package index of the repository. This process can be automated. More details about the remote repository, see [CLI Provider Guide](doc/CLI_PROVIDER_GUIDE.md)

Developers run command launcher to access these commands, for example, you have a command called `toto`, instead of run it directly from command line, you use `cl toto`, where `cl` is the binary name of the command launcher, you can name it anything suits you. Every time you execute command launcher, it will synchronize with the remote command, and propose available updates if exists.

```

         ┌──────────────────┐        Synch         ┌───────────────────────────┐
         │ command launcher │◄─────────────────────│ Remote Command Repository │
         └──────────────────┘                      └───────────────────────────┘
                  │                                               │
       ┌──────────┼──────────┐                       ┌────────────┼────────────┐
       ▼          ▼          ▼                       ▼            ▼            ▼
   ┌───────┐  ┌───────┐  ┌───────┐              ┌─────────┐  ┌─────────┐  ┌─────────┐
   │ cmd A │  │ cmd B │  │ cmd C │              │  cmd A  │  │  cmd B  │  │  cmd C  │
   └───────┘  └───────┘  └───────┘              └─────────┘  └─────────┘  └─────────┘
```

## Features

- **Small footprint**. Command launcher is around 10M, with no dependency to your OS.
- **Technology agnostic**. It can launch commands implemented in any technology, and integrate to it with a simple manifest file.
- **Auto-completion**. It supports auto-completion for all your commands installed by it.
- **Auto-update**. Not only keeps itself but all its commands up-to-date.
- **Credential management**. With the built-in login command, it securely passes user credential to your command.
- **Progressive rollout**. Target a new version of command to a group of beta test users, and rollout progressively to all your users.
- **Monitoring**. Built-in monitoring feature to monitor the usage your commands.

## Installation

Pre-built binary can be downloaded from the release page. Unzip it, copy the binary into your PATH.

The pre-built binary is named `cdt` (Criteo Dev Toolkit), if you want to use a different name, you can pass your prefered name in the build. See build section below.

## Build

Requirements: golang >= 1.17

You can build the command launcher with your prefered name (in the example: `Criteo Developer Toolkit`, a.k.a `cdt`).
```
go build -o cdt -ldflags='-X main.version=dev -X main.binaryName=cdt' main.go
```

## Run tests

```
go test -v ./...
```


### Release

Simply tag a commit with format 'x.y.z', and push it.

```
git tag x.y.z
git push origin x.y.z
```

The supported release tag format:

- \*.\*.\*
- \*.\*.\*-\*

Example: `1.0.0`, `1.0.1-preview`
