#############################################################################
#
# (C) 2021 Cadence Design Systems, Inc. All rights reserved worldwide.
#
# This sample script is not supported by Cadence Design Systems, Inc.
# It is provided freely for demonstration purposes only.
# SEE THE WARRANTY DISCLAIMER AT THE BOTTOM OF THIS FILE.
#
#############################################################################

#############################################################################
##
## Copy-Translate Utility
##
## CHOOSE MULTIPLE ENTITY TYPES, COPY AND TRANSLATE THEM
##
## Allows you to choose a singular instance or multiple instances of a
## Pointwise entity and then translate them.
##
## 1. Choose Pointwise entity or entities to tranform
## 2. Define an anchor point for copy-translation
## 3. Choose end point for translation vector
##
#############################################################################


from pointwise import GlyphClient
from pointwise.glyphapi import *

glf = GlyphClient()
pw = glf.get_glyphapi()


## Return incoming entity selection, or interactively select entities
def pickEntities():
    ents = GlyphVar()
    # pw::Display getSelectedEntities ents
    if (not pw.Display.getSelectedEntities(ents)):
        # pw::Display selectEntities -description "Select entity or entities to copy-translate." ents
        if (not pw.Display.selectEntities(ents, description="Select entity or entities to copy-translate.")):
            raise Exception("No entities selected")
    return ents


## GUI selection: anchor point 
def chooseAnchorPoint():
    try:
        # set xyz [pw::Display selectPoint -description "Select one anchor point."]
        xyz = pw.Display.selectPoint(description="Select one anchor point.")
        return xyz
    except:
        raise Exception("No anchor point selected")


## GUI selection: end points
def chooseEndPoints():
    points = []
    while True:
        try:
            # set endPoint [pw::Display selectPoint -description "Select end point(s), when finished select CANCEL."]
            endPoint = pw.Display.selectPoint(description="Select end point(s), when finished select CANCEL.")
            points.append(endPoint)
        except:
            break

    if len(points) == 0:
        raise Exception("No end points selected")

    return points


## Copy/Translate selected entities
def translate(ents, anchor_point, end_point_list):
    glf.puts("Anchor Point: %s" % anchor_point)
    glf.puts("End Point(s): %s\n" % end_point_list)

    # lsort -unique end_point_list
    for i in end_point_list:
        if (end_point_list.count(i) > 1):
            end_point_list.remove(i)
    end_point_list.sort(reverse=False)

    allEnts = []
    allEnts.extend(ents["Connectors"])
    allEnts.extend(ents["Domains"])
    allEnts.extend(ents["Blocks"])
    allEnts.extend(ents["Databases"])
    allEnts.extend(ents["Sources"])

    # pw::Application clearClipboard
    pw.Application.clearClipboard()
    # pw::Application setClipboard $allEnts
    pw.Application.setClipboard(allEnts)

    for endpoint in end_point_list:
        # Note: Use Python context management to automatically end or abort the mode
        with pw.Application.begin("Paste") as pasteMode:
            # set modEnts [$pasteMode getEntities]
            modEnts = pasteMode.getEntities()
            with pw.Application.begin("Modify", modEnts) as modMode:
                # set transVect [pwu::Vector3 subtract $endpoint $anchor_point]
                endPointVector = Vector3(endpoint[0], endpoint[1], endpoint[2])
                anchorPointVector = Vector3(anchor_point[0], anchor_point[1], anchor_point[2])
                transVect = Vector3.subtract(endPointVector, anchorPointVector)
                # pw::Entity transform [pwu::Transform translation $transVect] $modEnts
                pw.Entity.transform(Transform.translation(transVect), modEnts)


## Main
try:
    ents = pickEntities()
    anchor_point = chooseAnchorPoint()
    end_point_list = chooseEndPoints()
except Exception as e:
    print(e)
    exit(1)
translate(ents, anchor_point, end_point_list)


#############################################################################
#
# This file is licensed under the Cadence Public License Version 1.0 (the
# "License"), a copy of which is found in the included file named "LICENSE",
# and is distributed "AS IS." TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE
# LAW, CADENCE DISCLAIMS ALL WARRANTIES AND IN NO EVENT SHALL BE LIABLE TO
# ANY PARTY FOR ANY DAMAGES ARISING OUT OF OR RELATING TO USE OF THIS FILE.
# Please see the License for the full text of applicable terms.
#
#############################################################################
