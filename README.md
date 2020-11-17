# Change menu bar color in macOS Big Sur

Simple utility to change macOS Big Sur menu bar color by appending a colored rectangle to a wallpaper image.

## Motivation

Big Sur changed the way the menu bar is displayed. It now adopts the color of the wallpaper, which may not always be what you would like. This utility allows you to specify the color of the menu bar you want to use.

### Example

Imagine you have a dark wallpaper. This dark wallpaper results in the menu bar being black even though you use the Light mode

![](Screenshots/Dark.png)

With this utility you can generate a new wallpaper that makes the men bar being shown in any color you want, like a nice tone of gray from Catalina.

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

## Contributing

All contributions are welcomed!

### Development

Use `swift package generate-xcodeproj` to generate a Xcode project you can use for development.

## Author

- **Igor Kulman** - *Initial work* - igor@kulman.sk

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.