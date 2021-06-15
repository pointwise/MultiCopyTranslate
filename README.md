# MultiCopyTranslate
Copyright 2021 Cadence Design Systems, Inc. All rights reserved worldwide.

A script to copy/paste one or more entities multiple times using a single anchor point and one or more selected end points.


## Usage
This script cannot be run in batch mode. It will use pre-existing selection or will enter interactive selection mode if nothing is selected.
Pick a single anchor point and as many target points as desired. A copy of all selected entities (including parent entities) will be made and translated
using the anchor point and each selected end point.

![ScriptImage](https://raw.github.com/pointwise/MultiCopyTranslate/master/ScriptImage.png)

### Python Version Usage

The Python version of this script requires [Glyph Client for Python][GlyphClient] and [Pointwise][PW] V18.2 or higher.

The command `python -m pip install pointwise-glyph-client` can be used to install the [Glyph Client for Python][GlyphClient] package.

[GlyphClient]: https://github.com/pointwise/GlyphClientPython
[PW]: https://www.pointwise.com


## Disclaimer
This file is licensed under the Cadence Public License Version 1.0 (the "License"), a copy of which is found in the LICENSE file, and is distributed "AS IS." 
TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE LAW, CADENCE DISCLAIMS ALL WARRANTIES AND IN NO EVENT SHALL BE LIABLE TO ANY PARTY FOR ANY DAMAGES ARISING OUT OF OR RELATING TO USE OF THIS FILE. 
Please see the License for the full text of applicable terms.
