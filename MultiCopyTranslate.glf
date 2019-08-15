#
# Copyright 2019 (c) Pointwise, Inc. 
# All rights reserved.
#
# This sample Pointwise script is not supported by Pointwise, Inc.
# It is provided freely for demonstration purposes only.
# SEE THE WARRANTY DISCLAIMER AT THE BOTTOM OF THIS FILE.
#

#######################################################################
##
## Copy-Translate Utility
## 
## CHOOSE MULTIPLE ENTITY TYPES, COPY AND TRANSLATE THEM
##
## Allows you to choose a singular instance or multiple instances of a 
## Pointwise database entity and then translate them.
## 
## 1. Choose Pointwise database entity or entities to tranform
## 2. Define an anchor point for copy-translation
## 3. Choose end point for translation vector
##
#######################################################################

# Written by Josh Dawson
# v1: July 30, 2019

package require PWI_Glyph 2

## Return incoming entity selection, or interactively select entities
proc pickEntities { ents } {  
  upvar $ents curSelection
  set picked [pw::Display getSelectedEntities curSelection]

  if { ! $picked } {
    set entMask [pw::Display createSelectionMask]
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
proc translate { entArrayName anchor_point end_point_list } {
  puts "Anchor Point: $anchor_point"
  puts "End Point(s): $end_point_list \n"
  set entityTypes { "Connectors" "Domains" "Blocks" "Databases" }
  lsort -unique end_point_list
  upvar $entArrayName ents

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

# DISCLAIMER:
# TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE LAW, POINTWISE DISCLAIMS
# ALL WARRANTIES, EITHER EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED
# TO, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE, WITH REGARD TO THIS SCRIPT.  TO THE MAXIMUM EXTENT PERMITTED 
# BY APPLICABLE LAW, IN NO EVENT SHALL POINTWISE BE LIABLE TO ANY PARTY 
# FOR ANY SPECIAL, INCIDENTAL, INDIRECT, OR CONSEQUENTIAL DAMAGES 
# WHATSOEVER (INCLUDING, WITHOUT LIMITATION, DAMAGES FOR LOSS OF 
# BUSINESS INFORMATION, OR ANY OTHER PECUNIARY LOSS) ARISING OUT OF THE 
# USE OF OR INABILITY TO USE THIS SCRIPT EVEN IF POINTWISE HAS BEEN 
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGES AND REGARDLESS OF THE 
# FAULT OR NEGLIGENCE OF POINTWISE.
#
