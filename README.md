# ffmpeg-msvc-build

[![Build status](https://ci.appveyor.com/api/projects/status/rok7i2fbv5ptrwvm?svg=true)](https://ci.appveyor.com/project/mcmtroffaes/ffmpeg-msvc-build)

Scripts for building FFmpeg with MSVC on AppVeyor.

The script closely follows the [official
instructions](https://trac.ffmpeg.org/wiki/CompilationGuide/MSVC). By
default, only static LGPL builds are generated (in 32 and 64 bit, and
in debug and release configurations). However, the build matrix can be
easily modified to allow different configurations to be built as well.

## Requirements

* [NASM](https://www.nasm.us/)
* [MSYS2](https://www.msys2.org/) (needs to be installed at ``C:\msys64\``)
* [Build Tools for Visual Studio] (https://visualstudio.microsoft.com/thank-you-downloading-visual-studio/?sku=BuildTools&rel=16#) (make sure to check C++ build tools)
* [Nuget.exe](https://nuget.org/downloads)
* The following packages installed with msys pacman `pacman -S p7zip diffutils make nasm`
## Build

Prebuilt static LGPL builds with Visual Studio 2017 (toolset v141) can be found [here](https://github.com/mcmtroffaes/ffmpeg-msvc-build/releases). If you want to build your own version on your local machine, then:

  * Checkout the tag for the ffmpeg version you want in the submodule
    - `git submodule init`
    - `git submodule update`
    - `cd ffmpeg`
    - `git checkout n4.1.3` - replace the tag with whatever release you would like to build
  * Ensure nasm is in your path; if not, add it see above pacman command.
  * The following variables will be set in build.bat:
      - PLATFORM (x86, x64)
      - CONFIGURATION (Release, Debug)
      - LINKAGE (shared, static)
      - RUNTIME_LIBRARY (MD, MT)
      - LICENSE (LGPL21, LGPL3, GPL2, GPL3)
  * Start the build script by running ``build.bat``.

## Package
 * Update FFmpeg.LGPL.x86.nuspec version number to match ffmpeg (git checkout command above). If the license has changed, update that as well.
 * `nuget.exe pack FFmpeg.LGPL.x86.nuspec`
 * Upload resulting nupkg to trafficlandit nuget repo

## License

All scripts for creating the builds are licensed under the conditions
of the [MIT license](LICENSE.txt). For the examples in the
[examples](examples) folder, see individual files for license details.

The builds themselves are covered by the relevant license for your build
(see [here](https://www.gnu.org/licenses/) for full details).
