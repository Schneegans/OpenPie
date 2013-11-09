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

////////////////////////////////////////////////////////////////////////////////
// this method is called by the OpenPie Daemon when it registers the          //
// plugin. Name and signature of this method cannot be changed.               //
////////////////////////////////////////////////////////////////////////////////

public GLib.Type register_plugin(GLib.Module module) {
  return typeof (OpenPie.TouchMenu);
}

namespace OpenPie {

////////////////////////////////////////////////////////////////////////////////
// A TouchMenu is a special marking menu. When the user selects an item, a    //
// unique path is created on screen. The user may "draw" this path really     //
// quickly in order to select the according entry. That's not only fast ---   //
// that's also fun!                                                           //
////////////////////////////////////////////////////////////////////////////////

public class TouchMenu : MenuPlugin, Menu, Animatable {

  //////////////////////////////////////////////////////////////////////////////
  //                         public interface                                 //
  //////////////////////////////////////////////////////////////////////////////

  public static const int    MINIMUM_DISTANCE = 200;

  /////////////////////////// public variables /////////////////////////////////

  public string name        { get; construct set; }
  public string version     { get; construct set; }
  public string author      { get; construct set; }
  public string email       { get; construct set; }
  public string homepage    { get; construct set; }
  public string description { get; construct set; }

  public string plugin_directory    { get; set; default=""; }

  public TouchMenuItem root         { get; set; default=null; }

  public Clutter.Actor background   { get; construct set; default=null; }
  public Clutter.Actor text         { get; construct set; default=null; }

  public Cogl.Texture[] bg_textures { get; private set; default=null; }

  public bool          schematize   { get; construct set; default=false; }
  public bool          hide_mouse   { get; construct set; default=false; }

  //////////////////////////// public methods //////////////////////////////////

  // initializes all members ---------------------------------------------------
  construct {
    name        = "TouchMenu";
    version     = "0.1";
    author      = "Simon Schneegans";
    email       = "code@simonschneegans.de";
    homepage    = "http://www.simonschneegans.de";
    description = "A TouchMenu is a 180-degree-spherical marking menu. When the
                   user selects an item, a unique path is created on screen. The
                   user may \"draw\" this path really quickly in order to select
                   the according entry. That's not only fast --- that's also
                   fun!";

    mouse_layer_  = new Clutter.Actor();
    background    = new Clutter.Actor();
    text          = new Clutter.Actor();

    var settings  = new GLib.Settings("org.gnome.openpie.touchmenu");
    schematize    = settings.get_boolean("schematize");
    hide_mouse    = settings.get_boolean("hidemouse");
  }

  // ---------------------------------------------------------------------------
  public override MenuItem get_root() {
    return root;
  }

  // ---------------------------------------------------------------------------
  public override void set_content(string menu_description) {
    var loader = new MenuLoader.from_string(typeof(TouchMenuItem),
                                            menu_description);
    root = adjust_angles(loader.root as TouchMenuItem);
    root.set_parent_menu(this);

    bg_textures = new Cogl.Texture[7];
    bg_textures[0] = load_texture(plugin_directory + "/data/bg.png");
    bg_textures[1] = load_texture(plugin_directory + "/data/bg_00.png");
    bg_textures[2] = load_texture(plugin_directory + "/data/bg_45.png");
    bg_textures[3] = load_texture(plugin_directory + "/data/bg_90.png");
    bg_textures[4] = load_texture(plugin_directory + "/data/bg_135.png");
    bg_textures[5] = load_texture(plugin_directory + "/data/bg_180.png");
    bg_textures[6] = load_texture(plugin_directory + "/data/bg_item.png");
  }

  // ---------------------------------------------------------------------------
  public void hide_active_area_hint() {
    if (active_area_hint_visible_) {
      active_area_hint_visible_ = false;
      animate(active_area_hint_, "opacity", 0, animation_fast_);
      animate(active_area_hint_, "scale_x", 0.5f, animation_fast_);
      animate(active_area_hint_, "scale_y", 0.5f, animation_fast_);
    }
  }

  // ---------------------------------------------------------------------------
  public void show_active_area_hint(Vector position, float alpha) {

    if (!active_area_hint_visible_) {
      active_area_hint_visible_ = true;
      active_area_hint_.scale_x = 0.5f;
      active_area_hint_.scale_y = 0.5f;
      active_area_hint_.x = position.x - active_area_hint_.width/2;
      active_area_hint_.y = position.y - active_area_hint_.height/2;
    }

    animate(active_area_hint_, "scale_x", 1.0f + 0.3f * alpha, animation_fast_);
    animate(active_area_hint_, "scale_y", 1.0f + 0.3f * alpha, animation_fast_);

    animate(active_area_hint_, "opacity", 200 * alpha, animation_fast_);
    animate(active_area_hint_, "x", position.x - active_area_hint_.width/2, animation_fast_);
    animate(active_area_hint_, "y", position.y - active_area_hint_.height/2, animation_fast_);

  }

  // ---------------------------------------------------------------------------
  public override void display(Vector position) {


    int w=0, h=0;
    window.get_size(out w, out h);
    mouse_layer_.width = w;
    mouse_layer_.height = h;
    mouse_layer_.z_position = -1.0f;
    mouse_layer_.opacity = 0;
    animate(mouse_layer_, "opacity", 255, animation_slow_);

    try {
      active_area_hint_ = new Clutter.Texture.from_file(plugin_directory + "/data/active_area_hint.png");
    } catch (GLib.Error e) {
      warning("Failed to load image: " + e.message);
    }

    active_area_hint_.set_size(MINIMUM_DISTANCE*2, MINIMUM_DISTANCE*2);
    active_area_hint_visible_ = false;
    active_area_hint_.opacity = 0;
    active_area_hint_.z_position = -2.0f;
    active_area_hint_.scale_x = 0.5f;
    active_area_hint_.scale_y = 0.5f;
    active_area_hint_.x = position.x - active_area_hint_.width/2;
    active_area_hint_.y = position.y - active_area_hint_.height/2;
    active_area_hint_.set_pivot_point(0.5f, 0.5f);

    var mouse_layer_canvas = new Clutter.Canvas();
    mouse_layer_canvas.set_size(w, h);
    mouse_layer_canvas.draw.connect(draw_background);
    mouse_layer_.set_content(mouse_layer_canvas);
    mouse_layer_.content.invalidate();

    GLib.Timeout.add(32, () => {
    // Clutter.FrameSource.add(30, () => {
      if (!this.closed_) {
        this.mouse_layer_.content.invalidate();
      }

      return !this.closed_;
    });

    if (hide_mouse) {
      window.get_window().set_cursor(new Gdk.Cursor(Gdk.CursorType.BLANK_CURSOR));
    }

    window.on_mouse_move.connect(on_mouse_move);
    window.on_key_up.connect(on_key_up);

    window.get_stage().add_child(active_area_hint_);
    window.get_stage().add_child(mouse_layer_);
    window.get_stage().add_child(background);
    window.get_stage().add_child(text);

    var start = new Vector(w * 0.5f, h - 150.0f);

    mouse_path_ += start;
    mouse_path_ += start;

    base.display(start);
  }

  // ---------------------------------------------------------------------------
  public override void select(MenuItem item, uint close_delay) {
    selected_ = item as TouchMenuItem;

    GLib.Timeout.add(close_delay - 500, () => {
      animate(mouse_layer_, "opacity", 0, animation_slow_);
      return false;
    });

    hide_active_area_hint();

    base.select(item, close_delay);
  }

  // ---------------------------------------------------------------------------
  public override void close() {
    if (!closed_) {
      closed_ = true;

      window.on_mouse_move.disconnect(on_mouse_move);
      window.on_key_up.disconnect(on_key_up);

      window.get_stage().remove_child(active_area_hint_);
      window.get_stage().remove_child(mouse_layer_);
      window.get_stage().remove_child(background);
      window.get_stage().remove_child(text);
    }
    base.close();

    hide_active_area_hint();
  }

  //////////////////////////////////////////////////////////////////////////////
  //                          private stuff                                   //
  //////////////////////////////////////////////////////////////////////////////

  ////////////////////////// member variables //////////////////////////////////

  private Clutter.Actor   mouse_layer_                = null;
  private Clutter.Texture active_area_hint_           = null;
  private Vector[]        mouse_path_                 = {};
  private TouchMenuItem   selected_                   = null;
  private bool            closed_                     = false;
  private bool            active_area_hint_visible_   = false;

  // some predefined animation configurations
  private Animatable.Config animation_fast_ = new Animatable.Config.full(
    100, Clutter.AnimationMode.EASE_OUT
  );

  // some predefined animation configurations
  private Animatable.Config animation_slow_ = new Animatable.Config.full(
    500, Clutter.AnimationMode.LINEAR
  );

  ////////////////////////// private methods ///////////////////////////////////

  // ---------------------------------------------------------------------------
  private void on_mouse_move(float x, float y) {
    if (root.activated) {
      if (schematize) {
        mouse_path_[mouse_path_.length-1] = new Vector(x, y);
      } else {
        mouse_path_ += new Vector(x, y);
      }
    }
  }

  // ---------------------------------------------------------------------------
  private void on_key_up(Key key) {
    if (!key.with_mouse) {
      cancel(1000);
    }
  }

  // ---------------------------------------------------------------------------
  private void draw_line_to_item(TouchMenuItem item, Cairo.Context ctx)  {
    var pos = item.get_absolute_position_animated();
    ctx.line_to(pos.x, pos.y);

    var child = item.get_selected_child();
    if (child != null) {
      draw_line_to_item(child, ctx);
    }
  }

  // ---------------------------------------------------------------------------
  private bool draw_background(Cairo.Context ctx, int width, int height) {

    ctx.set_operator (Cairo.Operator.SOURCE);
    ctx.set_source_rgba(0, 0, 0, 0.4);
    ctx.paint();
    ctx.set_operator (Cairo.Operator.OVER);

    if (selected_ != null)  ctx.set_source_rgb(1.0, 1.0, 1.0);
    else                    ctx.set_source_rgb(1.0, 1.0, 1.0);

    ctx.set_line_width(25.0);
    ctx.set_line_join(Cairo.LineJoin.ROUND);
    ctx.set_line_cap(Cairo.LineCap.ROUND);

    if (mouse_path_.length > 0) {
      if (schematize) {

        draw_line_to_item(root, ctx);

      } else {
        foreach (var pos in mouse_path_) {
          ctx.line_to(pos.x, pos.y);
        }
      }
    }

    ctx.stroke();

    return true;
  }

  // distributes items equally over a half circle ------------------------------
  private TouchMenuItem adjust_angles(TouchMenuItem root_item) {

    int item_count = root_item.sub_menus.size;

    for (int i=0; i<item_count; ++i) {
      root_item.sub_menus.get(i).angle = (float)(i*GLib.Math.PI/(item_count-1) +
                                         GLib.Math.PI);

      if (root_item.sub_menus.get(i).sub_menus.size > 0)
        adjust_child_angles(root_item.sub_menus.get(i));
    }

    return root_item;
  }

  // distributes items equally over a half circle, -----------------------------
  // leaving one optional gap for the parent
  private void adjust_child_angles(TouchMenuItem item) {

    int item_count = item.sub_menus.size;
    int start_item = 0;
    double e = 0.00001;

    if (item.angle < GLib.Math.PI+e || item.angle > 2*GLib.Math.PI-e) {
      if (item.parent_item.sub_menus.index_of(item) == 0) {
        item_count += 1;
      } else if(item.parent_item.sub_menus.index_of(item) ==
                item.parent_item.sub_menus.size-1) {
        start_item += 1;
        item_count += 1;
      }
    }

    for (int i=0; i<item.sub_menus.size; ++i) {
      item.sub_menus.get(i).angle = (float)((i + start_item)*GLib.Math.PI/
                                            (item_count-1) + GLib.Math.PI);

      adjust_child_angles(item.sub_menus.get(i));
    }
  }

  // ---------------------------------------------------------------------------
  private Cogl.Texture load_texture(string path) {
    try {
      return new Cogl.Texture.from_file(
        path, Cogl.TextureFlags.NONE, Cogl.PixelFormat.ANY
      );

    } catch (GLib.Error e) {
      warning("Failed to load image: " + e.message);
    }

    return new Cogl.Texture.with_size(
      64, 64, Cogl.TextureFlags.NONE, Cogl.PixelFormat.ANY
    );
  }
}

}
