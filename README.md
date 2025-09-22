Canvas Skeleton Add-on for FlightGear
=====================================

First, read [README.add-ons](https://gitlab.com/flightgear/fgdata/-/blob/next/Docs/README.add-ons), which explains how add-ons work in FlightGear.

This is a Canvas skeleton add-on. Use it as a simple starting point for your own FlightGear add-on. The difference from [Skeleton](https://sourceforge.net/p/flightgear/fgaddon/HEAD/tree/trunk/Addons/Skeleton/) is that this add-on is based on a GUI built with Canvas. So if you need a Canvas-based GUI, this is the place to start.

This skeleton favors object-oriented programming (one class per file, with each class having a single responsibility), but you can also write procedural code and put 5K lines in one file - if that's what you're comfortable with :) Methods and class members intended to be private or protected start with an underscore `_`. Nasal doesn't enforce this like C++, but it helps clarify the code's intent.

This add-on includes many files you might find unnecessary. For example, the entire `nasal/Utils` directory contains helper classes you don't have to use. These are mostly wrappers for FlightGear functions that make them easier to work with, but you can safely do without them.

## Reload add-on and `.env` file

One significant change is not using a hard-coded menu item to reload the add-on. After spending many hours developing add-ons for FlightGear, I realized I needed a solution that wouldn't interfere with the repository and wouldn't require me to constantly remember not to commit the `addon-menubar-items.xml` file with an uncommented reload menu item.

To solve this, I implemented a mechanism inspired by other frameworks: an `.env` file for local configuration that isn't added to the repository (the `.env` file is listed in `.gitignore`). If you create an `.env` file (copy `.env.example` as a starting point), you can set the variable `DEV_MODE=true`. This will automatically and programmatically add a **Dev Reload** menu item, allowing you to reload the add-on's Nasal files without restarting the simulator.

The files `nasal/Utils/Dev/DevEnv.nas` and `nasal/Utils/Dev/DevReload.nas` handle this functionality, so you'll need to keep them if you want to use this mechanism.

You MUST also update the value of `MAIN_MENU_LABEL` in `DevReload.nas` file to match the name of your main menu label.

## Canvas Dialog

This add-on also includes a sample Canvas window: the *About* window. It is managed by the `AboutDialog` class, which inherits from the `Dialog` class and handles the drawing of Canvas windows. You can use the `Dialog` class to create new windows more quickly.

The *About* window also demonstrates a custom Canvas widget called `ExampleLabel`. If you need to draw something that FlightGear's built-in widgets don't support, it's a good idea to implement it as a separate widget. Well-designed widgets are easy to reuse, even across projects and help keep your code organized. In this case, `ExampleLabel` doesn't do much beyond displaying text in a larger red font, but it serves as a starting example. You can draw and animate anything in a widget using the low-level Canvas API, which offers far more flexibility.

It's also worth noting the approach used for managing Canvas windows. A common method is to create a window when the user requests it, and then destroy it when the user closes it. This add-on takes a different approach: all Canvas windows are created when the add-on loads, and closing a window only hides it instead of destroying it.

This approach has the following advantages:

- Windows appear much faster, without the temporary white "empty" window that can last 1-2 seconds.
- If the user resizes or moves a window, those properties are preserved when it is reopened.

Disadvantages of this solution:

- Windows occupy memory even if the user never opens them.

In practice, the benefits outweigh the drawback - RAM is meant to be used to speed things up. Still, you can switch back to the traditional behavior if you prefer: in the `Dialog` class, set the `destroyOnClose` variable to `true`. In that case, call the `new()` method instead of `show()` when displaying a window.

## Deferring Canvas loading

Creating Canvas windows immediately when the simulator starts has another drawback I haven't mentioned yet. Many aircraft developers assume that Canvas indices and textures will never change, and simply hardcode expectations like "the PFD texture is always at index 10." This can cause unintended side effects, such as our dialog boxes appearing on aircraft displays.

To avoid this, the add-on defers the creation of its Canvas windows by 3 seconds. This allows the aircraft's Canvas windows to be created first, and only then initializes the add-on's windows.

This approach also requires disabling any menu items that open Canvas windows until those windows have been created. Otherwise, clicking such a menu item could try to show a non-existent Canvas window and cause the add-on to crash.

If aircraft implementations improve, or if FlightGear introduces a proper solution, this delay will no longer be necessary.

## Structure of the add-on

The first and most important Nasal file loaded by FlightGear is `addon-main.nas`. In this skeleton, its sole responsibility is to load the other Nasal files into their appropriate namespaces. By default, files are loaded into the `canvasSkeleton` namespace (you should change this to your own). Files related to custom Canvas widgets are loaded into the `canvas` namespace and should not be changed.

If you add new `.nas` files to the project, you don't need to modify anything - `addon-main.nas` will automatically detect and load them when the add-on restarts. However, keep in mind:

- Widget files must be placed in the `Widgets` directory; all files there are automatically loaded into the `canvas` namespace.
- Other Nasal files can be placed in the add-on's root directory or in the `nasal` subdirectory.
- Any additional subdirectories must be located inside `nasal`.
- All Nasal files must use the `.nas` extension, otherwise they won't be recognized.

After loading, the `Bootstrap.init()` method is executed. From `Bootstrap.nas` onward, you can work directly in your namespace (e.g., `canvasSkeleton`), so you don't need to prefix every class reference.

The `Bootstrap` file should prepare any required directories and initialize your classes. In this skeleton, only the `AboutDialog` class is created, since the add-on displays just this one window. You can add more dialogs the same way. Note that the `AboutDialog` instance is created inside a timer that delays Canvas window creation by 3 seconds. For the reasons explained earlier, you should create other Canvas windows here in the same way.

Directory structure for Nasal files:

- `/` - you can place other Nasal files in the main project directory if you need to, but they cannot be widget files.
- `/nasal` - place your add-on logic Nasal files here (not related to Canvas).
- `/nasal/Utils` - supporting Nasal files such as wrappers, facades, etc.
- `/nasal/Utils/Dev` - Nasal support files, for development purposes only.
- `/nasal/Canvas` - Nasal files related to drawing in Canvas.
- `/nasal/Canvas/Widgets` - Nasal widget files for Canvas (models).
- `/nasal/Canvas/Widgets/Styles` - Nasal widget files for Canvas (views).

## A little bit about widgets

A widget is divided into two files: one for the **model** and one for the **view**.

1. The **model** stores the data needed by the view and serves as the first layer of contact with the application. It exposes methods for passing data to and from the application.
2. The **view** handles the actual drawing, which is the widget's main purpose.

The view is hidden behind the model, so your application should not interact with the view directly. In this add-on, the model is implemented in the `ExampleLabel` class, and the view in the `ExampleLabelView` class.

## You can also see add-ons written based on this skeleton

A great way to get familiar with writing add-ins in Canvas is through live, working examples:

1. [Which Runway](https://github.com/PlayeRom/flightgear-addon-which-runway)
2. [Logbook](https://github.com/PlayeRom/flightgear-addon-logbook)
