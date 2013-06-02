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

[DBus (name = "org.openpie.main")]
public class OpenPieServer : GLib.Object {

  //////////////////////////////////////////////////////////////////////////////
  //              public interface                                            //        
  //////////////////////////////////////////////////////////////////////////////
  
  // emitted, when the users selects an item from the currently active menu
  public signal void on_select(int id, string item);
  
  construct
  {
    window_ = new TransparentWindow();
  }
  
  // opens a menu according to the given description and returns a newly 
  // assigned ID
  public int show_menu(string menu_description) {
    // create a new menu
    var menu = new Menu(menu_description, window_);
    
    // store it the open_menus_ map with an unique ID
    current_id_ +=1;
    open_menus_.set(menu, current_id_);
    
    // connect close and selection handlers
    menu.on_select.connect(on_menu_select_);
    menu.on_close.connect(on_menu_close_);
    
    // open the fullscreen window if necessary
    if (open_menus_.size == 1)
      window_.show_all();
    
    // focus all input on the big window
    window_.add_grab();
    
    // display the menu
    menu.display();
    
    // report the new menu's ID over the dbus
    return current_id_;
  } 
  
  //////////////////////////////////////////////////////////////////////////////
  //              private stuff                                               //
  //////////////////////////////////////////////////////////////////////////////
  
  // the fullscreen window onto which menus are drawn
  private TransparentWindow window_ = null;
  
  // stores all currently opened menus with their individual ID
  private Gee.HashMap<Menu, int> open_menus_ = new Gee.HashMap<Menu, int>();
  
  // stores the ID of the lastly opened menu
  private int current_id_ = 0;
  
  // callback gets called when the user selects an item
  // in the currently active menu
  private void on_menu_select_(Menu menu, string item) {
    window_.remove_grab();
    menu.on_select.disconnect(on_menu_select_);
    on_select(this.open_menus_.get(menu), item);
  }
  
  // callback gets called when the currently active menu is closed
  private void on_menu_close_(Menu menu) {
    menu.on_close.disconnect(on_menu_close_);
    this.open_menus_.unset(menu);
    
    if (open_menus_.size == 0)
      window_.hide();
  }
}

}
