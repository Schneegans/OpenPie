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

public class TraceMenuItem : MenuItem, Animatable, Clutter.Group {

  //////////////////////////////////////////////////////////////////////////////
  //                          public interface                                //
  //////////////////////////////////////////////////////////////////////////////
  
  public string text  { get; set;  default = "Unnamed Item"; }
  public string icon  { get; set;  default = "none"; }
  public float  angle { get; set;  default = 0.0f; }  
  
  public weak TraceMenuItem           parent_item { get; set; default=null; }
  public Gee.ArrayList<TraceMenuItem> sub_menus   { get; set; default=null; }
  
  // initializes all members ---------------------------------------------------
  construct {
    
    //pick_with_alpha = true;

    sub_menus = new Gee.ArrayList<TraceMenuItem>();
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

    var trace_item = item as TraceMenuItem;
    trace_item.parent_item = this;
    sub_menus.add(trace_item);
  }
  
  // called prior to display() -------------------------------------------------
  public void init() {

    canvas_     = new Clutter.Canvas();
    canvas_.set_size(64, 64);
    canvas_.draw.connect(draw_background);
    canvas_.invalidate();
    
    background_ = new Clutter.Actor();
    background_.width = canvas_.width;
    background_.height = canvas_.height;
    background_.set_content(canvas_);
    background_.reactive = true;
    add_child(background_);
    
    text_       = new Clutter.Text.full("ubuntu", text, Clutter.Color.from_string("black"));
    text_.set_pivot_point(0.5f, 0.5f);
    text_.scale_x = 0.8;
    text_.scale_y = 0.8;
    add_child(text_);
    
    reactive = true;
    scale_x = 0.7;
    scale_y = 0.7;
    set_pivot_point(0.5f, 0.5f);
    
    width = canvas_.width;
    height = canvas_.height;
    
    if (!isRoot()) {
      var radius = 150;
      set_position(GLib.Math.sinf(angle) * radius, GLib.Math.cosf(angle) * radius);
    }
    
    foreach (var item in sub_menus) {
      item.init();
      add_child(item);
    }
  }
  
  // shows the MenuItem and all of it's sub menus on the screen ----------------
  public void display(Vector position) {
    
    if (isRoot()) {
      set_position(position.x - width/2, position.y - height/2);
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
  
  // sets the parent menu of this TraceMenuItem --------------------------------
  public void set_parent_menu(TraceMenu menu) {
    parent_menu_ = menu;
    foreach (var item in sub_menus)
      item.set_parent_menu(menu);
  }
  
  // returns true if this TraceMenuItem is not a child of any other item -------
  public bool isRoot() {
    return parent_item == null;
  }
  
  //////////////////////////////////////////////////////////////////////////////
  //                          private stuff                                   //
  //////////////////////////////////////////////////////////////////////////////
  
  // the menu of which this TraceMenuItem is a member
  private weak TraceMenu  parent_menu_ = null;
  private Clutter.Text    text_        = null;
  private Clutter.Actor   background_  = null;
  private Clutter.Canvas  canvas_      = null;
  
  private bool draw_background(Cairo.Context ctx, int width, int height) {

    ctx.set_operator (Cairo.Operator.CLEAR);
    ctx.paint();
    ctx.set_operator (Cairo.Operator.OVER);
    
    ctx.set_source_rgb(1, 1, 1);
    ctx.arc(width/2, height/2, width/2, 0, Math.PI*2.0);
    
    
    ctx.fill_preserve();
    
    ctx.set_source_rgb(0, 0, 0);
    ctx.stroke();
    
    return true;
  }
  
  // called when the mouse starts hovering the MenuItem ------------------------
  private bool on_enter(Clutter.CrossingEvent e) {
    animate(this, "scale_x", 1.0, 500, Clutter.AnimationMode.EASE_IN_OUT_BACK);
    animate(this, "scale_y", 1.0, 500, Clutter.AnimationMode.EASE_IN_OUT_BACK);
    animate(text_, "scale_x", 1.0, 500, Clutter.AnimationMode.EASE_IN_OUT_BACK);
    animate(text_, "scale_y", 1.0, 500, Clutter.AnimationMode.EASE_IN_OUT_BACK);
    return false;
  }
  
  // called when the mouse stops hovering the MenuItem -------------------------
  private bool on_leave(Clutter.CrossingEvent e) {
    animate(this, "scale_x", 0.7, 500, Clutter.AnimationMode.EASE_IN_OUT_BACK);
    animate(this, "scale_y", 0.7, 500, Clutter.AnimationMode.EASE_IN_OUT_BACK);
    animate(text_, "scale_x", 0.8, 500, Clutter.AnimationMode.EASE_IN_OUT_BACK);
    animate(text_, "scale_y", 0.8, 500, Clutter.AnimationMode.EASE_IN_OUT_BACK);
    return false;
  }
  
  // called when a mouse button is pressed hovering the MenuItem ---------------
  private bool on_button_press(Clutter.ButtonEvent e) {
    animate(text_, "opacity", 0, 500, Clutter.AnimationMode.EASE_IN_OUT);
    parent_menu_.select(this);
    return false;
  }
  
  // called when a mouse button is released hovering the MenuItem --------------
  private bool on_button_release(Clutter.ButtonEvent e) {
    return false;
  }
}
  
}
