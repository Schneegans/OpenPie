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
// This is an item of a TileMenu. A TileMenu is a 180-degree-spherical      //
// marking menu. When the user selects an item, a unique path is created on   //
// screen. The user may "draw" this path really quickly in order to selects   //
// the according entry. That's not only fast --- that's also fun!             //
////////////////////////////////////////////////////////////////////////////////

public class TileMenuItem : MenuItem, Animatable, GLib.Object {

  //////////////////////////////////////////////////////////////////////////////
  //                          public interface                                //
  //////////////////////////////////////////////////////////////////////////////

  /////////////////////////// public variables /////////////////////////////////

  public enum State {
    SELECTED,
    ACTIVE,
    PREVIEW,
    INACTIVE,
    HIDDEN,
    FINAL
  }

  public State  state { get; set; default = State.HIDDEN; }
  public string text  { get; set; default = "Unnamed Item"; }
  public string icon  { get; set; default = "none"; }

  public int x        { get; set; default = 0; }
  public int y        { get; set; default = 0; }

  public weak TileMenuItem           parent_item { get; set; default=null; }
  public Gee.ArrayList<TileMenuItem> sub_menus   { get; set; default=null; }

  //////////////////////////// public methods //////////////////////////////////

  // initializes all members ---------------------------------------------------
  construct {
    sub_menus = new Gee.ArrayList<TileMenuItem>();

    background_ = new Clutter.Actor();

    text_ = new Clutter.Text.full(
      "ubuntu 10", "", Clutter.Color.from_string("black"));

    notify["state"].connect(() => {
      on_state_change();
    });
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

    var touch_item = item as TileMenuItem;
    touch_item.parent_item = this;
    sub_menus.add(touch_item);
  }

  // called prior to display() -------------------------------------------------
  public void init() {

    background_.width = TILE_WIDTH;
    background_.height = TILE_HEIGHT;
    background_.background_color = Clutter.Color.from_string("red");
    background_.set_pivot_point(0.5f, 0.5f);
    background_.z_position = -0.01f;
    background_.reactive = true;

    background_.x = TILE_WIDTH*x;
    background_.y = TILE_WIDTH*y;

    text_.text = text;
    text_.set_line_alignment(Pango.Alignment.CENTER);
    text_.z_position = 0.01f;
    text_.set_pivot_point(0.5f, 0.5f);
    text_.line_wrap = true;
    text_.opacity = 0;

    if (isRoot()) {
      state = State.SELECTED;
    } else if (parent_item.isRoot()) {
      state = State.ACTIVE;
    } else if (parent_item.parent_item.isRoot()) {
      state = State.PREVIEW;
    } else {
      state = State.HIDDEN;
    }

    foreach (var item in sub_menus)
      item.init();
  }

  // shows the MenuItem and all of it's sub menus on the screen ----------------
  public void display(Vector position) {

    on_state_change();

    if (isRoot()) {
      set_relative_position(new Vector(position.x, position.y));
    }

    parent_menu_.background.add_child(background_);
    parent_menu_.text.add_child(text_);

    parent_menu_.on_cancel.connect(on_cancel);
    parent_menu_.on_select.connect(on_select);

    background_.enter_event.connect(on_enter);
    background_.leave_event.connect(on_leave);
    background_.motion_event.connect(on_motion);
    background_.button_press_event.connect(on_button_press);
    background_.button_release_event.connect(on_button_release);

    foreach (var item in sub_menus) {
      item.display(position);
    }
  }

  // removes the MenuItem and all of it's sub menus from the screen ------------
  public void close() {

    parent_menu_.background.remove_child(background_);
    parent_menu_.text.remove_child(text_);

    parent_menu_.on_cancel.disconnect(on_cancel);
    parent_menu_.on_select.disconnect(on_select);

    background_.enter_event.disconnect(on_enter);
    background_.leave_event.disconnect(on_leave);
    background_.motion_event.disconnect(on_motion);
    background_.button_press_event.disconnect(on_button_press);
    background_.button_release_event.disconnect(on_button_release);

    foreach (var item in sub_menus)
      item.close();
  }

  // sets the parent menu of this TileMenuItem --------------------------------
  public void set_parent_menu(TileMenu menu) {
    parent_menu_ = menu;
    foreach (var item in sub_menus)
      item.set_parent_menu(menu);
  }

  // returns true if this TileMenuItem is not a child of any other item -------
  public bool isRoot() {
    return parent_item == null;
  }

  //////////////////////////////////////////////////////////////////////////////
  //                          private stuff                                   //
  //////////////////////////////////////////////////////////////////////////////


  ////////////////////////// member variables //////////////////////////////////

  // the menu of which this TileMenuItem is a member
  private weak TileMenu parent_menu_ = null;

  // text written on the item
  private Clutter.Text text_ = null;

  // textures of this actor
  private Clutter.Actor background_ = null;

  // initial scale of the texture
  private const int TILE_WIDTH = 100;
  private const int TILE_HEIGHT = 100;

  // some predefined animation configurations
  private Animatable.Config animation_ease_ = new Animatable.Config.full(
    250, Clutter.AnimationMode.EASE_IN_OUT
  );

  private Animatable.Config animation_linear_ = new Animatable.Config.full(
    250, Clutter.AnimationMode.LINEAR
  );

  ////////////////////////// private methods ///////////////////////////////////

  /////////////////////////// event handling ///////////////////////////////////

  // ---------------------------------------------------------------------------
  private void on_cancel() {
    GLib.Timeout.add(500, () => {
      state = State.FINAL;
      return false;
    });
  }

  // ---------------------------------------------------------------------------
  private void on_select() {
    GLib.Timeout.add(1000, () => {
      state = State.FINAL;
      return false;
    });
  }

  // ---------------------------------------------------------------------------
  private bool on_enter(Clutter.CrossingEvent event) {

    return true;
  }

  // ---------------------------------------------------------------------------
  private bool on_leave(Clutter.CrossingEvent event) {
    return true;
  }

  // ---------------------------------------------------------------------------
  private bool on_motion(Clutter.MotionEvent event) {

    return true;
  }

  // ---------------------------------------------------------------------------
  private bool on_button_press(Clutter.ButtonEvent event) {

    return true;
  }

  // ---------------------------------------------------------------------------
  private bool on_button_release(Clutter.ButtonEvent event) {

    parent_menu_.select(this, 1000);

    return true;
  }

  // ---------------------------------------------------------------------------
  private void on_state_change() {

    switch (state) {
      case State.SELECTED:
        set_background_visible(false);
        set_text_visible(false);
        break;

      case State.ACTIVE:
        set_background_visible(true);
        set_text_visible(true);
        break;

      case State.PREVIEW:
        set_background_visible(true);
        set_text_visible(false);
        break;

      case State.INACTIVE:
        set_background_visible(true);
        set_text_visible(false);
        break;

      case State.HIDDEN:
        set_background_visible(false);
        set_text_visible(false);
        break;

      case State.FINAL:
        set_background_visible(true);
        set_text_visible(true);
        break;
    }
  }

  ////////////////////////////// helper methods ////////////////////////////////

  // ---------------------------------------------------------------------------
  private int get_total_children_count() {
    if (sub_menus.size == 0) {
      return 1;
    }

    int sum = 0;
    foreach (var child in sub_menus) {
      sum += child.get_total_children_count();
    }

    return sum;
  }

  // ---------------------------------------------------------------------------
  private void set_text_visible(bool visible) {
    animate(text_, "opacity", visible ? 255 : 0, animation_linear_);
  }

  // ---------------------------------------------------------------------------
  private void set_background_visible(bool visible) {
    background_.visible = visible;
  }

  // ---------------------------------------------------------------------------
  private void set_relative_position(
    Vector position, Animatable.Config config = new Animatable.Config()) {


  }

}

}
