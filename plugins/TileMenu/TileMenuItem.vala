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
    UNSELECTABLE,
    SELECTABLE,
    PREVIEW,
    HIDDEN,
    FINAL_SELECTED,
    FINAL_UNSELECTED
  }

  public State  state { get; set; default = State.HIDDEN; }
  public string text  { get; set; default = "Unnamed Item"; }
  public string icon  { get; set; default = "none"; }

  public int x        { get; set; default = 0; }
  public int y        { get; set; default = 0; }
  public int z        { get; set; default = 0; }

  public Clutter.Actor               actor       { get; set; default=null; }

  public weak TileMenuItem           parent_item { get; set; default=null; }
  public Gee.ArrayList<TileMenuItem> sub_menus   { get; set; default=null; }

  //////////////////////////// public methods //////////////////////////////////

  // initializes all members ---------------------------------------------------
  construct {
    sub_menus   = new Gee.ArrayList<TileMenuItem>();
    actor       = new Clutter.Actor();

    background_ = new Clutter.Actor();
    text_       = new Clutter.Text.full(
                        "ubuntu 10", "", Clutter.Color.from_string("black"));

    color_          = get_random_color();
    selected_color_ = get_depth_color(0);

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

    set_background_color(color_);
    background_.set_pivot_point(0.5f, 0.5f);
    background_.z_position = -0.01f;

    text_.text = text;
    text_.width = TILE_SIZE*0.9f;
    text_.set_line_alignment(Pango.Alignment.CENTER);
    text_.z_position = 0.01f;
    text_.set_pivot_point(0.5f, 0.5f);
    text_.line_wrap = true;
    text_.opacity = 0;

    foreach (var item in sub_menus)
      item.init();
  }

  // shows the MenuItem and all of it's sub menus on the screen ----------------
  public void display(Vector position) {

    if (!isRoot()) {
      parent_item.actor.add_child(actor);
    }

    actor.add_child(background_);
    actor.add_child(text_);

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

    if (isRoot()) {
      set_position(position);
      set_active(position);
    }

  }

  // removes the MenuItem and all of it's sub menus from the screen ------------
  public void close() {

    actor.remove_child(background_);
    actor.remove_child(text_);

    if (!isRoot())
      parent_item.actor.remove_child(actor);

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

  // ---------------------------------------------------------------------------
  public int get_horizontal_children_count() {
    if (sub_menus.size == 0)
      return 0;
    return (int)(Math.ceil(Math.sqrt(sub_menus.size)));
  }

  // ---------------------------------------------------------------------------
  public int get_vertical_children_count() {
    if (sub_menus.size == 0)
      return 0;
    return (int)(Math.ceil((float)sub_menus.size/get_horizontal_children_count()));
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

  private Clutter.Color color_;
  private Clutter.Color selected_color_;

  // initial scale of the texture
  private const int TILE_SIZE = 100;
  private const int DEPTH = 200;
  private const int BORDER = 10;

  // some predefined animation configurations
  private Animatable.Config animation_ease_ = new Animatable.Config.full(
    150, Clutter.AnimationMode.EASE_IN_OUT
  );

  private Animatable.Config animation_linear_ = new Animatable.Config.full(
    150, Clutter.AnimationMode.LINEAR
  );

  ////////////////////////// private methods ///////////////////////////////////

  /////////////////////////// event handling ///////////////////////////////////

  // ---------------------------------------------------------------------------
  private void on_cancel() {
    state = State.FINAL_UNSELECTED;
  }

  // ---------------------------------------------------------------------------
  private void on_select() {
    if (state != State.FINAL_SELECTED)
      state = State.FINAL_UNSELECTED;
    else GLib.Timeout.add(500, () => {
        state = State.FINAL_UNSELECTED;
      return false;
    });

  }

  // ---------------------------------------------------------------------------
  private bool on_enter(Clutter.CrossingEvent event) {
    if (state != State.SELECTED)
      set_background_color(color_.lighten(), animation_ease_);
    return true;
  }

  // ---------------------------------------------------------------------------
  private bool on_leave(Clutter.CrossingEvent event) {
    if (state != State.SELECTED)
      set_background_color(color_, animation_ease_);
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

    // left button
    if (event.button == 1) {

      if (state == State.SELECTED) {
        set_active();
      } else if (sub_menus.size == 0) {
        state = State.FINAL_SELECTED;
        parent_menu_.select(this, 1000);

      } else if (!isRoot()) {
        set_active();
      }

    // right or other buttons
    } else {

      if (isRoot() || (parent_item.isRoot() && state != State.SELECTED)) {
        parent_menu_.cancel(500);

      } else if (state == State.SELECTED) {
        parent_item.set_active();
      } else {
        parent_item.parent_item.set_active();
      }
    }

    return true;
  }

  // ---------------------------------------------------------------------------
  private void set_active(Vector? position = null) {

    state = State.SELECTED;

    // set children to preview mode

    if (position != null) {
      var width = TILE_SIZE*get_horizontal_children_count();
      var height = TILE_SIZE*get_vertical_children_count();
      set_position(new Vector(position.x - width*0.5f, position.y-height*0.5f), animation_ease_);
    } else if (!isRoot()) {
      var width = TILE_SIZE*(get_horizontal_children_count()-1);
      var height = TILE_SIZE*(get_vertical_children_count()-1);
      set_position(new Vector(x*TILE_SIZE- width*0.5f, y*TILE_SIZE-height*0.5f), animation_ease_);
    }

    foreach(var child in sub_menus) {
      child.state = State.SELECTABLE;

      foreach(var sub_child in child.sub_menus) {
        sub_child.state = State.PREVIEW;
        foreach(var sub_sub_child in sub_child.sub_menus) {
          sub_sub_child.hide_all();
        }
      }
    }

    // make parents inactive
    if (!isRoot()) {
      parent_item.actor.set_child_above_sibling(actor, null);
      parent_item.set_inactive(1, this);
    }

    selected_color_ = get_depth_color(0);
    set_background_color(selected_color_, animation_ease_);
  }

  // ---------------------------------------------------------------------------
  private void set_inactive(int depth, TileMenuItem active_child) {

    state = State.SELECTED;

    foreach (var child in sub_menus) {
      if (child != active_child) {
        child.state = State.UNSELECTABLE;
        foreach(var sub_child in child.sub_menus) {
          sub_child.state = State.PREVIEW;
          foreach(var sub_sub_child in sub_child.sub_menus) {
            sub_sub_child.hide_all();
          }
        }
      }
    }

    if (!isRoot()) {
      parent_item.set_inactive(depth+1, this);
    } else {
      set_depth(-DEPTH*depth, animation_ease_);
    }

    selected_color_ = get_depth_color(depth);
    set_background_color(selected_color_, animation_ease_);
  }

  // ---------------------------------------------------------------------------
  private void on_state_change() {

    switch (state) {
      case State.SELECTED:
        background_.reactive = true;
        set_background_opacity(255);
        set_background_position(new Vector(-BORDER, -BORDER), animation_ease_);
        int count = get_horizontal_children_count();
        int size = TILE_SIZE*count + 2*BORDER;
        set_size(size, animation_ease_);
        set_text_visible(false);
        if (isRoot()) {
          set_depth(0, animation_ease_);
        } else {
          set_depth(DEPTH, animation_ease_);
        }
        break;

      case State.SELECTABLE:
        background_.reactive = true;
        set_background_opacity(255);
        set_background_color(color_, animation_ease_);
        set_background_position(new Vector(0, 0), animation_ease_);
        set_text_visible(true);
        set_size(TILE_SIZE, animation_ease_);
        set_position(new Vector(x*TILE_SIZE, y*TILE_SIZE), animation_ease_);
        set_depth(0, animation_ease_);

        break;

      case State.PREVIEW:
        background_.reactive = false;
        set_background_opacity(50);
        set_background_color(color_);
        set_text_visible(false);
        int count = parent_item.get_horizontal_children_count();
        int size = TILE_SIZE/count;
        set_size(size, animation_ease_);
        set_position(new Vector(x*size, y*size), animation_ease_);
        break;

      case State.UNSELECTABLE:
        background_.reactive = false;
        set_background_opacity(155);
        set_text_visible(false);
        break;

      case State.HIDDEN:
        set_background_opacity(0);
        set_text_visible(false);
        set_size(0, animation_ease_);
        break;

      case State.FINAL_SELECTED:
        background_.reactive = false;
        set_background_opacity(255);
        set_text_visible(true);
        break;

      case State.FINAL_UNSELECTED:
        background_.reactive = false;
        set_background_opacity(0);
        set_text_visible(false);

        break;
    }
  }

  ////////////////////////////// helper methods ////////////////////////////////

  // ---------------------------------------------------------------------------
  private void hide_all() {
    state = State.HIDDEN;

    foreach (var child in sub_menus)
      child.hide_all();
  }

  // ---------------------------------------------------------------------------
  private void set_text_visible(bool visible) {
    animate(text_, "opacity", visible ? 255 : 0, animation_linear_);
  }

  // ---------------------------------------------------------------------------
  private void set_background_opacity(uint opacity) {
    animate(background_, "opacity", opacity, animation_linear_);
  }

  // ---------------------------------------------------------------------------
  private void set_background_color(
    Clutter.Color color, Animatable.Config config = new Animatable.Config()) {

    animate(background_, "background_color", color, config);
  }

  // ---------------------------------------------------------------------------
  private void set_size(int size,
                         Animatable.Config config = new Animatable.Config()) {

    animate(background_, "width", size, config);
    animate(background_, "height", size, config);
  }

  // ---------------------------------------------------------------------------
  private void set_depth(int depth,
                         Animatable.Config config = new Animatable.Config()) {

    z = depth;
    animate(actor, "z_position", depth, config);
  }

  // ---------------------------------------------------------------------------
  private void set_background_position(Vector position,
                            Animatable.Config config = new Animatable.Config()) {

    animate(background_, "x", position.x, config);
    animate(background_, "y", position.y, config);
  }

  // ---------------------------------------------------------------------------
  private void set_position(Vector position,
                            Animatable.Config config = new Animatable.Config()) {

    animate(actor, "x", position.x, config);
    animate(actor, "y", position.y, config);

    animate(text_, "y", TILE_SIZE/2 - text_.height/2, config);
  }

  // ---------------------------------------------------------------------------
  private Clutter.Color get_depth_color(int depth) {
    var result = Clutter.Color.from_hls(
      0.0f,
      0.5f - 0.3f/(depth+1),
      0.0f
    );

    result.alpha = 255;

    return result;
  }

  // ---------------------------------------------------------------------------
  private Clutter.Color get_random_color() {
    var result = Clutter.Color.from_hls(
      (float)GLib.Random.double_range(0.0, 360.0),
      (float)GLib.Random.double_range(0.5, 0.8),
      (float)GLib.Random.double_range(0.2, 0.3)
    );

    result.alpha = 255;

    return result;
  }
}

}
