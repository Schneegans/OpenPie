/*
Copyright (c) 2011-2012 by Simon Schneegans

This program is free software: you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the Free
Software Foundation, either version 3 of the License, or (at your option)
any later version.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
more details.

You should have received a copy of the GNU General Public License along with
this program. If not, see <http://www.gnu.org/licenses/>.
*/

public class Vector : GLib.Object {
  public float x = 0;
  public float y = 0;
  
  public Vector(float x = 0, float y = 0) {
    this.x = x;
    this.y = y;
  }
  
  public float length() {
    return GLib.Math.sqrtf(length_sqr());
  }
  
  public float length_sqr() {
    return x*x + y*y;
  }
  
  public Vector copy() {
    return new Vector(x, y);
  }
  
  public void normalize() {
    float length = length();
    
    if (length > 0) {
      x /= length;
      y /= length;
    }
  }
  
  public void set_length(float length) {
    float curr_length = this.length();
    
    if (curr_length > 0) {
      x /= curr_length/length;
      y /= curr_length/length;
    }
  }
  
  public string to_string() {
    return "(%f, %f)".printf(x, y);
  }
  
  public static Vector direction(Vector from, Vector to) {
    return new Vector(to.x - from.x, to.y - from.y);
  }
  
  public static Vector sum(Vector a, Vector b) {
    return new Vector(a.x + b.x, a.y + b.y);
  }
  
  public static float distance(Vector from, Vector to) {
    return direction(from, to).length();
  }
  
  public static float angle(Vector a, Vector b) {
    return GLib.Math.acosf(dot(a, b)/(a.length() * b.length()));
  }
  
  public static float dot(Vector a, Vector b) {
    return a.x*b.x + a.y*b.y;
  }
}
