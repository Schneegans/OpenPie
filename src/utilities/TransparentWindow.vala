/* 
Copyright (c) 2011 by Simon Schneegans

This program is free software: you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the Free
Software Foundation, either version 3 of the License, or (at your option)
any later version.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
more details.

You should have received a copy of the GNU General Public License along with
this program.  If not, see <http://www.gnu.org/licenses/>. 
*/        

using GLib.Math;

namespace OpenPie {

/////////////////////////////////////////////////////////////////////////    
///  An invisible window. Used to draw Pies onto.
/////////////////////////////////////////////////////////////////////////

public class TransparentWindow : Gtk.Window {

    public signal void on_mouse_move(double x, double y);
    
    /////////////////////////////////////////////////////////////////////
    /// The background image used for fake transparency if
    /// has_compositing is false.
    /////////////////////////////////////////////////////////////////////
    
    private Image background { get; private set; default=null; }
    
    /////////////////////////////////////////////////////////////////////
    /// A timer used for calculating the frame time.
    /////////////////////////////////////////////////////////////////////
    
    private GLib.Timer timer;
    
    /////////////////////////////////////////////////////////////////////
    /// True, if the screen supports compositing.
    /////////////////////////////////////////////////////////////////////
    
    private bool has_compositing = false;
    
    /////////////////////////////////////////////////////////////////////
    /// C'tor, sets up the window.
    /////////////////////////////////////////////////////////////////////

    public TransparentWindow() {
        this.set_skip_taskbar_hint(true);
        this.set_skip_pager_hint(true);
        this.set_keep_above(true);
        this.set_type_hint(Gdk.WindowTypeHint.POPUP_MENU);
        this.set_decorated(false);
        this.set_resizable(false);
        this.set_accept_focus(false);
        this.set_position(Gtk.WindowPosition.MOUSE);
        this.set_size_request(300, 300);
        
        // check for compositing
        if (this.screen.is_composited()) {
            #if HAVE_GTK_3
                this.set_visual(this.screen.get_rgba_visual());
            #else
                this.set_colormap(this.screen.get_rgba_colormap());
            #endif
            this.has_compositing = true;
        }
        
        // set up event filter
        this.add_events(Gdk.EventMask.BUTTON_RELEASE_MASK |
                        Gdk.EventMask.KEY_RELEASE_MASK |
                        Gdk.EventMask.KEY_PRESS_MASK |
                        Gdk.EventMask.POINTER_MOTION_MASK);

        this.button_release_event.connect ((e) => {

            return true;
        });
        
        this.button_press_event.connect ((e) => {
            this.cancel();
            return true;
        });
        
        this.key_press_event.connect((e) => {

            return true;
        });
        
        this.key_release_event.connect((e) => {

            return true;
        });
        
        this.motion_notify_event.connect((e) => {
            this.on_mouse_move(e.x, e.y);
            return true;
        });
        
        this.show.connect_after(() => {
            Gtk.grab_add(this);
            FocusGrabber.grab(this.get_window(), true, true, false);
        });

        // draw the pie on expose
        #if HAVE_GTK_3
            this.draw.connect(this.draw_window);
        #else
            this.expose_event.connect(this.draw_window);
        #endif
    }
    
    /////////////////////////////////////////////////////////////////////
    /// Opens the window. load_pie should have been called before.
    /////////////////////////////////////////////////////////////////////
    
    public void open() {
        this.realize();
        
        // capture the background image if there is no compositing
        if (!this.has_compositing) {
            int x, y, width, height;
            this.get_position(out x, out y);
            this.get_size(out width, out height);
            this.background = new Image.capture_screen(x, y, width+1, height+1);
        }
    
        // capture the input focus
        this.show();

        // start the timer
        this.timer = new GLib.Timer();
        this.timer.start();
        this.queue_draw();
        
        // the main draw loop
        GLib.Timeout.add((uint)(1000.0/30.0), () => {  
                              
            this.queue_draw();
            return this.visible;
        }); 
    }
    
    /////////////////////////////////////////////////////////////////////
    /// Opens the window at a given location.
    /////////////////////////////////////////////////////////////////////
    
    public void open_at(int at_x, int at_y) {
        this.open();
        this.move(at_x-this.width_request/2, at_y-this.height_request/2);
    }
    
    /////////////////////////////////////////////////////////////////////
    /// Gets the center position of the window.
    /////////////////////////////////////////////////////////////////////
    
    public void get_center_pos(out int out_x, out int out_y) {
        int x=0, y=0, width=0, height=0;
        this.get_position(out x, out y);
        this.get_size(out width, out height);
        
        out_x = x + width/2;
        out_y = y + height/2;
    }
    
    /////////////////////////////////////////////////////////////////////
    /// Draw the Pie.
    /////////////////////////////////////////////////////////////////////

    #if HAVE_GTK_3
        private bool draw_window(Cairo.Context ctx) { 
    #else
        private bool draw_window(Gtk.Widget da, Gdk.EventExpose event) {    
            // clear the window
            var ctx = Gdk.cairo_create(this.get_window());
    #endif
        // paint the background image if there is no compositing
        if (this.has_compositing) {
            ctx.set_operator (Cairo.Operator.CLEAR);
            ctx.paint();
            ctx.set_operator (Cairo.Operator.OVER);
        } else {
            ctx.set_operator (Cairo.Operator.OVER);
            ctx.set_source_surface(background.surface, -1, -1);
            ctx.paint();
        }

        // align the context to the center of the PieWindow
        ctx.translate(this.width_request*0.5, this.height_request*0.5);
        
        // get the mouse position
        double mouse_x = 0.0, mouse_y = 0.0;
        this.get_pointer(out mouse_x, out mouse_y);
        
        // store the frame time
        double frame_time = this.timer.elapsed();
        this.timer.reset();
        
        // render the Pie
        ctx.set_source_rgba(0, 0, 0, 0.5);
        ctx.paint();
        
        return true;
    }
    
    private void cancel() {
        Gtk.grab_remove(this);
        FocusGrabber.ungrab();
        this.destroy();
    }
}

}
