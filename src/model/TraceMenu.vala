/* 
Copyright (c) 2011-2012 by Simon Schneegans

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

namespace OpenPie {

public class TraceMenu : GLib.Object {
                
    public Gee.ArrayList<TraceMenuItem> children { public get; 
                                                   private set; 
                                                   default = null;}
    
    public Vector origin { public get; public set; default = new Vector(-1, -1); }
    
    public Animator anim_alpha { public get; private set; default = null; }
    
    private AnimatorPool animations = null;
    
    construct {
        this.children = new Gee.ArrayList<TraceMenuItem>();
        this.animations = new AnimatorPool();
    }
    
    public TraceMenu(MenuModel model) {
        this.anim_alpha = new Animator.linear(0.0, 0.5, 1.0);
        this.animations.add(this.anim_alpha);

        foreach (var child in model.children) {
            children.add(new TraceMenuItem(child));
        }
        
        foreach (var child in children) {
            child.state = TraceMenuItem.State.HOVERABLE;
        }
    }
    
    public bool is_animating() {
        if (this.animations.is_active)
            return true;
    
        foreach (var child in this.children)
            if (child.is_animating())
                return true;
                
        return false;
    }
    
    public void update_animations(double time) {
        this.animations.update(time);
    
        foreach (var child in this.children)
            child.update_animations(time);
    }
    
    public void fade_out() {
        this.anim_alpha.reset_target(0.0, 1.0);
        
        foreach (var child in this.children)
            child.fade_out();
    }
}    
    
}
