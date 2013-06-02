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

public class Menu : GLib.Object {
  
  //////////////////////////////////////////////////////////////////////////////
  //                          public interface                                //        
  //////////////////////////////////////////////////////////////////////////////
  
  // emitted when some item is selected (occurs prior to on_close)
  public signal void on_select(Menu menu, string item);
  
  // emitted when the menu finally disappears from screen
  public signal void on_close(Menu menu);
  
  public Menu(string menu_description, TransparentWindow window) {
    window_ = window;
  
    var loader  = new MenuLoader.from_string(menu_description);
    root_       = loader.root;
  }

  public void display() {
    window_.on_key_up.connect(on_key_up_);
    window_.on_key_down.connect(on_key_down_);
    window_.on_mouse_move.connect(on_mouse_move_);
    window_.on_draw.connect(on_draw_);
  }
  
  //////////////////////////////////////////////////////////////////////////////
  //                          private stuff                                   //
  //////////////////////////////////////////////////////////////////////////////
  
  private MenuItem            root_   = null;
  private TransparentWindow   window_ = null;
  
  private void on_mouse_move_(double x, double y) {
    debug("move");
  }
  
  private void on_key_down_(Key key) {
    debug("key down");
  }
  
  private void on_key_up_(Key key) {
    debug("key up");
  
    if (key.with_mouse)
      select_("test");
  }
  
  private void on_draw_(Cairo.Context ctx, double time) {
  
  }
  
  private void select_(string item) {
    window_.on_key_up.disconnect(on_key_up_);
    window_.on_key_down.disconnect(on_key_down_);
    window_.on_mouse_move.disconnect(on_mouse_move_);
    
    on_select(this, item);
  }
  
  private void close_() {
    window_.on_draw.disconnect(on_draw_);
    
    on_close(this);
  }
}   
  
}
