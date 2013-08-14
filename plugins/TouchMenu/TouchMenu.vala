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

public class TouchMenu : MenuPlugin, Menu {

  //////////////////////////////////////////////////////////////////////////////
  //                         public interface                                 //
  //////////////////////////////////////////////////////////////////////////////

  /////////////////////////// public variables /////////////////////////////////

  public string name        { get; construct set; }
  public string version     { get; construct set; }
  public string author      { get; construct set; }
  public string email       { get; construct set; }
  public string homepage    { get; construct set; }
  public string description { get; construct set; }

  public string plugin_directory    { get; set; }

  public TouchMenuItem root         { public get; public set; default=null; }

  public Clutter.Actor background   { get; construct set; }
  public Clutter.Actor foreground   { get; construct set; }
  public Clutter.Actor text         { get; construct set; }

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
    foreground    = new Clutter.Actor();
    text          = new Clutter.Actor();
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
  }

  // ---------------------------------------------------------------------------
  public override void display(Vector position) {
    int w=0, h=0;
    window.get_size(out w, out h);
    mouse_layer_.width = w;
    mouse_layer_.height = h;
    mouse_layer_.z_position = -1.0f;

    var mouse_layer_canvas = new Clutter.Canvas();
    mouse_layer_canvas.set_size(w, h);
    mouse_layer_canvas.draw.connect(draw_background);
    mouse_layer_.set_content(mouse_layer_canvas);
    mouse_layer_canvas.invalidate();

    window.on_mouse_move.connect(on_mouse_move);

    window.get_stage().add_child(mouse_layer_);
    window.get_stage().add_child(background);
    window.get_stage().add_child(foreground);
    window.get_stage().add_child(text);

    base.display(position);
  }

  // ---------------------------------------------------------------------------
  public override void select(MenuItem item) {
    selected_ = true;
    mouse_layer_.content.invalidate();

    base.select(item);
  }

  // ---------------------------------------------------------------------------
  public override void close() {
    window.on_mouse_move.disconnect(on_mouse_move);

    window.get_stage().remove_child(mouse_layer_);
    window.get_stage().remove_child(background);
    window.get_stage().remove_child(foreground);
    window.get_stage().remove_child(text);

    base.close();
  }

  //////////////////////////////////////////////////////////////////////////////
  //                          private stuff                                   //
  //////////////////////////////////////////////////////////////////////////////

  ////////////////////////// member variables //////////////////////////////////

  private Clutter.Actor mouse_layer_ = null;
  private Vector[]      mouse_path_ = {};
  private bool          selected_ = false;

  ////////////////////////// private methods ///////////////////////////////////

  // ---------------------------------------------------------------------------
  private void on_mouse_move(float x, float y) {
    mouse_path_ += new Vector(x, y);
    mouse_layer_.content.invalidate();
  }

  // ---------------------------------------------------------------------------
  private bool draw_background(Cairo.Context ctx, int width, int height) {

    ctx.set_operator (Cairo.Operator.CLEAR);
    ctx.paint();
    ctx.set_operator (Cairo.Operator.OVER);

    if (selected_)  ctx.set_source_rgb(0.78, 0.78, 0.78);
    else            ctx.set_source_rgb(0.58, 0.58, 0.58);

    ctx.set_line_width(20.0);
    ctx.set_line_join(Cairo.LineJoin.ROUND);
    ctx.set_line_cap(Cairo.LineCap.ROUND);

    foreach (var pos in mouse_path_) {
      ctx.line_to(pos.x, pos.y);
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

    if (item.parent_item.sub_menus.index_of(item) == 0) {
      item_count += 1;
    } else if(item.parent_item.sub_menus.index_of(item) ==
              item.parent_item.sub_menus.size-1) {
      start_item += 1;
      item_count += 1;
    }

    for (int i=0; i<item.sub_menus.size; ++i) {
      item.sub_menus.get(i).angle = (float)((i + start_item)*GLib.Math.PI/
                                            (item_count-1) + GLib.Math.PI);

      adjust_child_angles(item.sub_menus.get(i));
    }
  }
}

}
