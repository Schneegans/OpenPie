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
// A base class for all menus. Derived classes have to implement it's         //
// behaviour.                                                                 //
////////////////////////////////////////////////////////////////////////////////

public abstract class Menu : GLib.Object {
  
  //////////////////////////////////////////////////////////////////////////////
  //                          public interface                                //
  //////////////////////////////////////////////////////////////////////////////
  
  // the window onto which the menu should be drawn
  public TransparentWindow window { public get; public set; default=null; }
  public MenuItem          root   { public get; public set; default=null; }
  
  // emitted when some item is selected (occurs prior to on_close)
  public signal void on_select(Menu menu, string item);
  
  // emitted when the menu finally disappears from screen
  public signal void on_close(Menu menu);
  
  // shows the menu on screen --------------------------------------------------
  public virtual void display() {
    window.on_key_up.connect(on_key_up);
    window.on_key_down.connect(on_key_down);
    window.on_mouse_move.connect(on_mouse_move);
    
    window.get_stage().add_child(root);
     
    root.display();
  }
  
  // for debugging purposes ----------------------------------------------------
  public void print() {
    root.print();
  }
  
  // called before the menu is displayed ---------------------------------------
  public virtual void init() {
    root.init();
  }
  
  //////////////////////////////////////////////////////////////////////////////
  //                    abstract public interface                             //
  //////////////////////////////////////////////////////////////////////////////
  
  // sets the menu content which shall be displayed
  public abstract void set_content(string menu_description); 
  
  //////////////////////////////////////////////////////////////////////////////
  //                          private stuff                                   //
  //////////////////////////////////////////////////////////////////////////////
  
  private void on_mouse_move(float x, float y) {

  }
  
  private void on_key_down(Key key) {

  }
  
  private void on_key_up(Key key) {

  
    if (key.with_mouse)
      select("test");
  }
  
  private void select(string item) {
    window.on_key_up.disconnect(on_key_up);
    window.on_key_down.disconnect(on_key_down);
    window.on_mouse_move.disconnect(on_mouse_move);
    
    on_select(this, item);
    
    GLib.Timeout.add(1000, () => {
      close();
      return false;
    });
  }
  
  private void close() {
    root.close();
    window.get_stage().remove_child(root);
  
    on_close(this);
  }
}   
  
}
