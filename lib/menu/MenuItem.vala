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
// An interface for all menu items. It's derived from a Clutter.Actor and can //
// be shown directly on stage. Derived classes have to implement its          //
// appearance and behaviour.                                                  //
////////////////////////////////////////////////////////////////////////////////

public interface MenuItem : Clutter.Actor {

  //////////////////////////////////////////////////////////////////////////////
  //                          public interface                                //
  //////////////////////////////////////////////////////////////////////////////

  public abstract string text  { public get; public set; }
  public abstract string icon  { public get; public set; }
  public abstract double angle { public get; public set; }
  
  // returns all sub menus of this item ----------------------------------------
  public abstract Gee.ArrayList<MenuItem> get_sub_menus();
  
  // adds a child to this MenuItem --------------------------------------------
  public abstract void add_sub_menu(MenuItem item);
  
  // called prior to display() -------------------------------------------------
  public abstract void init();
  
  // shows the MenuItem and all of it's sub menus on the screen ----------------
  public abstract void display();
  
  // removes the MenuItem and all of it's sub menus from the screen ------------
  public abstract void close();
  
  // for debugging purposes ----------------------------------------------------
  public virtual void print(int indent = 0) {
    string space = "";
    
    for (int i=0; i<indent; ++i)
      space += "  ";
      
    debug(space + get_type().name() + ":"
                + "\"" + this.text 
                + "\" (Icon: \"" + this.icon 
                + "\", Angle: %f)".printf(this.angle));
    
    foreach (var menu in get_sub_menus())
      menu.print(indent + 1);
  }
}
  
}
