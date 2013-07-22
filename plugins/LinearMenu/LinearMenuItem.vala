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
// This is an item of a LinearMenu. A LinearMenu is a 180-degree-spherical      //
// marking menu. When the user selects an item, a unique path is created on   //
// screen. The user may "draw" this path really quickly in order to selects   //
// the according entry. That's not only fast --- that's also fun!             //
////////////////////////////////////////////////////////////////////////////////

public class LinearMenuItem : MenuItem, Animatable, Clutter.Group {

  //////////////////////////////////////////////////////////////////////////////
  //                          public interface                                //
  //////////////////////////////////////////////////////////////////////////////

  /////////////////////////// public variables /////////////////////////////////

  public string text  { get; set;  default = "Unnamed Item"; }
  public string icon  { get; set;  default = "none"; }
  public float  angle { get; set;  default = 0.0f; }

  public weak LinearMenuItem           parent_item { get; set; default=null; }
  public Gee.ArrayList<LinearMenuItem> sub_menus   { get; set; default=null; }

  //////////////////////////// public methods //////////////////////////////////

  // initializes all members ---------------------------------------------------
  construct {
    sub_menus = new Gee.ArrayList<LinearMenuItem>();
  }

  // returns all sub menus of this item ----------------------------------------
  public Gee.ArrayList<MenuItem> get_sub_menus() {
    return sub_menus;
  }

  // returns the parent of this item -------------------------------------------
  public MenuItem get_parent_item() {
    return parent_item;
  }

  // adds a child to this MenuItem ---------------------------------------------
  public void add_sub_menu(MenuItem item) {

    var linear_item = item as LinearMenuItem;
    linear_item.parent_item = this;

    linear_item.y = 20 * sub_menus.size;

    if (parent_item != null) {
      linear_item.x = 200;
    }

    sub_menus.add(linear_item);
  }

  // called prior to display() -------------------------------------------------
  public void init() {

    background_ = new Clutter.Actor();
    background_.width = 200;
    background_.height = 20;
    background_.reactive = true;
    background_.background_color = Clutter.Color.from_string("white");
    add_child(background_);

    text_ = new Clutter.Text.full("ubuntu 12", text,
                                  Clutter.Color.from_string("black"));
    text_.set_pivot_point(0.5f, 0.5f);
    text_.scale_x = 0.8;
    text_.scale_y = 0.8;
    add_child(text_);

    reactive = true;
    z_position = 0.01f;
    // set_pivot_point(0.5f, 0.5f);

    width = 200;
    height = 20;

    foreach (var item in sub_menus) {
      item.init();
      add_child(item);
    }
  }

  // shows the MenuItem and all of it's sub menus on the screen ----------------
  public void display(Vector position) {

    if (isRoot()) {
      set_position(position.x, position.y);
    }

    background_.enter_event.connect(on_enter);
    background_.leave_event.connect(on_leave);
    background_.button_press_event.connect(on_button_press);
    background_.button_release_event.connect(on_button_release);

    foreach (var item in sub_menus)
      item.display(position);
  }

  // removes the MenuItem and all of it's sub menus from the screen ------------
  public void close() {

    background_.enter_event.disconnect(on_enter);
    background_.leave_event.disconnect(on_leave);
    background_.button_press_event.disconnect(on_button_press);
    background_.button_release_event.disconnect(on_button_release);

    foreach (var item in sub_menus)
      item.close();
  }

  // sets the parent menu of this LinearMenuItem --------------------------------
  public void set_parent_menu(LinearMenu menu) {
    parent_menu_ = menu;
    foreach (var item in sub_menus)
      item.set_parent_menu(menu);
  }

  // returns true if this LinearMenuItem is not a child of any other item -------
  public bool isRoot() {
    return parent_item == null;
  }

  //////////////////////////////////////////////////////////////////////////////
  //                          private stuff                                   //
  //////////////////////////////////////////////////////////////////////////////

  ////////////////////////// member variables //////////////////////////////////

  // the menu of which this LinearMenuItem is a member
  private weak LinearMenu parent_menu_ = null;

  // text written on the item
  private Clutter.Text text_ = null;

  // background of this actor
  private Clutter.Actor background_ = null;

  ////////////////////////// private methods ///////////////////////////////////

  public void hide_sub_menu() {
    animate(background_, "background_color", Clutter.Color.from_string("#ffffff00"), 50, Clutter.AnimationMode.LINEAR);
    animate(text_, "color", Clutter.Color.from_string("#00000000"), 50, Clutter.AnimationMode.LINEAR);

    foreach (var item in sub_menus)
      item.hide_sub_menu();
  }

  public void show_sub_menu() {
    animate(background_, "background_color", Clutter.Color.from_string("#ffffffff"), 50, Clutter.AnimationMode.LINEAR);
    animate(text_, "color", Clutter.Color.from_string("#000000ff"), 50, Clutter.AnimationMode.LINEAR);
  }

  // called when the mouse starts hovering the MenuItem ------------------------
  private bool on_enter(Clutter.CrossingEvent e) {
    animate(background_, "background_color", Clutter.Color.from_string("red"), 50, Clutter.AnimationMode.LINEAR);

    foreach (var item in sub_menus)
      item.show_sub_menu();

    return false;
  }

  // called when the mouse stops hovering the MenuItem -------------------------
  private bool on_leave(Clutter.CrossingEvent e) {
    animate(background_, "background_color", Clutter.Color.from_string("white"), 500, Clutter.AnimationMode.LINEAR);

    foreach (var item in sub_menus)
      item.hide_sub_menu();

    return false;
  }

  // called when a mouse button is pressed hovering the MenuItem ---------------
  private bool on_button_press(Clutter.ButtonEvent e) {
    parent_menu_.select(this);
    return false;
  }

  // called when a mouse button is released hovering the MenuItem --------------
  private bool on_button_release(Clutter.ButtonEvent e) {
    return false;
  }
}

}
