////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2011-2013 by Simon Schneegans                                //  
//                                                                            //
// This program is free software: you can redistribute it and/or modify it    //
// under the terms of the GNU General Public License as published by the Free //
// Software Foundation, either version 3 of the License, or (at your option)  //
// any later version.                                                         //
//                                                                            //
// This program is distributed in the hope that it will be useful, but        //
// WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY //
// or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License   //
// for more details.                                                          //
//                                                                            //
// You should have received a copy of the GNU General Public License along    //
// with this program.  If not, see <http://www.gnu.org/licenses/>.            //
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// this method is called by the OpenPie Daemon when it registers the          //
// plugin. Name and signature of this method cannot be changed.               //
////////////////////////////////////////////////////////////////////////////////

public GLib.Type register_plugin(GLib.Module module) {
  return typeof (OpenPie.TraceMenu);
}

namespace OpenPie {

////////////////////////////////////////////////////////////////////////////////  
// A TraceMenu is a special marking menu. When the user selects an item, a    //
// unique path is created on screen. The user may "draw" this path really     //
// quickly in order to select the according entry. That's not only fast ---   //
// that's also fun!                                                           //
////////////////////////////////////////////////////////////////////////////////

public class TraceMenu : Plugin, Menu {
    
  //////////////////////////////////////////////////////////////////////////////
  //                         public interface                                 //
  //////////////////////////////////////////////////////////////////////////////
  
  public string name        { get; construct set; }
  public string version     { get; construct set; }
  public string author      { get; construct set; }
  public string email       { get; construct set; }
  public string homepage    { get; construct set; }
  public string description { get; construct set; }
  
  public TraceMenuItem root { public get; public set; default=null; }
  
  construct {
    name        = "TraceMenu";
    version     = "0.1";
    author      = "Simon Schneegans";
    email       = "code@simonschneegans.de";
    homepage    = "http://www.simonschneegans.de";
    description = "A TraceMenu is a special marking menu. When the user selects
                   an item, a unique path is created on screen. The user may
                   \"draw\" this path really quickly in order to select the
                   according entry. That's not only fast --- that's also fun!";
  }
  
  public override MenuItem get_root() {
    return root;
  }
  
  public override void set_content(string menu_description) {
    var loader = new MenuLoader.from_string(typeof(TraceMenuItem), 
                                            menu_description);
    root = adjust_angles(loader.root as TraceMenuItem);
    root.set_parent_menu(this);
  }
    
  //////////////////////////////////////////////////////////////////////////////
  //                          private stuff                                   //
  //////////////////////////////////////////////////////////////////////////////
  
  // distributes items equally over a full circle ------------------------------
  private TraceMenuItem adjust_angles(TraceMenuItem root_item) {
    
    int item_count = root_item.sub_menus.size;
    
    for (int i=0; i<item_count; ++i) {
      root_item.sub_menus.get(i).angle = (float)(i * 2.0*GLib.Math.PI/item_count);
      
      if (root_item.sub_menus.get(i).sub_menus.size > 0)
        adjust_child_angles(root_item.sub_menus.get(i));
    }
    
    return root_item;
  }
  
  // distributes items equally over a full circle, -----------------------------
  // leaving one gap for the parent
  private void adjust_child_angles(TraceMenuItem item) {
    double item_angle = (float)(2.0*GLib.Math.PI/(item.sub_menus.size + 1));
    double parent_angle = GLib.Math.fmod(item.angle + GLib.Math.PI, 2.0*GLib.Math.PI);
    
    for (int i=0; i<item.sub_menus.size; ++i) {
      item.sub_menus.get(i).angle = (float)(GLib.Math.fmod(parent_angle + (i+1)*item_angle, 2.0*GLib.Math.PI));
      
      adjust_child_angles(item.sub_menus.get(i));
    }
  }
  
}

}




