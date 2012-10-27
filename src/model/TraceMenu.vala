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
    
    public enum State { ACTIVE, HOVERED, HOVERABLE, PREVIEW, SELECTED, INVISIBLE }
    
    public State state { public get {return this._state;} 
                         public set {this.update_state(value);} }
                         
    public string text { public get; 
                         private set; 
                         default = "Unnamed Item";}
                         
    public string icon { public get; 
                         private set; 
                         default = "none";}
                         
    public double angle { public get; 
                          private set; 
                          default = 0.0;}
                         
    public Gee.ArrayList<TraceMenu> children { public get; 
                                                    private set; 
                                                    default = null;}
    
    public Animator anim_distance { public get; private set; default = null;}
    public Animator anim_angle { public get; private set; default = null;}
    public Animator anim_radius { public get; private set; default = null;}
    
    private State _state = State.INVISIBLE;
    private AnimatorPool animations = null;
    
    construct {
        this.children = new Gee.ArrayList<TraceMenu>();
        this.animations = new AnimatorPool();
    }
    
    public TraceMenu(MenuModel model) {
        this.text = model.text;
        this.icon = model.icon;
        this.angle = model.angle;
        
        this.anim_distance = new Animator.cubic(Animator.Direction.IN_OUT, 0.0, 0.0, 1.0, 0.5);
        this.anim_angle = new Animator.cubic(Animator.Direction.IN_OUT, 0.0, this.angle, 1.0, 0.5);
        this.anim_radius = new Animator.cubic(Animator.Direction.IN_OUT, 0.0, 1.0, 1.0, 0.5);
        
        this.animations.add(this.anim_angle);
        this.animations.add(this.anim_radius);
        this.animations.add(this.anim_distance);
        
        foreach (var child in model.children)
            children.add(new TraceMenu(child));
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
    
    private void update_state(State new_state) {
    
        if (new_state != this.state) {
            switch (new_state) {
                case State.ACTIVE: {
                    foreach (var child in this.children)
                        child.state = State.HOVERABLE;
                    this.anim_radius.reset_target(40.0, 1.0);
                    this.anim_distance.reset_target(100.0, 1.0);
                } break;
                
                case State.HOVERED: {
                    foreach (var child in this.children)
                        child.state = State.PREVIEW;
                } break;
                
                case State.HOVERABLE: {
                    foreach (var child in this.children)
                        child.state = State.PREVIEW;
                    this.anim_radius.reset_target(20.0, 1.0);
                    this.anim_distance.reset_target(70.0, 1.0);
                } break;
                
                case State.PREVIEW: {
                    foreach (var child in this.children)
                        child.state = State.INVISIBLE;
                    this.anim_radius.reset_target(10.0, 1.0);
                    this.anim_distance.reset_target(30.0, 1.0);
                } break;
                
                case State.SELECTED: {
                    foreach (var child in this.children)
                        child.state = State.PREVIEW;
                    this.anim_radius.reset_target(20.0, 1.0);
                    this.anim_distance.reset_target(100.0, 1.0);
                } break;
                
                case State.INVISIBLE: {
                    this.anim_radius.reset_target(0.0, 1.0);
                    this.anim_distance.reset_target(20.0, 1.0);
                } break;
            }
        }
    }
}    
    
}
