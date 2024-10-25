# To-Do List App

A simple To-Do list iOS app built with **UIKit** and **ViewCode**, following the **MVVM pattern** with **RxSwift**. The app consumes a REST API for task management. This project is for portfolio purposes and demonstrates the use of **RxSwift** in a clean architecture setup, with no commercial use intended.

<img src="readme_assets/app_functionality.gif" alt="Main Functionality Demo" width="320" />

## Table of Contents
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Architecture](#architecture)

## Features
- Add, edit, and delete to-do items
- Mark items as complete or incomplete
- Sync data with a REST API
- Reactive UI updates using RxSwift

## Installation
1. Clone the repository:
```bash
git clone git@github.com:raphacmartin/RxTodo.git
```
2. Install dependencies:
```bash
cd RxTodo
pod install
```
3. Open the project in Xcode:
```bash
open RxSwift-Study.xcworkspace
```

## Usage
- Run the app in Xcode using a compatible iOS simulator or device.
- The app fetches tasks from the API, with options to add, edit, and delete tasks in real-time.

## Architecture
This app is built with MVVM architecture, utilizing RxSwift for reactive data binding between layers. Each view is built using ViewCode (no Storyboards), ensuring flexibility and ease of maintenance.