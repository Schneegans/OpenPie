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
  return typeof (OpenPie.TileMenu);
}

namespace OpenPie {

////////////////////////////////////////////////////////////////////////////////
// A TileMenu is a special marking menu. When the user selects an item, a     //
// unique path is created on screen. The user may "draw" this path really     //
// quickly in order to select the according entry. That's not only fast ---   //
// that's also fun!                                                           //
////////////////////////////////////////////////////////////////////////////////

public class TileMenu : MenuPlugin, Menu {

  //////////////////////////////////////////////////////////////////////////////
  //                         public interface                                 //
  //////////////////////////////////////////////////////////////////////////////

  /////////////////////////// public variables /////////////////////////////////

  public string name        { get; construct set; }
  public string version     { get; construct set; }
  public string author      { get; construct set; }
  public string email       { get; construct set; }
  public string homepage    { get; construct set; }
  public string description { get; construct set; }

  public string plugin_directory    { get; set; }

  public TileMenuItem root          { public get; public set; default=null; }

  //////////////////////////// public methods //////////////////////////////////

  // initializes all members ---------------------------------------------------
  construct {
    name        = "TileMenu";
    version     = "0.1";
    author      = "Simon Schneegans";
    email       = "code@simonschneegans.de";
    homepage    = "http://www.simonschneegans.de";
    description = "A TileMenu is a 360-degree-spherical pie menu.";

    // var settings  = new GLib.Settings("org.gnome.openpie.Tilemenu");
  }

  // ---------------------------------------------------------------------------
  public override MenuItem get_root() {
    return root;
  }

  // ---------------------------------------------------------------------------
  public override void set_content(string menu_description) {
    var loader = new MenuLoader.from_string(typeof(TileMenuItem),
                                            menu_description);
    root = calculate_positions(loader.root as TileMenuItem);
    root.set_parent_menu(this);
  }

  // ---------------------------------------------------------------------------
  public override void display(Vector position) {
    window.get_stage().add_child(root.actor);

    base.display(position);
  }

  // ---------------------------------------------------------------------------
  public override void close() {
    window.get_stage().remove_child(root.actor);

    base.close();
  }

  //////////////////////////////////////////////////////////////////////////////
  //                          private stuff                                   //
  //////////////////////////////////////////////////////////////////////////////

  ////////////////////////// private methods ///////////////////////////////////

  public TileMenuItem calculate_positions(TileMenuItem root) {

    int count = root.get_horizontal_children_count();

    for (int i = 0; i<root.sub_menus.size; ++i) {
      var child = root.sub_menus[i];

      child.x = i%count;
      child.y = (int)(i/count);

      calculate_positions(child);
    }

    return root;
  }
}

}
