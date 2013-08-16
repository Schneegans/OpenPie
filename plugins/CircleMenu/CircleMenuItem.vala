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
// This is an item of a CircleMenu. A CircleMenu is a 180-degree-spherical      //
// marking menu. When the user selects an item, a unique path is created on   //
// screen. The user may "draw" this path really quickly in order to selects   //
// the according entry. That's not only fast --- that's also fun!             //
////////////////////////////////////////////////////////////////////////////////

public class CircleMenuItem : MenuItem, Animatable, GLib.Object {

  //////////////////////////////////////////////////////////////////////////////
  //                          public interface                                //
  //////////////////////////////////////////////////////////////////////////////


  /////////////////////////// public variables /////////////////////////////////

  public enum State {
    BIG_ATTACHED,   // <- currently moving item
    BIG_ACTIVE,     // <- currently focused item
    BIG_INACTIVE,   // <- previously selected items
    BIG_PREVIEW,    // <- highlighted current items
    SMALL_ACTIVE,   // <- submenus of the currently focused item
    SMALL_INACTIVE, // <- submenus of previously selected items
    SMALL_PREVIEW,  // <- submenus of highlighted items
    SELECTED,       // <- when a final selection is made
    HIDDEN,         // <- submenus of submenus
    FINAL           // <- final disappearance state
  }

  public State  state { get; set; default = State.HIDDEN; }
  public string text  { get; set; default = "Unnamed Item"; }
  public string icon  { get; set; default = "none"; }
  public float  angle { get; set; default = 0.0f; }

  public weak CircleMenuItem           parent_item { get; set; default=null; }
  public Gee.ArrayList<CircleMenuItem> sub_menus   { get; set; default=null; }
  public bool                          activated   { get; set; default=false; }

  //////////////////////////// public methods //////////////////////////////////

  // initializes all members ---------------------------------------------------
  construct {
    sub_menus = new Gee.ArrayList<CircleMenuItem>();

    background_ = new Clutter.Texture();
    foreground_ = new Clutter.Texture();
    hover_effect_ = new Clutter.BrightnessContrastEffect();

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

    var touch_item = item as CircleMenuItem;
    touch_item.parent_item = this;
    sub_menus.add(touch_item);
  }

  // called prior to display() -------------------------------------------------
  public void init() {

    load_texture(background_, parent_menu_.plugin_directory + "/data/bg.png");
    background_.width = SIZE;
    background_.height = SIZE;
    background_.set_pivot_point(0.5f, 0.5f);
    background_.z_position = -0.01f;

    load_texture(foreground_, parent_menu_.plugin_directory + "/data/bg.png");
    foreground_.width = SIZE*0.9f;
    foreground_.height = SIZE*0.9f;
    foreground_.pick_with_alpha = true;
    foreground_.reactive = true;
    foreground_.z_position =  0.0f;
    foreground_.set_pivot_point(0.5f, 0.5f);
    foreground_.add_effect(hover_effect_);

    text_.text = text;
    text_.set_line_alignment(Pango.Alignment.CENTER);
    text_.z_position = 0.01f;
    text_.set_pivot_point(0.5f, 0.5f);
    text_.line_wrap = true;
    text_.opacity = 0;

    set_scale(0.0f);

    if (isRoot()) {
      state = State.BIG_INACTIVE;
    } else if (parent_item.isRoot()) {
      state = State.SMALL_INACTIVE;
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
    parent_menu_.foreground.add_child(foreground_);
    parent_menu_.text.add_child(text_);

    parent_menu_.on_cancel.connect(on_cancel);
    parent_menu_.on_select.connect(on_select);

    foreground_.enter_event.connect(on_enter);
    foreground_.leave_event.connect(on_leave);
    foreground_.motion_event.connect(on_motion);

    foreach (var item in sub_menus) {
      item.display(position);
    }
  }

  // removes the MenuItem and all of it's sub menus from the screen ------------
  public void close() {

    parent_menu_.background.remove_child(background_);
    parent_menu_.foreground.remove_child(foreground_);
    parent_menu_.text.remove_child(text_);

    parent_menu_.on_cancel.disconnect(on_cancel);
    parent_menu_.on_select.disconnect(on_select);

    foreground_.enter_event.disconnect(on_enter);
    foreground_.leave_event.disconnect(on_leave);
    foreground_.motion_event.disconnect(on_motion);

    foreach (var item in sub_menus)
      item.close();
  }

  // sets the parent menu of this CircleMenuItem --------------------------------
  public void set_parent_menu(CircleMenu menu) {
    parent_menu_ = menu;
    foreach (var item in sub_menus)
      item.set_parent_menu(menu);
  }

  // returns true if this CircleMenuItem is not a child of any other item -------
  public bool isRoot() {
    return parent_item == null;
  }

  // ---------------------------------------------------------------------------
  public CircleMenuItem? get_selected_child() {
    foreach (var child in sub_menus) {
      if (child.state == State.BIG_PREVIEW || child.state == State.BIG_ACTIVE ||
          child.state == State.BIG_INACTIVE || child.state == State.BIG_ATTACHED ||
          child.state == State.SELECTED) {

        return child;
      }
    }

    return null;
  }

  // ---------------------------------------------------------------------------
  public Vector get_absolute_position() {
    if (isRoot()) {
      return new Vector(relative_position_.x, relative_position_.y);
    } else {
      var position = parent_item.get_absolute_position();
      position.x += relative_position_.x;
      position.y += relative_position_.y;
      return position;
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  //                          private stuff                                   //
  //////////////////////////////////////////////////////////////////////////////


  ////////////////////////// member variables //////////////////////////////////

  // the menu of which this CircleMenuItem is a member
  private weak CircleMenu parent_menu_ = null;

  // text written on the item
  private Clutter.Text text_ = null;

  // textures of this actor
  private Clutter.Texture background_ = null;
  private Clutter.Texture foreground_ = null;

  // shading the foreground
  private Clutter.BrightnessContrastEffect hover_effect_ = null;

  // menu's position relative to its parent
  private Vector relative_position_ = new Vector(0, 0);

  // initial scale of the texture
  private const int SIZE = 256;

  // some predefined animation configurations
  private Animatable.Config animation_ease_ = new Animatable.Config.full(
    250, Clutter.AnimationMode.EASE_IN_OUT
  );

  private Animatable.Config animation_linear_ = new Animatable.Config.full(
    250, Clutter.AnimationMode.LINEAR
  );

  // preview mode
  private const float PREVIEW_DELAY = 0.5f;
  private bool preview_requested_ = false;
  private bool preview_interrupt_ = false;

  ////////////////////////// private methods ///////////////////////////////////

  /////////////////////////// event handling ///////////////////////////////////

  // ---------------------------------------------------------------------------
  private void on_key_down(Key key) {
    // initial click on root menu
    if (state == State.BIG_INACTIVE && !activated && foreground_.has_pointer) {
      activated = true;
      state = State.BIG_ACTIVE;

      foreach (var item in sub_menus) {
        item.state = State.SMALL_ACTIVE;
      }
    }
  }

  // ---------------------------------------------------------------------------
  private void on_key_up(Key key) {

    if (state == State.BIG_ATTACHED ||
        state == State.BIG_ACTIVE ||
        state == State.BIG_PREVIEW) {

      if (sub_menus.size > 0) {
        parent_menu_.cancel(1000);
      } else {
        parent_menu_.select(this, 1500);
      }
    }
  }

  // ---------------------------------------------------------------------------
  private void on_cancel() {

    cancel_preview();

    if (isRoot()) {
      state = State.BIG_INACTIVE;
    } else if (parent_item.isRoot()) {
      state = State.SMALL_INACTIVE;
    } else {
      state = State.HIDDEN;
    }

    GLib.Timeout.add(500, () => {
      state = State.FINAL;
      return false;
    });
  }

  // ---------------------------------------------------------------------------
  private void on_select() {
    if (state == State.BIG_INACTIVE ||
        state == State.BIG_ACTIVE ||
        state == State.BIG_PREVIEW ||
        state == State.BIG_ATTACHED ) {

      state = State.SELECTED;
    } else {
      state = State.HIDDEN;
    }

    GLib.Timeout.add(1000, () => {
      state = State.FINAL;
      return false;
    });
  }

  // ---------------------------------------------------------------------------
  private bool on_enter(Clutter.CrossingEvent event) {
    if (!isRoot()) {
      parent_menu_.foreground.set_child_above_sibling(foreground_, null);
    }
    return true;
  }

  // ---------------------------------------------------------------------------
  private bool on_leave(Clutter.CrossingEvent event) {
    return true;
  }

  // ---------------------------------------------------------------------------
  private bool on_motion(Clutter.MotionEvent event) {
    // on_mouse_move(event.x, event.y);

    return true;
  }

  // ---------------------------------------------------------------------------
  private void on_mouse_move(float x, float y) {

    if (state == State.BIG_ATTACHED) {

      var parent_pos = parent_item.get_absolute_position();
      var rel_pos_world_space = new Vector(x - parent_pos.x, y - parent_pos.y);

      set_relative_position(rel_pos_world_space);

      // if it's still attached
      if (state == State.BIG_ATTACHED) {

        // check whether mouse is still in child's sector --- if not, change
        // currently attached child
        int child_index = get_hovered_menu(rel_pos_world_space, parent_item);

        if (child_index >= 0 && parent_item.sub_menus.index_of(this) != child_index) {

          state = State.SMALL_INACTIVE;

          foreach (var child in sub_menus)
            child.state = State.HIDDEN;

          parent_item.sub_menus[child_index].state = State.BIG_ATTACHED;
          parent_item.sub_menus[child_index].set_relative_position(rel_pos_world_space);

        }
      }

    } else if (state == State.BIG_INACTIVE && get_selected_child() != null) {

      // check whether the cursor hovers over a previously selected item --- if
      // so, cancel all selected items up to the specific one and make this
      // active again
      var rel_pos = to_item_space(this, new Vector(x, y));
      if (rel_pos.length_sqr() < Math.powf(foreground_.width*0.5f, 2.0f)) {

        state = State.BIG_ACTIVE;

        foreach (var child in sub_menus) {
          child.state = State.SMALL_ACTIVE;

          foreach (var subchild in child.sub_menus) {
            subchild.recursive_hide();
          }
        }
      }
    } else if (state == State.BIG_ACTIVE || state == State.BIG_PREVIEW) {

      // check whether a submenu is hovered --- if so, attach it to the cursor
      if (sub_menus.size > 0) {

        var rel_pos = to_item_space(this, new Vector(x, y));

        if (rel_pos.length_sqr() > Math.powf(foreground_.width*0.5f, 2.0f)) {

          int child_index = get_hovered_menu(rel_pos, this);

          if (child_index >= 0) {

            state = State.BIG_INACTIVE;

            for (int i=0; i<sub_menus.size; ++i) {
              if (i==child_index) {
                sub_menus[i].state = State.BIG_ATTACHED;

                foreach (var child in sub_menus[i].sub_menus) {
                  child.state = State.SMALL_INACTIVE;
                }

              } else {
                sub_menus[i].state = State.SMALL_INACTIVE;
              }
            }
          }
        }
      }
    }
  }

  // ---------------------------------------------------------------------------
  private void schematize() {

    var child = get_selected_child();

    if (child != null) {

      int radius = 250;

      var perfect_child_pos = new Vector(
        GLib.Math.cosf(child.angle)*radius,
        GLib.Math.sinf(child.angle)*radius
      );

      var offset = Vector.direction(perfect_child_pos, child.relative_position_);

      child.set_relative_position(perfect_child_pos, animation_ease_);

      set_relative_position(new Vector(
        relative_position_.x + offset.x, relative_position_.y + offset.y
      ), animation_ease_);
    }

    if (!isRoot())
      parent_item.schematize();
  }

  // ---------------------------------------------------------------------------
  private void on_state_change() {

    switch (state) {
      case State.BIG_ATTACHED:
        set_text_visible(false);
        set_highlighted(true);
        set_scale(0.4f, animation_ease_);
        grab_global_mouse_events(true);
        break;

      case State.BIG_ACTIVE:
        set_text_visible(false);
        set_highlighted(true);
        set_scale(0.4f, animation_ease_);
        grab_global_mouse_events(true);
        request_preview();
        break;

      case State.BIG_INACTIVE:
        set_text_visible(true);
        set_highlighted(false);
        set_scale(0.4f, animation_ease_);
        grab_global_mouse_events(true);
        cancel_preview();
        break;

      case State.BIG_PREVIEW:
        set_text_visible(false);
        set_highlighted(true);
        set_scale(1.0f, animation_ease_);
        grab_global_mouse_events(true);
        break;

      case State.SMALL_ACTIVE:
        set_text_visible(false);
        set_highlighted(true);
        set_scale(0.2f, animation_ease_);
        set_relative_radius(50, animation_ease_);
        grab_global_mouse_events(false);
        cancel_preview();
        break;

      case State.SMALL_INACTIVE:
        set_text_visible(false);
        set_highlighted(false);
        set_scale(0.2f, animation_ease_);
        set_relative_radius(50, animation_ease_);
        grab_global_mouse_events(false);
        cancel_preview();
        break;

      case State.SMALL_PREVIEW:
        set_text_visible(true);
        set_highlighted(true);
        set_scale(0.4f, animation_ease_);
        set_relative_radius(110, animation_ease_);
        grab_global_mouse_events(false);
        cancel_preview();
        break;

      case State.SELECTED:
        set_text_visible(true);
        set_highlighted(true);
        set_scale(0.4f, animation_ease_);
        grab_global_mouse_events(false);
        cancel_preview();
        break;

      case State.HIDDEN:
        set_text_visible(false);
        set_highlighted(false);
        set_relative_radius(0.0f, animation_ease_);
        set_scale(0.0f, animation_ease_);
        grab_global_mouse_events(false);
        cancel_preview();
        break;

      case State.FINAL:
        set_text_visible(false);
        set_highlighted(true);
        grab_global_mouse_events(false);
        set_opacity(0);
        cancel_preview();
        break;
    }
  }

  ////////////////////////////// helper methods ////////////////////////////////

  // ---------------------------------------------------------------------------
  private void recursive_hide() {

    cancel_preview();
    state = State.HIDDEN;

    foreach (var child in sub_menus) {
      child.recursive_hide();
    }
  }

  // ---------------------------------------------------------------------------
  private void cancel_preview() {
    preview_interrupt_ = true;
    preview_requested_ = false;
  }

  // ---------------------------------------------------------------------------
  private void request_preview() {

    // only if there is no request pending already
    if (!preview_requested_ && sub_menus.size > 0) {
      preview_requested_ = true;
      preview_interrupt_ = false;

      GLib.Timeout.add((uint)(1000.0f*PREVIEW_DELAY), () => {

        // if there was no interupt
        if (!preview_interrupt_) {
          state = State.BIG_PREVIEW;
          foreach (var item in sub_menus)
            item.state = State.SMALL_PREVIEW;
        }

        preview_requested_ = false;

        return false;
      });
    }
  }

  // ---------------------------------------------------------------------------
  private void set_text_visible(bool visible) {
    animate(text_, "opacity", visible ? 255 : 0, animation_linear_);
  }

  // ---------------------------------------------------------------------------
  private void set_opacity(uint opacity) {
    animate(text_, "opacity", opacity, animation_linear_);
    animate(foreground_, "opacity", opacity, animation_linear_);
    animate(background_, "opacity", opacity, animation_linear_);
  }

  // ---------------------------------------------------------------------------
  private void set_highlighted(bool highlighted) {
    hover_effect_.set_brightness(highlighted ? 0.5f : 0.0f);
  }

  // ---------------------------------------------------------------------------
  private void set_relative_radius(
    float radius, Animatable.Config config = new Animatable.Config()) {

    if (!isRoot()) {
      var pos = new Vector(
        GLib.Math.cosf(angle)*radius,
        GLib.Math.sinf(angle)*radius
      );

      set_relative_position(pos, config);
    }
  }

  // ---------------------------------------------------------------------------
  private void set_relative_position(
    Vector position, Animatable.Config config = new Animatable.Config()) {

    relative_position_.x = position.x;
    relative_position_.y = position.y;

    var absolute_position = new Vector(0, 0);

    if (!isRoot()) {
      absolute_position = parent_item.get_absolute_position();
    }

    absolute_position.x += relative_position_.x;
    absolute_position.y += relative_position_.y;

    update_actor_positions(absolute_position, config);

    foreach (var item in sub_menus)
      item.on_parent_moved(absolute_position, config);
  }

  // ---------------------------------------------------------------------------
  private void on_parent_moved(Vector absolute_parent_position,
                               Animatable.Config config) {

    var absolute_position = new Vector(
      absolute_parent_position.x + relative_position_.x,
      absolute_parent_position.y + relative_position_.y
    );

    update_actor_positions(absolute_position, config);

    foreach (var item in sub_menus)
      item.on_parent_moved(absolute_position, config);
  }

  // ---------------------------------------------------------------------------
  private void set_scale(float scale,
                         Animatable.Config config = new Animatable.Config()) {

    text_.width = foreground_.width * scale * 0.9f;

    animate(background_, "scale_x", scale, config);
    animate(background_, "scale_y", scale, config);

    animate(foreground_, "scale_x", scale, config);
    animate(foreground_, "scale_y", scale, config);
  }

  // ---------------------------------------------------------------------------
  private void update_actor_positions(Vector absolute_position,
                                      Animatable.Config config) {

    animate(background_, "x", absolute_position.x - background_.width/2, config);
    animate(background_, "y", absolute_position.y - background_.height/2, config);

    animate(foreground_, "x", absolute_position.x - foreground_.width/2, config);
    animate(foreground_, "y", absolute_position.y - foreground_.height/2, config);

    animate(text_, "x", absolute_position.x - text_.width/2, config);
    animate(text_, "y", absolute_position.y - text_.height/2, config);
  }

  // ---------------------------------------------------------------------------
  private int get_hovered_menu(Vector direction, CircleMenuItem parent) {

    int children_count = parent.sub_menus.size;
    bool has_empty_sector = false;
    bool first_is_empty = false;

    if (!parent.isRoot()) {
      var siblings = parent.parent_item.sub_menus;
      if (siblings.last() == parent) {
        has_empty_sector = true;
        first_is_empty = true;
      } else if (siblings.first() == parent) {
        has_empty_sector = true;
      }
    }

    if (has_empty_sector) {
      children_count += 1;
    }

    var angle = Vector.angle(direction, new Vector(1, 0));

    if (direction.y < 0)
      angle = (float)(2*GLib.Math.PI) - angle;

    if (angle < GLib.Math.PI*0.5)
      angle += (float)(GLib.Math.PI*2.0);

    var child_angle = (float)(GLib.Math.PI/(children_count-1));
    var children_start = (float)(GLib.Math.PI - child_angle/2);

    float child_index = (angle - children_start) / child_angle;
    int child_index_clamped = (int)(child_index);

    if (child_index < 0.0f || child_index_clamped >= children_count) {
      return -1;
    }

    if (first_is_empty) {
      child_index_clamped -= 1;
    }

    if (child_index_clamped > parent.sub_menus.size - 1) {
      return -1;
    }

    return child_index_clamped;
  }

  // ---------------------------------------------------------------------------
  private Vector to_item_space(CircleMenuItem item, Vector position) {

    float x = 0.0f;
    float y = 0.0f;

    item.foreground_.transform_stage_point(position.x, position.y, out x, out y);

    return new Vector(
      (float)(x - item.foreground_.width/2),
      (float)(y - item.foreground_.height/2)
    );
  }

  // ---------------------------------------------------------------------------
  private bool load_texture(Clutter.Texture target, string path) {
    try {
      target.set_from_file(path);
      return true;

    } catch (GLib.Error e) {
      warning("Failed to set background image: " + e.message);
    }

    return false;
  }

  // ---------------------------------------------------------------------------
  private void grab_global_mouse_events(bool grab) {
    if (grab) {
      parent_menu_.window.on_mouse_move.connect(on_mouse_move);
      parent_menu_.window.on_key_up.connect(on_key_up);
      parent_menu_.window.on_key_down.connect(on_key_down);
    } else {
      parent_menu_.window.on_mouse_move.disconnect(on_mouse_move);
      parent_menu_.window.on_key_up.disconnect(on_key_up);
      parent_menu_.window.on_key_down.disconnect(on_key_down);
    }
  }
}

}
