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
// This is an item of a TracMenu. A TraceMenu is a special marking menu. When //
// the user selects an item, a unique path is created on screen. The user may //
// "draw" this path really quickly in order to select the according entry.    //
// That's not only fast --- that's also fun!                                  //
////////////////////////////////////////////////////////////////////////////////

public class TraceMenuItem : MenuItem, Clutter.Actor {

  //////////////////////////////////////////////////////////////////////////////
  //                          public interface                                //
  //////////////////////////////////////////////////////////////////////////////
  
  public string text  { public get; public set;  default = "Unnamed Item"; }
  public string icon  { public get; public set;  default = "none"; }
  public double angle { public get; public set;  default = 0.0; }  
    
  construct {
    x = 100;
    y = 100;
    
    width = 100;
    height = 100;
    
    background_color = Clutter.Color.from_string("red");
  
    sub_menus_ = new Gee.ArrayList<TraceMenuItem>();
    reactive = true;
  }
  
  
  // returns all sub menus of this item ----------------------------------------
  public Gee.ArrayList<MenuItem> get_sub_menus() {
    return sub_menus_;
  }
  
  // adds a child to this MenuItem ---------------------------------------------
  public void add_sub_menu(MenuItem item) {
    var trace_item = item as TraceMenuItem;
    sub_menus_.add(trace_item);
    trace_item.parent_ = this;
    add_child(trace_item);
  }
  
  // called prior to display() -------------------------------------------------
  public void init() {
    
    
    foreach (var item in sub_menus_)
      item.init();
  }
  
  // shows the MenuItem and all of it's sub menus on the screen ----------------
  public void display() {
    
    enter_event.connect(on_enter);
    leave_event.connect(on_leave);
    
    foreach (var item in sub_menus_)
      item.display();
  }
  
  // removes the MenuItem and all of it's sub menus from the screen ------------
  public void close() {
    
    enter_event.disconnect(on_enter);
    leave_event.disconnect(on_leave);
    
    foreach (var item in sub_menus_)
      item.close();
  }
  
  //////////////////////////////////////////////////////////////////////////////
  //                         protected stuff                                  //
  //////////////////////////////////////////////////////////////////////////////
  
  // called when the mouse starts hovering the MenuItem
  private bool on_enter(Clutter.CrossingEvent e) {
    //add_effect(new Clutter.DesaturateEffect(1.0));
    background_color = Clutter.Color.from_string("blue");
    return true;
  }
  
  // called when the mouse stops hovering the MenuItem
  private bool on_leave(Clutter.CrossingEvent e) {
    //clear_effects();
    background_color = Clutter.Color.from_string("red");
    return true;
  }
  
  //////////////////////////////////////////////////////////////////////////////
  //                          private stuff                                   //
  //////////////////////////////////////////////////////////////////////////////
  
  private Gee.ArrayList<TraceMenuItem>  sub_menus_ = null;
  private TraceMenuItem                 parent_    = null;

}
  
}
