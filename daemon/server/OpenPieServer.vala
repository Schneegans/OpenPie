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

namespace OpenPie {

////////////////////////////////////////////////////////////////////////////////
// The OpenPieServer shows pie menus when there are incoming requests. It     //
// emits the signal on_select() when the users selects an item from the       //
// currently active menu.                                                     //
////////////////////////////////////////////////////////////////////////////////

[DBus (name = "org.gnome.openpie")]
public class OpenPieServer : GLib.Object {

  //////////////////////////////////////////////////////////////////////////////
  //                         public interface                                 //
  //////////////////////////////////////////////////////////////////////////////

  /////////////////////////////// signals //////////////////////////////////////

  // emitted, when the users selects an item from the currently active menu ----
  public signal void on_select(int id, string item);

  //////////////////////////// public methods //////////////////////////////////

  // initializes members and loads plugins -------------------------------------
  construct {
    window_ =         new TransparentWindow();
    plugin_loader_ =  new PluginLoader();

    if (Paths.global_plugin_directory != "")
      plugin_loader_.load_from(Paths.global_plugin_directory);
    if (Paths.local_plugin_directory != "")
      plugin_loader_.load_from(Paths.local_plugin_directory);
  }

  // opens a menu according to the given description ---------------------------
  // and returns a newly assigned ID
  public int show_menu(string menu_description) {

    var settings = new GLib.Settings("org.gnome.openpie");

    // getting menu plugin name
    var menu_plugin = settings.get_string ("active-plugin");

    // create a new menu
    var menu = plugin_loader_.get_plugin(menu_plugin);

    if (menu == null) {
      warning("Failed to display menu: "+
              @"There is no menu plugin '$menu_plugin' loaded!");
      return -1;
    }

    menu.window = window_;
    menu.set_content(menu_description);

    // store it the open_menus_ map with an unique ID
    current_id_ +=1;
    open_menus_.set(menu, current_id_);

    // connect close and selection handlers
    menu.on_select.connect(on_menu_select_);
    menu.on_close.connect(on_menu_close_);

    // open the fullscreen window if necessary
    if (!window_.visible)
      window_.show_all();

    // make sure that the window is displayed
    while(Gtk.events_pending() || Gdk.events_pending()) {
      Gtk.main_iteration_do(true);
    }

    // focus all input on the big window
    window_.add_grab();

    // initialize menu
    menu.init();

    // display menu
    menu.display(window_.get_pointer_pos());

    // report the new menu's ID over the dbus
    return current_id_;
  }

  //////////////////////////////////////////////////////////////////////////////
  //                           private stuff                                  //
  //////////////////////////////////////////////////////////////////////////////

  ////////////////////////// member variables //////////////////////////////////

  // the fullscreen window onto which menus are drawn --------------------------
  private TransparentWindow window_ = null;

  // loads all menu plugins ----------------------------------------------------
  private PluginLoader plugin_loader_ = null;

  // stores all currently opened menus with their individual ID ----------------
  private Gee.HashMap<Menu, int> open_menus_ = new Gee.HashMap<Menu, int>();

  // stores the ID of the lastly opened menu -----------------------------------
  private int current_id_ = 0;

  ////////////////////////// private methods ///////////////////////////////////

  // callback gets called when the user selects an item ------------------------
  // in the currently active menu
  private void on_menu_select_(Menu menu, string item) {
    window_.remove_grab();
    menu.on_select.disconnect(on_menu_select_);
    on_select(this.open_menus_.get(menu), item);
  }

  // callback gets called when the currently active menu is closed -------------
  private void on_menu_close_(Menu menu) {
    menu.on_close.disconnect(on_menu_close_);
    this.open_menus_.unset(menu);

    // necessary? Maybe we can leave the window opened... nobody will notice,
    // and everything will be flicker-free...
    //if (open_menus_.size == 0)
    //  window_.hide();
  }
}

}
