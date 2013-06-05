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

using GLib.Math;

namespace OpenPie {

//////////////////////////////////////////////////////////////////////////////// 
///  An invisible window. Used to draw Pies onto.                             //
//////////////////////////////////////////////////////////////////////////////// 

public class TransparentWindow : Gtk.Window {

  //////////////////////////////////////////////////////////////////////////////
  //              public interface                                            //        
  //////////////////////////////////////////////////////////////////////////////
  
  // those get emitted when the according action occurs
  public signal void on_mouse_move(float x, float y);
  public signal void on_key_down(Key key);
  public signal void on_key_up(Key key);
  public signal void on_draw(Cairo.Context ctx, double time);
  
  // C'tor, sets up the window.
  public TransparentWindow() {
    set_skip_taskbar_hint(true);
    set_skip_pager_hint(true);
    set_keep_above(true);
    set_type_hint(Gdk.WindowTypeHint.POPUP_MENU);
    set_decorated(false);
    set_resizable(false);
    set_app_paintable(true);
    icon_name = "gnome-pie";
    set_accept_focus(false);
    
    // check for compositing
    if (screen.is_composited()) {
      set_visual(screen.get_rgba_visual());
      has_compositing_ = true;
    }
    
    // set up event filter
    add_events(Gdk.EventMask.BUTTON_RELEASE_MASK |
           Gdk.EventMask.KEY_RELEASE_MASK |
           Gdk.EventMask.KEY_PRESS_MASK |
           Gdk.EventMask.POINTER_MOTION_MASK |
           Gdk.EventMask.TOUCH_MASK);
    
    var clutter_embed = new GtkClutter.Embed() {
      width_request = Gdk.Screen.width(),
      height_request = Gdk.Screen.height()
    };
                
    add(clutter_embed);
    
    stage_ = clutter_embed.get_stage() as Clutter.Stage;
    stage_.use_alpha = true;
    stage_.background_color = Clutter.Color() {red = 0, green = 0, 
                                               blue = 0, alpha = 0};
    
    button_press_event.connect((e) => {
      on_key_down(new Key.from_mouse(e.button, e.state));
      return true;
    });
    
    button_release_event.connect((e) => {
      on_key_up(new Key.from_mouse(e.button, e.state));
      return true;
    });
    
    key_press_event.connect((e) => {
      on_key_down(new Key.from_keyboard(e.keyval, e.state));
      return true;
    });
    
    key_release_event.connect((e) => {
      on_key_up(new Key.from_keyboard(e.keyval, e.state));
      return true;
    });
    
    touch_event.connect((e) => {
      debug("touch");
      return true;
    });
    
    motion_notify_event.connect((e) => {
      on_mouse_move((float)e.x, (float)e.y);
      return true;
    });
    
    realize(); 
  }
  
  public void add_actor(Clutter.Actor actor) {
    stage_.add_child(actor);
  }
  
  public void remove_actor(Clutter.Actor actor) {
    stage_.remove_child(actor);
  }
  
  // Gets the center position of the window.
  public Vector get_center_pos() {
    int x=0, y=0, width=0, height=0;
    get_position(out x, out y);
    get_size(out width, out height);
    
    return new Vector(x + width/2, y + height/2);
  }
  
  // grabs the input focus
  public void add_grab() {
    ClutterUtils.animate(stage_, "background_color", 
               Clutter.Color() {red = 0, green = 0, blue = 0, alpha = 128},
               Clutter.AnimationMode.LINEAR, 500);
  
    Gtk.grab_add(this);
    FocusGrabber.grab(get_window(), true, true, false);
  }
  
  // releases the input focus
  public void remove_grab() { 
    ClutterUtils.animate(stage_, "background_color", 
               Clutter.Color() {red = 0, green = 0, blue = 0, alpha = 0},
               Clutter.AnimationMode.LINEAR, 1000);
  
    Gtk.grab_remove(this);
    FocusGrabber.ungrab();
    get_window().input_shape_combine_region(new Cairo.Region(), 0, 0);
  }
  
  //////////////////////////////////////////////////////////////////////////////
  //              private stuff                                               //
  //////////////////////////////////////////////////////////////////////////////
  
  // The background image used for fake transparency if
  // has_compositing_ is false.
  private Image background_ { get; private set; default=null; }
  
  // True, if the screen supports compositing.
  private bool has_compositing_ = false;
  
  // The embedded clutter stage
  private Clutter.Stage stage_ = null;
}

}
