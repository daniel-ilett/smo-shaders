# SMO Shaders

![SMO Banner](banner.png)

## Overview
This repository contains a Unity project that emulates the shaders found in Super Mario Odyssey's Snapshot Mode. Inside the `Shaders` folder, there is a collection of template shader files, alongside a folder called `Complete` which contains finished and commented versions of all of those shader files. The reader is intended to follow the Image Effects tutorial series found on https://danielilett.com/, which outlines how each of the shaders work.

<a href='https://ko-fi.com/M4M2190VC' target='_blank'><img height='36' style='border:0px;height:36px;' src='https://az743702.vo.msecnd.net/cdn/kofi1.png?v=2' border='0' alt='Buy Me a Coffee at ko-fi.com' /></a>

### Shaders Included
Several shaders are included in this project, corresponding to the following Snapshot Mode effects:
- Greyscale;
- Sepia-tone;
- Silhouette;
- Blur (Edge Blur);
- Line Drawing;
- Neon;
- NES;
- SNES;
- Game Boy;
- Oil Painting.

Some auxiliary shaders are also provided to assist in creating Snapshot Mode effects:
- Box Blur;
- Gaussian Blur;
- Bloom;
- CRT Screen.

### Scripts Included
A few helper scripts are also provided alongside these shaders in order to control them:
- `ImageEffectBase.cs`;
- `ImageEffectGaussian.cs`;
- `ImageEffectBloom.cs`;
- `ImageEffectPixelate.cs`;
- `ImageEffectCRT.cs`.

Additionally, more scripts related to the test scene are included:
- `CameraMove.cs`;
- `Rotate.cs`;
- `Hover.cs`.

A later update added a full Snapshot Mode that allows for easy switching between filters on the fly, containing the following scripts:
- `SnapshotMode.cs`;
- `SnapshotFilter.cs`;
- `SnapshotCanvas.cs`.

### Assets
This project uses the following assets:
- ["Single Street Lamp" by Christopher Fisher](https://assetstore.unity.com/packages/3d/environments/urban/single-street-lamp-121728);
- ["Bench" by IL.RANCH](https://assetstore.unity.com/packages/3d/props/exterior/bench-75025).

### Fonts
This project uses the following fonts:
- ["Cabin" by Impallari Type](https://www.1001fonts.com/cabin-font.html).

## Software
The project was created using Unity 2019.2.0a9, but it should be possible to upgrade or downgrade to other versions of Unity.

## Authors
These shaders, and the corresponding tutorial series, were written by [Daniel Ilett](https://github.com/daniel-ilett).

## Release
The shader collection was released on April 24th alongside the introduction of the tutorial series. Articles are released twice a week, and updates conclude on May 22nd.

Thanks for reading my tutorials.

❤
