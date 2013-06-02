/* 
Copyright (c) 2011-2012 by Simon Schneegans

This program is free software: you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the Free
Software Foundation, either version 3 of the License, or (at your option)
any later version.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
more details.

You should have received a copy of the GNU General Public License along with
this program.  If not, see <http://www.gnu.org/licenses/>. 
*/

//namespace OpenPie {

//public class TraceMenuHelpers : GLib.Object {
//  
//  public static MenuModel adjust_angles(MenuModel model) {
//    
//    int item_count = model.children.size;
//    
//    for (int i=0; i<item_count; ++i) {
//      model.children.get(i).angle = i * 2.0*GLib.Math.PI/item_count;
//      
//      if (model.children.get(i).children.size > 0)
//        adjust_child_angles(model.children.get(i));
//    }
//    
//    return model;
//    
//  }
//  
//  private static void adjust_child_angles(MenuModel model) {
//    double item_angle = 2.0*GLib.Math.PI/(model.children.size + 1);
//    double parent_angle = GLib.Math.fmod(model.angle + GLib.Math.PI, 2.0*GLib.Math.PI);
//    
//    for (int i=0; i<model.children.size; ++i) {
//      model.children.get(i).angle = GLib.Math.fmod(parent_angle + (i+1)*item_angle, 2.0*GLib.Math.PI);
//      
//      adjust_child_angles(model.children.get(i));
//    }
//  
//  }
//}  
//  
//}
