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

public class TraceMenuItem : MenuItem {

  //////////////////////////////////////////////////////////////////////////////
  //                          public interface                                //        
  //////////////////////////////////////////////////////////////////////////////
  
  construct {
    sub_menus_ = new Gee.ArrayList<TraceMenuItem>();
  }
  
  public override void on_init() {
    width = 100;
    height = 100;
    x = 100;
    y = 100;
    
    background_color = Clutter.Color.from_string("red");
    
    foreach (var item in sub_menus_)
      item.on_init();
  }
  
  public override Gee.ArrayList<MenuItem> get_sub_menus() {
    return sub_menus_;
  }
  
  // adds a child to this MenuItem
  public override void add_sub_menu(MenuItem item) {
    sub_menus_.add(item as TraceMenuItem);
    item.parent = this;
  }
  
  //////////////////////////////////////////////////////////////////////////////
  //                         protected stuff                                  //
  //////////////////////////////////////////////////////////////////////////////
  
  // called when the mouse starts hovering the MenuItem
  protected override bool on_enter(Clutter.CrossingEvent e) {
    background_color = Clutter.Color.from_string("blue");
    return true;
  }
  
  // called when the mouse stops hovering the MenuItem
  protected override bool on_leave(Clutter.CrossingEvent e) {
    background_color = Clutter.Color.from_string("red");
    return true;
  }
  
  //////////////////////////////////////////////////////////////////////////////
  //                          private stuff                                   //
  //////////////////////////////////////////////////////////////////////////////
  
  public Gee.ArrayList<TraceMenuItem> sub_menus_;
  
  

}
  
}
