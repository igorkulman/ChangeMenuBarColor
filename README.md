<h1 align="center"><a id="user-content-change-menu-bar-color-in-macos-big-sur" class="anchor" aria-hidden="true" href="#localization-editor"><svg class="octicon octicon-link" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path fill-rule="evenodd" d="M7.775 3.275a.75.75 0 001.06 1.06l1.25-1.25a2 2 0 112.83 2.83l-2.5 2.5a2 2 0 01-2.83 0 .75.75 0 00-1.06 1.06 3.5 3.5 0 004.95 0l2.5-2.5a3.5 3.5 0 00-4.95-4.95l-1.25 1.25zm-4.69 9.64a2 2 0 010-2.83l2.5-2.5a2 2 0 012.83 0 .75.75 0 001.06-1.06 3.5 3.5 0 00-4.95 0l-2.5 2.5a3.5 3.5 0 004.95 4.95l1.25-1.25a.75.75 0 00-1.06-1.06l-1.25 1.25a2 2 0 01-2.83 0z"></path></svg></a>Change menu bar color in macOS Big Sur and Monterey</h1>

Simple utility to change macOS Big Sur and Monterey menu bar color by appending a solid color or gradient rectangle to a wallpaper image.

## Motivation

Big Sur and Monterey changed the way the menu bar is displayed. It now adopts the color of the wallpaper, which may not always be what you would like. This utility allows you to specify the solid color or gradient of the menu bar you want to use.

### Example

Imagine you have a dark wallpaper ([here is mine](https://www.wallpaperflare.com/silhouette-of-mountain-simple-simple-background-minimalism-wallpaper-phxwd)). This dark wallpaper results in the menu bar being black even though you use the Light mode

![Default menu bar color in macOS Big Sur](Screenshots/Dark.png)

With this utility you can generate a new wallpaper that makes the menu bar being shown in any color you want, like a nice tone of gray from Catalina.

![Custom color menu bar in macOS Big Sur](Screenshots/Adjusted.png)

Or a custom gradient

![Gradient menu bar in macOS Big Sur](Screenshots/Gradient.png)

## Installation

### Mint

The easiest and preferred way to install and run the tools is with [Mint](ttps://github.com/yonaskolb/Mint).

Due to [Swift Package Manager limitations](https://forums.swift.org/t/only-command-line-tools-installed-xctest-executable-not-found/34088) you need to have [Xcode](https://apps.apple.com/us/app/xcode/id497799835?mt=12) installed and opened at least once for the installation from source code to work.

After you installed Xcode install [Mint](ttps://github.com/yonaskolb/Mint) with [Homebrew](https://brew.sh/)

```bash
brew install mint
```

Next run 

```bash
mint run igorkulman/ChangeMenuBarColor
```

and if everything is OK you can use my utility be downloaded and run for the first time. You are ready to go!

### Binary release

If you do not want to install Xcode and Mint you can download [the latest binary release](https://github.com/igorkulman/ChangeMenuBarColor/releases/latest). 

The binary release is not signed so it might not work on all systems.

## Usage

All the commands shown are for the utility being installed via Mint. If you downloaded the latest binary release replace `mint run igorkulman/ChangeMenuBarColorSolidColor` with `path/to/unzipped/ChangeMenuBarColorSolidColor`.

### Solid color

To set a new wallpaper file with a solid color rectangle that matches the menu bar, run

```bash
mint run igorkulman/ChangeMenuBarColorSolidColor "desired_hex_color" "optional_path_to_your_wallpaper" 
```

So for example

```bash
mint run igorkulman/ChangeMenuBarColor SolidColor "#CCCCCC" "/Users/igorkulman/wallpaper.jpg"
```

If you do not provide the wallpaper path

```bash
mint run igorkulman/ChangeMenuBarColor SolidColor "#CCCCCC"
```

the currently set wallpaper will be used.

### Gradient

To set a new wallpaper file with a gradient rectangle at the top, run

```bash
mint run igorkulman/ChangeMenuBarColor Gradient "start_hex_color" "end_hex_color" "optional_path_to_your_wallpaper"
```

So for example

```bash
mint run igorkulman/ChangeMenuBarColor Gradient "#FF0000" "#00FF00" "/Users/igorkulman/wallpaper.jpg"
```

If you do not provide the wallpaper path

```bash
mint run igorkulman/ChangeMenuBarColor Gradient "#FF0000" "#00FF00"
```

the currently set wallpaper will be used.

#### Multiple displays

If you use multiple displays and want the wallpaper generated for all of them, add the `--all-displays` flag at the end of the command, so for example `./ChangeMenuBarColor Gradient "#FF0000" "#00FF00" --all-displays`.

## Uninstall

- manually set any new wallpaper
- run `mint uninstall igorkulman/ChangeMenuBarColor` if you installed the utility via `mint` or delete the folder with the utility if you downloaded it manually.

## Support the project

<a href="https://www.buymeacoffee.com/igorkulman" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png" alt="Buy Me A Coffee" style="height: 41px !important;width: 174px !important;box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;" ></a>

## Known issues

Make sure **Automatically hide and show the menu bar** is **disabled**. This setting causes the utility to incorrectly detect the menu bar size.

Dynamic wallpapers are not supported at the moment. If you use a dynamic wallpaper the utility will convert it to a static .jpg image.

### Catalina support

The utility builds and runs on Catalina but the menu bar on Catalina works in a different way that on Big Sur and Monterey so the result will never be the same as on Big Sur and Monterey.

## Contributing

All contributions are welcomed!

## Author

- **Igor Kulman** - *Initial work* - igor@kulman.sk

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
