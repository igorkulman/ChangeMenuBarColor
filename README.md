<h1 align="center"><a id="user-content-change-menu-bar-color-in-macos-big-sur" class="anchor" aria-hidden="true" href="#localization-editor"><svg class="octicon octicon-link" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path fill-rule="evenodd" d="M7.775 3.275a.75.75 0 001.06 1.06l1.25-1.25a2 2 0 112.83 2.83l-2.5 2.5a2 2 0 01-2.83 0 .75.75 0 00-1.06 1.06 3.5 3.5 0 004.95 0l2.5-2.5a3.5 3.5 0 00-4.95-4.95l-1.25 1.25zm-4.69 9.64a2 2 0 010-2.83l2.5-2.5a2 2 0 012.83 0 .75.75 0 001.06-1.06 3.5 3.5 0 00-4.95 0l-2.5 2.5a3.5 3.5 0 004.95 4.95l1.25-1.25a.75.75 0 00-1.06-1.06l-1.25 1.25a2 2 0 01-2.83 0z"></path></svg></a>Change menu bar color in macOS Big Sur</h1>

<p align="center">
   <a href="https://opensource.org/licenses/MIT">
        <img src="https://camo.githubusercontent.com/78f47a09877ba9d28da1887a93e5c3bc2efb309c1e910eb21135becd2998238a/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f4c6963656e73652d4d49542d79656c6c6f772e737667" alt="License: MIT" />
    </a>
   <a href="https://camo.githubusercontent.com/e948575bb276fa2ffac99e1491d13e1ad8e28d7cc5e17153d3ea5bfa8b9784a6/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f706c6174666f726d2d6d61634f532d6c69676874677265792e737667">
        <img src="https://camo.githubusercontent.com/e948575bb276fa2ffac99e1491d13e1ad8e28d7cc5e17153d3ea5bfa8b9784a6/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f706c6174666f726d2d6d61634f532d6c69676874677265792e737667" alt="Platforms" />
    </a>
    <a href="https://developer.apple.com/swift">
        <img src="https://img.shields.io/badge/Swift-5.2-F16D39.svg?style=flat" alt="Swift Version" />
    </a>
    <a href="https://twitter.com/igorkulman">
        <img src="https://img.shields.io/badge/twitter-@igorkulman-blue.svg" alt="Twitter: @igorkulman" />
    </a>
  <a href="https://www.buymeacoffee.com/igorkulman" target="_blank"><img height="21" src="https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png" alt="Buy Me A Coffee"></a>
</p>

Simple utility to change macOS Big Sur menu bar color by appending a colored rectangle to a wallpaper image.

## Motivation

Big Sur changed the way the menu bar is displayed. It now adopts the color of the wallpaper, which may not always be what you would like. This utility allows you to specify the color of the menu bar you want to use.

### Example

Imagine you have a dark wallpaper. This dark wallpaper results in the menu bar being black even though you use the Light mode

![](Screenshots/Dark.png)

With this utility you can generate a new wallpaper that makes the menu bar being shown in any color you want, like a nice tone of gray from Catalina.

![](Screenshots/Adjusted.png)

## Usage

### Binary release

Download the latest published release and unzip the `ChangeMenuBarColor.zip` file. It will create a `ChangeMenuBarColor` executable file.

Navigate o the directory with `ChangeMenuBarColor` and run

```bash
./ChangeMenuBarColor "path_to_your_wallpaper" "desired_hex_color"
```

so for example

```bash
./ChangeMenuBarColor "/Users/igorkulman/wallpaper.jpg" "#CCCCCC"
```

If everything goes well the utility will create a `wallpaper-screen1-adjusted.jpg` file with you new wallpaper image that will make the menu bar be shown in the color you want. If you have multiple screens detected, it will generate a new wallpaper file for each of those screens.

### Swift Package Manager

Clone the repository

```bash
git clone https://github.com/igorkulman/ChangeMenuBarColor.git
```
enter it

```bash
cd ChangeMenuBarColor
```

and run

```bash
swift run ChangeMenuBarColor "path_to_your_wallpaper" "desired_hex_color"
```

so for example

```bash
swift run ChangeMenuBarColor "/Users/igorkulman/wallpaper.jpg" "#CCCCCC"
```

If everything goes well the utility will create a `wallpaper-screen1-adjusted.jpg` file with you new wallpaper image that will make the menu bar be shown in the color you want. If you have multiple screens detected, it will generate a new wallpaper file for each of those screens.

## Support the project

<a href="https://www.buymeacoffee.com/igorkulman" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png" alt="Buy Me A Coffee" style="height: 41px !important;width: 174px !important;box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;" ></a>

## Contributing

All contributions are welcomed!

### Development

Use `swift package generate-xcodeproj` to generate a Xcode project you can use for development.

## Author

- **Igor Kulman** - *Initial work* - igor@kulman.sk

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
