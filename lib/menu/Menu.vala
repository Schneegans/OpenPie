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

public abstract class Menu : GLib.Object {
  
  //////////////////////////////////////////////////////////////////////////////
  //                          public interface                                //        
  //////////////////////////////////////////////////////////////////////////////
  
  // emitted when some item is selected (occurs prior to on_close)
  public signal void on_select(Menu menu, string item);
  
  // emitted when the menu finally disappears from screen
  public signal void on_close(Menu menu);
  
  // sets the menu content which shall be displayed
  public abstract void set_content(string menu_description); 
  
  // sets the window onto which the menu should be drawn
  public void set_window(TransparentWindow window) {
    window_ = window;
  }
  
  // shows the menu on screen
  public void display() {
    window_.on_key_up.connect(on_key_up_);
    window_.on_key_down.connect(on_key_down_);
    window_.on_mouse_move.connect(on_mouse_move_);
    
    root_.display();
  }
  
  // for debugging purposes
  public void print() {
    debug(get_type().name() + ":");
    root_.print();
  }
  
  //////////////////////////////////////////////////////////////////////////////
  //                        protected stuff                                   //
  //////////////////////////////////////////////////////////////////////////////
  
  protected void set_root(MenuItem root) {
    root_        = root;
    root_.parent = window_.get_stage();
  }
  
  //////////////////////////////////////////////////////////////////////////////
  //                          private stuff                                   //
  //////////////////////////////////////////////////////////////////////////////
  
  private MenuItem            root_   = null;
  private TransparentWindow   window_ = null;
  
  private void on_mouse_move_(float x, float y) {
//    root_.x = x;
//    root_.y = y;
  }
  
  private void on_key_down_(Key key) {

  }
  
  private void on_key_up_(Key key) {

  
    if (key.with_mouse)
      select_("test");
  }
  
  private void select_(string item) {
    window_.on_key_up.disconnect(on_key_up_);
    window_.on_key_down.disconnect(on_key_down_);
    window_.on_mouse_move.disconnect(on_mouse_move_);
    
    on_select(this, item);
    
    GLib.Timeout.add(1000, () => {
      close_();
      return false;
    });
  }
  
  private void close_() {
    root_.close();
  
    on_close(this);
  }
}   
  
}
