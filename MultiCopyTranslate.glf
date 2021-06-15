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


package require PWI_Glyph 2


## Return incoming entity selection, or interactively select entities
proc pickEntities { ents } {  
  upvar $ents curSelection
  set picked [pw::Display getSelectedEntities curSelection]

  if { ! $picked } {
    set picked  [pw::Display selectEntities \
      -description "Select entity or entities to copy-translate." curSelection]  
  }

  if { ! $picked } {
    exit
  }
}


## GUI selection: anchor point
proc chooseAnchorPoint { } { 
  if [catch {pw::Display selectPoint -description "Select one anchor point."} xyz] {
    exit
  }
  return $xyz
}


## GUI selection: end points
proc chooseEndPoints { } {
  set points [list]
  while { ! [catch {pw::Display selectPoint -description "Select end point(s), when finished select CANCEL." } \
      endPoint]} {
    lappend points $endPoint
  }

  if { [llength $points] == 0 } {
    exit
  }

  return $points
}


## Copy/Translate selected entities
proc translate { selectedEnts anchor_point end_point_list } {
  puts "Anchor Point: $anchor_point"
  puts "End Point(s): $end_point_list \n"
  set entityTypes { "Connectors" "Domains" "Blocks" "Databases" "Sources" }
  lsort -unique end_point_list
  upvar $selectedEnts ents

  set allEnts [list]

  foreach type $entityTypes {   
    foreach ent $ents($type) {
      lappend allEnts $ent
    }
  }

  pw::Application clearClipboard
  pw::Application setClipboard $allEnts

  foreach endpoint $end_point_list {
    set pasteMode [pw::Application begin Paste]
      set modEnts [$pasteMode getEntities]
      set modMode [pw::Application begin Modify $modEnts]
        set transVect [pwu::Vector3 subtract $endpoint $anchor_point]
        pw::Entity transform [pwu::Transform translation $transVect] $modEnts
      $modMode end
    $pasteMode end
  }
}


## Main
pickEntities ents
set anchor_point [chooseAnchorPoint]
set end_point_list [chooseEndPoints]
translate ents $anchor_point $end_point_list


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
