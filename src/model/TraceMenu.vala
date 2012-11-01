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
                
    public TraceMenuItem root { public get; private set; default = null;}
    
    public Vector origin { public get; public set; default = new Vector(-1, -1); }
    
    public Animator anim_alpha { public get; private set; default = null; }
    
    private AnimatorPool animations = null;
    
    construct {
        this.animations = new AnimatorPool();
    }
    
    public TraceMenu(MenuModel model) {
        this.anim_alpha = new Animator.linear(0.0, 0.5, 1.0);
        this.animations.add(this.anim_alpha);

        this.root = new TraceMenuItem(model);
        this.root.state = TraceMenuItem.State.ACTIVE;
    }
    
    public bool is_animating() {
        if (this.animations.is_active)
            return true;
    
        if (this.root.is_animating())
            return true;
                
        return false;
    }
    
    public void update_animations(double time) {
        this.animations.update(time);
        this.root.update_animations(time);
    }
    
    public void fade_out() {
        this.anim_alpha.reset_target(0.0, 1.0);
        this.root.fade_out();
    }
}    
    
}
