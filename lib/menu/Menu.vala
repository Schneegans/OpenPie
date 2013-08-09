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

  // emitted when some item is selected (occurs prior to on_close)
  public signal void on_select(Menu menu, string item);

  // emitted when no item has been selected (occurs prior to on_close)
  public signal void on_cancel(Menu menu);

  // emitted when the menu finally disappears from screen
  public signal void on_close(Menu menu);

  //////////////////////////// public methods //////////////////////////////////

  // shows the menu on screen --------------------------------------------------
  public virtual void display(Vector position) {
    get_root().display(position);
  }

  // for debugging purposes ----------------------------------------------------
  public void print() {
    get_root().print();
  }

  // called before the menu is displayed ---------------------------------------
  public virtual void init() {
    get_root().init();
  }

  // notifies the client that an item has been selected and closes the menu ----
  public void select(MenuItem item) {
    on_select(this, item.get_path());

    GLib.Timeout.add(1000, () => {
      close();
      return false;
    });
  }

  // notifies the client that no item has been selected and closes the menu ----
  public void cancel() {
    on_cancel(this);

    GLib.Timeout.add(1000, () => {
      close();
      return false;
    });
  }

  // removes the menu from the screen ------------------------------------------
  public virtual void close() {
    get_root().close();

    on_close(this);
  }

  /////////////////////// public abstract methods //////////////////////////////

  // returns the root MenuItem of the Menu -------------------------------------
  public abstract MenuItem get_root();

  // sets the menu content which shall be displayed ----------------------------
  public abstract void set_content(string menu_description);
}

}
