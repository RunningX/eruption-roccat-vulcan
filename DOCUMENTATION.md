# Table of Contents

- <a href="#features">Features</a>
- <a href="#experimental">Experimental Features</a>
- <a href="#config">Configuration and Usage</a>
- <a href="#profiles">Profiles</a>
- <a href="#scripts">Lua Scripts and Manifests</a>
- <a href="#macro_support">Support for Macros </a>
- <a href="#plugins">Available Plugins</a>
- <a href="#effects">Available Effects</a>
- <a href="#macros">Available Macro Definitions</a>
- <a href="#info">Further Reading</a>
- <a href="#contributing">Contributing</a>

## Features <a name="features"></a>

Overview:

* Integrated Lua interpreter
* AIMO LED Control via Lua scripts
* Multiple Lua scripts may be executed in parallel, with their outputs combined
* Allows for construction of complex "effect pipelines"
* Event-based architecture
* Daemon plugins may export functions to Lua
* Profiles may be switched at runtime via a D-Bus method
* A GNOME based profile switcher extension is available

## Experimental Features <a name="experimental"></a>

* Mouse support was added in version `0.1.10`. It can be enabled in `eruption.conf` by setting `"grab_mouse = true"` in section `[global]`. This will enable support for mouse events and Easy Shift+ mouse button macros.

* Eruption `0.1.12` somewhat relaxed the mouse grabbing mode. It now is possible for Eruption to process mouse events without grabbing the mouse exclusively. Injection of mouse events wont work in that mode though. This feature has been added to support setups, where another software should be granted exclusive access to the mouse device.


## Configuration and Usage <a name="config"></a>

### Eruption configuration file

> You may want to try the
[Eruption Profile Switcher](https://extensions.gnome.org/extension/2621/eruption-profile-switcher/)
GNOME Shell extension, for easy switching of profiles on the fly.

The eruption configuration file `/etc/eruption/eruption.conf`:

```toml
# Eruption - Linux user-mode driver for the ROCCAT Vulcan 100/12x series keyboards
# Main configuration file

[global]
profile_dir = "/var/lib/eruption/profiles/"
script_dir = "/usr/share/eruption/scripts/"

# select your keyboard variant
# keyboard_variant = "ANSI"
keyboard_variant = "ISO"

enable_mouse = true
grab_mouse = true
```

#### Section [global]

*keyboard_variant* = Switch between sub-variants of your device. (Only partially supported)

*enable_mouse* = Enable support for mouse events. This will allow Eruption to react on mouse events.

*grab_mouse* = Enable support for the injection of mouse events. This will allow Eruption to extend the Easy Shift+ macros to the mouse. Since the mouse is grabbed exclusively, other software will be prohibited from using the hardware mouse. Set this to `false` if you want Eruption to co-exist with other software, that needs to listen to mouse events, such as 3rd party device drivers.


### Profiles <a name="profiles"></a>

The file `default.profile` from the directory `/var/lib/eruption/profiles`

```toml
id = '5dc62fa6-e965-45cb-a0da-e87d29713093'
name = 'Organic FX'
description = 'Organic effects'
active_scripts = [
      'organic.lua',
      'shockwave.lua',
  #   'impact.lua',
  #   'water.lua',
  #   'raindrops.lua',
      'macros.lua',
  #   'stats.lua',
  #   'profiles.lua',
  ]
```

The file `preset-red-yellow.profile` from the directory `/var/lib/eruption/profiles`

```toml
id = '5dc62fa6-e965-45cb-a0da-e87d29713099'
name = 'Preset: Red and Yellow'
description = '''Presets for a 'red and yellow' color scheme'''
active_scripts = [
	  'batique.lua',
	  'shockwave.lua',
 	  'macros.lua',
#	  'stats.lua',
#     'profiles.lua',
]

[[config.Batique]]
type = 'float'
name = 'color_divisor'
value = 2.0

[[config.Batique]]
type = 'float'
name = 'color_offset'
value = -90.0
```

This will run the `batique.lua` script to "paint the background", and on top of
that, display the shockwave effect from `shockwave.lua` when a key has been
pressed. Configuration values may be overridden on a per-profile basis. If a
configuration value is not listed in the `.profile` file, the default value
will be taken from the script's `.manifest` file.

#### Switching profiles and slots at runtime

> You may want to install the GNOME Shell extension
[Eruption Profile Switcher](https://extensions.gnome.org/extension/2621/eruption-profile-switcher/)
or visit the [Github page](https://github.com/X3n0m0rph59/eruption-profile-switcher)

You may switch the currently active slot to `profile1.profile` with the following command:

#### Switch Profile

```sh
$ eruptionctl switch profile profile1.profile
```

#### Switch Slot

Slots can be switched with the following command:

**Switch to slot 2:**

```sh
$ eruptionctl switch slot 2
```

### Lua Scripts and Manifests <a name="scripts"></a>

All script files and their corresponding manifests reside in the directory
`/usr/share/eruption/scripts`. You may use the provided scripts as a starting
point to write your own effects.


### Support for Macros <a name="macro_support"></a>

Eruption 0.1.1 added the infrastructure to support injection of keystrokes
(to support "macros").

This is achieved by adding a "virtual keyboard" to the system that injects
keystroke sequences as needed. The "real hardware" keyboard will be grabbed
exclusively on startup of the daemon. This allows Eruption to filter out
keystrokes, so they won't be reported to the system twice.

Eruption 0.1.8 introduced support for dynamic switching of slots via `MODIFIER + F1-F4` keys.

NOTE: `MODIFIER` is a placeholder for the modifier key. It is set to the **`FN`** key by default,
but can be re-mapped easily to e.g. the `Right Shift` or `Right Alt` keys.

Eruption 0.1.8 also added support for the macro keys (`Insert` - `Pagedown`) in conjunction with the
aforementioned `MODIFIER` key. So if you want to play back `Macro #1` you just have to press
`MODIFIER` + `[M1]` key.

Eruption 0.1.9 introduced the file `/usr/share/eruption/scripts/lib/macros/user-macros.lua`.
You may use it to implement your own macros.

Eruption 0.1.10 introduced _experimental_ mouse support. The mouse support is roughly implemented in the same way as the previously mentioned keyboard support, by adding a "virtual mouse" device to the system that injects events as needed. The "real hardware" mouse will be grabbed exclusively (this can be disabled) on startup of the daemon. This allows Eruption to filter out or inject "virtual" mouse events.

## Available Plugins <a name="plugins"></a>

* Keyboard: Process keyboard events, like e.g. "Key pressed"
* Mouse: Process mouse events, like e.g. "Button pressed" or "Mouse moved"
* System: Basic system information and status, like e.g. running processes. Execute external commands, ...
* Sensors: Query system sensor values, like e.g. CPU package temperature
* Audio: Audio related tasks, like playing sounds, also used by audio visualizers, ...
* Introspection: Provides internal status information of the Eruption daemon
* Persistence: Provides a persistence layer for the Lua scripts to store data
* Profiles: Switch slots, switch profiles based on system state, ...
* Macros: Inject programmable key stroke sequences

## Available Effects Scripts <a name="effects"></a>

Eruption currently ships with the following Lua scripts:

| Name                            | Class      | File                   | Status | Description                                                                                                  |
| ------------------------------- | ---------- | ---------------------- | ------ | ------------------------------------------------------------------------------------------------------------ |
| Afterglow                       | Effect     | `afterglow.lua`        | Ready  | Hit keys are lit for a certain amount of time, then they are faded out                                       |
| Afterhue                        | Effect     | `afterhue.lua`         | Ready  | Hit keys cycle through the HSL color-space, using a linearly decreasing hue angle                            |
| Batique                         | Background | `batique.lua`          | Ready  | Batique effect, based on the Super Simplex Noise function that serves as input to get a HSL color            |
| Open Simplex Noise              | Background | `osn.lua`              | Ready  | Effect based on the Open simplex noise function that serves as input to produce a HSL color                  |
| Billow                          | Background | `billow.lua`           | Ready  | Effect based on the Billow noise function that serves as input to produce a HSL color                        |
| Fractal Brownian Motion         | Background | `fbm.lua`              | Ready  | Effect based on the Fractal Brownian Motion noise function that serves as input to produce a HSL color       |
| Organic                         | Background | `organic.lua`          | Ready  | Effect based on the Super Simplex noise function that serves as input to produce a HSL color                 |
| Perlin Noise                    | Background | `perlin.lua`           | Ready  | Effect based on the Perlin Noise function that serves as input to produce a HSL color                        |
| Psychedelic                     | Background | `psychedelic.lua`      | Ready  | Effect based on the Super Simplex noise function that serves as input to produce a HSL color                 |
| Ridged Multifractal Noise       | Background | `rmf.lua`              | Ready  | Effect based on the Ridged Multifractal noise function that serves as input to produce a HSL color           |
| Voronoi                         | Background | `voronoi.lua`          | Ready  | Effect based on the Voronoi noise function that serves as input to produce a HSL color                       |
| Checkerboard                    | Background | `checkerboard.lua`     | Ready  | Effect based on the Checkerboard noise function that serves as input to produce a HSL color                  |
| Heartbeat                       | Effect     | `heartbeat.lua`        | Ready  | Heartbeat effect. The more the system is loaded the faster the heartbeat effect                              |
| Impact                          | Effect     | `impact.lua`           | Ready  | Hit keys and keys in their immediate vicinity stay lit for a certain amount of time, then they are faded out |
| Raindrops                       | Effect     | `raindrops.lua`        | Ready  | Rain effect, randomly light up keys and fade them out again                                                  |
| Ghost                           | Effect     | `ghost.lua`            | Ready  | Ghost typing effect, randomly highlight keys and fade them out again                                         |
| Phonon                          | Effect     | `phonon.lua`           | Ready  | Display a propagating phonon wave effect                                                                     |
| Water                           | Effect     | `water.lua`            | Ready  | Display propagating water ripples effect                                                                     |
| Wave                            | Effect     | `wave.lua`             | Ready  | Display a colored wave where the alpha channel values are based on the sine function                         |
| Solid                           | Background | `solid.lua`            | Ready  | Display a solid color                                                                                        |
| Rainbow                         | Background | `rainbow.lua`          | Ready  | Display a rainbow color gradient                                                                             |
| Stripes                         | Background | `stripes.lua`          | Ready  | Display horizontal stripes of multiple colors                                                                |
| Gradient                        | Background | `gradient.lua`         | Ready  | Gradient Noise, requires a CPU later than 2015 with support for SIMD/AVX2                                    |
| Turbulence                      | Background | `turbulence.lua`       | Ready  | Turbulence Noise, requires a CPU later than 2015 with support for SIMD/AVX2                                  |
| Color Swirls (Perlin Noise)     | Background | `swirl-perlin.lua`     | Ready  | Color swirls effect, based on the Perlin Noise function that serves as input to produce a HSL color          |
| Color Swirls (Turbulence Noise) | Background | `swirl-turbulence.lua` | Ready  | Color swirls effect, based on the Turbulence Noise function that serves as input to produce a HSL color      |
| Color Swirls (Voronoi Noise)    | Background | `swirl-voronoi.lua`    | Ready  | Color swirls effect, based on the Voronoi Noise function that serves as input to produce a HSL color         |

The following scripts are unfinished/still in development, and some of them have known bugs:

| Name               | Class      | File                  | Progress         | Description                                                                                        |
| ------------------ | ---------- | --------------------- | ---------------- | -------------------------------------------------------------------------------------------------- |
| Fire               | Background | `fire.lua`            | Approx. 65% done | Shows a bonfire effect on the keyboard                                                             |
| Fireworks          | Background | `fireworks.lua`       | Approx. 85% done | Shows a fireworks effect on the keyboard                                                           |
| Heat Map           | Effect     | `heatmap.lua`         | Approx. 50% done | Shows a heat map of recorded statistics on the keyboard                                            |
| Gaming             | Effect     | `gaming.lua`          | Approx. 85% done | Highlight a fixed set of keys, like e.g. 'WASD'                                                    |
| Snake              | Effect     | `snake.lua`           | Approx. 25% done | Displays a snake that lives on your keyboard                                                       |
| Linear Gradient    | Background | `linear-gradient.lua` | Approx. 95% done | Display a color gradient                                                                           |
| Multi Gradient     | Background | `multigradient.lua`   | Approx. 65% done | Display a color gradient, supports multiple gradient stops                                         |
| Shockwave          | Effect     | `shockwave.lua`       | Approx. 85% done | Like Impact, but shows propagating waves when a key has been pressed                               |
| Sysmon             | Background | `sysmon.lua`          | Approx. 10% done | System monitor, keyboard reflects system state                                                     |
| Temperature        | Background | `temperature.lua`     | Approx. 85% done | Temperature monitor. The keyboard reflects the CPU temperature, from 'green = cold' to 'red = hot' |
| Audio Visualizer 1 | Background | `audioviz1.lua`       | Approx 95% done  | Shows the current loudness of the configured audio source as a color gradient                      |
| Audio Visualizer 2 | Background | `audioviz2.lua`       | Approx 85% done  | Shows the current loudness of the configured audio source as HSL colors progressively              |
| Audio Visualizer 3 | Background | `audioviz3.lua`       | Approx 95% done  | Shows a "spectrum analyzer" visualization of the configured audio source                           |
| Audio Visualizer 4 | Background | `audioviz4.lua`       | Approx 85% done  | VU-meter like heartbeat effect                                                                     |
| Audio Visualizer 5 | Background | `audioviz5.lua`       | Approx 75% done  | Like Batique, but with additional audio feedback                                                   |

Scripts are combined to so called "effect pipelines" using a `.profile` file. E.g.: You may use one or more backgrounds, and then stack multiple
effects scripts on top of that.

## Available Macro Definitions <a name="macros"></a>

The macro files are stored in `/usr/share/eruption/scripts/lib/macros/`. Each file provides the Lua code that controls illumination and colors of each of the modifier layers, additionally they provide the code that gets executed when a macro key or Easy Shift shortcut is pressed. Eruption currently ships with custom keyboard macros for the following software:

| Name         | Class   | File              | Progress        | Description                                                                                                               |
| ------------ | ------- | ----------------- | --------------- | ------------------------------------------------------------------------------------------------------------------------- |
| user-macros  | Default | `user-macros.lua` | Approx 95% done | Customizable general purpose macro definitions for Eruption. Maybe use this as a starting point for your own macro files. |
| Star Craft 2 | Game    | `starcraft2.lua`  | Approx 15% done | Star Craft 2 related macros                                                                                               |

For a detailed documentation on how to write your own macros, please refer to [MACROS.md](./MACROS.md)

## Further Reading <a name="info"></a>

For a documentation of the supported Lua functions and libraries, please
refer to the developer documentation [LIBRARY.md](./LIBRARY.md)

## Contributing <a name="contributing"></a>

Contributions are welcome!
Please see `src/scripts/examples/*.lua` directory for Lua scripting examples.
